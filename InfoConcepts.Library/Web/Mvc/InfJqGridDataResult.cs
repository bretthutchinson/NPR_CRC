using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using MvcJqGrid;
using Newtonsoft.Json;
using InfoConcepts.Library.Extensions;

namespace InfoConcepts.Library.Web.Mvc
{
    [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1709:IdentifiersShouldBeCasedCorrectly", MessageId = "Jq")]
    public class InfJqGridDataResult : ActionResult
    {
        #region Enums

        private enum FilterValueQuoteType
        {
            None,
            DateTime,
            String
        }

        #endregion

        #region Fields

        private DataTable _gridData;
        private GridSettings _gridSettings;
        private int _filteredRecordCount;

        private static Type[] _numericTypes = new[]
        {
            typeof(sbyte), typeof(byte),
            typeof(short), typeof(ushort),
            typeof(int), typeof(uint),
            typeof(long), typeof(ulong),
            typeof(float), typeof(double), typeof(decimal)
        };

        #endregion

        #region Constructors

        public InfJqGridDataResult(DataTable gridData, GridSettings gridSettings)
        {
            if (gridData == null)
            {
                throw new ArgumentNullException("gridData");
            }

            if (gridSettings == null)
            {
                throw new ArgumentNullException("gridSettings");
            }

            this._gridData = gridData;
            this._gridSettings = gridSettings;
        }

        public InfJqGridDataResult(IEnumerable gridData, GridSettings gridSettings)
            : this(gridData.ToDataTable(), gridSettings)
        {
        }

        #endregion

        #region Public Methods

        public override void ExecuteResult(ControllerContext context)
        {
            if (context == null)
            {
                throw new ArgumentNullException("context");
            }

            FilterData();
            SortData();
            PageData();

            var response = context.HttpContext.Response;
            response.ContentType = "application/json";

            var json = JsonConvert.SerializeObject(new
            {
                total = (int)Math.Ceiling((double)_filteredRecordCount / _gridSettings.PageSize),
                page = _gridSettings.PageIndex,
                records = _filteredRecordCount,
                rows = _gridData
            });

            response.Write(json);
        }

        #endregion

        #region Private Methods

        private void FilterData()
        {
            if (_gridSettings.Where != null &&
                _gridSettings.Where.rules != null &&
                _gridSettings.Where.rules.Length > 0)
            {
                using (var dataView = new DataView(_gridData))
                {
                    var filter = new StringBuilder();

                    foreach (var rule in _gridSettings.Where.rules)
                    {
                        if (!_gridData.Columns.Contains(rule.field))
                        {
                            var message = string.Format(CultureInfo.InvariantCulture, "Column \"{0}\" does not exist in table.", rule.field);
                            throw new InvalidOperationException(message);
                        }

                        if (filter.Length > 0)
                        {
                            filter.AppendFormat(CultureInfo.InvariantCulture, " {0} ", _gridSettings.Where.groupOp);
                        }

                        var quoteType = GetFilterValueQuoteType(_gridData.Columns[rule.field]);
                        filter.Append(FormatFilterLeftSide(rule.field, rule.op, quoteType));
                        filter.Append(GetFilterOperator(rule.op));
                        filter.Append(FormatFilterRightSide(rule.data, rule.op, quoteType));
                    }

                    dataView.RowFilter = filter.ToString();
                    _gridData = dataView.ToTable();
                }
            }

            _filteredRecordCount = _gridData.Rows.Count;
        }

        private void SortData()
        {
            if (!string.IsNullOrEmpty(_gridSettings.SortColumn))
            {
                using (var dataView = new DataView(_gridData))
                {
                    dataView.Sort = _gridSettings.SortColumn + " " + _gridSettings.SortOrder;
                    _gridData = dataView.ToTable();
                }
            }
        }

        private void PageData()
        {
            if (_gridData.Rows.Count > 0)
            {
                _gridData = _gridData
                    .AsEnumerable()
                    .Skip(_gridSettings.PageSize * (_gridSettings.PageIndex - 1))
                    .Take(_gridSettings.PageSize)
                    .CopyToDataTable();
            }
        }

        private static FilterValueQuoteType GetFilterValueQuoteType(DataColumn column)
        {
            if (column.DataType.IsIn(_numericTypes))
            {
                return FilterValueQuoteType.None;
            }
            else if (column.DataType == typeof(DateTime))
            {
                return FilterValueQuoteType.DateTime;
            }
            else
            {
                return FilterValueQuoteType.String;
            }
        }

        private static string GetFilterOperator(string operatorCode)
        {
            switch (operatorCode.ToUpperInvariant())
            {
                case "EQ":
                    return " = ";
                case "NE":
                    return " <> ";
                case "LT":
                    return " < ";
                case "LE":
                    return " <= ";
                case "GT":
                    return " > ";
                case "GE":
                    return " >= ";
                case "BW":
                case "EW":
                case "CN":
                    return " LIKE ";
                case "BN":
                case "EN":
                case "NC":
                    return "NOT LIKE ";
                default:
                    throw new NotImplementedException(string.Format(CultureInfo.InvariantCulture, "The \"{0}\" operator is not currently supported.", operatorCode));
            }
        }

        private static string FormatFilterLeftSide(string field, string operatorCode, FilterValueQuoteType quoteType)
        {
            if (operatorCode.ToUpperInvariant().IsIn("BW", "BN", "EW", "EN", "CN", "NC"))
            {
                if (quoteType != FilterValueQuoteType.String)
                {
                    return string.Format(CultureInfo.InvariantCulture, "Convert({0}, '{1}')", field, typeof(string).FullName);
                }
            }

            return field;
        }

        private static string FormatFilterRightSide(string value, string operatorCode, FilterValueQuoteType quoteType)
        {
            if (operatorCode.ToUpperInvariant().IsIn("EQ", "NE", "LT", "LE", "GT", "GE"))
            {
                switch (quoteType)
                {
                    case FilterValueQuoteType.None:
                        return value;
                    case FilterValueQuoteType.DateTime:
                        return FormatFilterDateTimeValue(value);
                    default:
                        return FormatFilterStringValue(value);
                }
            }
            else
            {
                switch (operatorCode.ToUpperInvariant())
                {
                    case "BW":
                    case "BN":
                        return FormatFilterStringValue(value, false, true);
                    case "EW":
                    case "EN":
                        return FormatFilterStringValue(value, true, false);
                    default:
                        return FormatFilterStringValue(value, true, true);
                }
            }
        }

        private static string FormatFilterDateTimeValue(string value)
        {
            return string.Format(CultureInfo.InvariantCulture, "#{0}#", value);
        }

        private static string FormatFilterStringValue(string value)
        {
            return FormatFilterStringValue(value, false, false);
        }

        private static string FormatFilterStringValue(string value, bool wildcardBefore, bool wildcardAfter)
        {
            var sb = new StringBuilder();

            sb.Append("'");
            if (wildcardBefore)
            {
                sb.Append("%");
            }
            sb.Append(value);
            if (wildcardAfter)
            {
                sb.Append("%");
            }
            sb.Append("'");

            return sb.ToString();
        }

        #endregion
    }
}
