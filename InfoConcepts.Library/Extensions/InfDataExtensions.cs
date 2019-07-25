using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Web.Mvc;
using System.Reflection;
using System.Globalization;

namespace InfoConcepts.Library.Extensions
{
    public static class InfDataExtensions
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1006:DoNotNestGenericTypesInMemberSignatures")]
        public static IList<Dictionary<string, object>> ToJson(this IEnumerable<DataRow> source)
        {
            var json = new List<Dictionary<string, object>>();

            foreach (var row in source)
            {
                var item = new Dictionary<string, object>();

                foreach (DataColumn column in row.Table.Columns)
                {
                    item.Add(column.ColumnName, row[column]);
                }

                json.Add(item);
            }

            return json;
        }

        public static IEnumerable<SelectListItem> ToSelectListItems(this DataTable source)
        {
            var valueColumnName = source.Columns[0].ColumnName;
            var textColumnName = source.Columns.Count > 1 ? source.Columns[1].ColumnName : source.Columns[0].ColumnName;

            return source.ToSelectListItems(valueColumnName, textColumnName);
        }

        public static IEnumerable<SelectListItem> ToSelectListItems(this DataTable source, string valueColumnName, string textColumnName)
        {
            return source
                .AsEnumerable()
                .Select(row =>
                    new SelectListItem
                    {
                        Value = row[valueColumnName].ToString(),
                        Text = row[textColumnName].ToString()
                    });
        }

        public static IDictionary<string, object> ToDictionary(this DataRow source)
        {
            var dictionary = new Dictionary<string, object>();

            foreach (DataColumn column in source.Table.Columns)
            {
                dictionary[column.ColumnName] = source[column];
            }

            return dictionary;
        }

        // todo: refactor
        public static void MapTo<T>(this DataRow source, T entity)
        {
            if (source != null && entity != null)
            {
                var type = typeof(T);
                var properties = type.GetProperties(BindingFlags.Public | BindingFlags.Instance);

                foreach (DataColumn column in source.Table.Columns)
                {
                    var property = properties.FirstOrDefault(p => p.Name.Equals(column.ColumnName, StringComparison.OrdinalIgnoreCase));
                    if (property != null && property.CanWrite)
                    {
                        if (source[column] == DBNull.Value)
                        {
                            property.SetValue(entity, null);
                        }
                        else
                        {
                            var propertyType = property.PropertyType;

                            var underlyingType = Nullable.GetUnderlyingType(propertyType);
                            if (underlyingType != null)
                            {
                                propertyType = underlyingType;
                            }

                            object value;

                            if (propertyType == typeof(bool) &&
                                column.DataType.IsIn(typeof(char), typeof(string)))
                            {
                                value = source[column]
                                    .ToString()
                                    .ToUpperInvariant()
                                    .IsIn("Y", "TRUE");
                            }
                            else
                            {
                                value = Convert.ChangeType(
                                    source[column],
                                    propertyType,
                                    CultureInfo.InvariantCulture);
                            }

                            property.SetValue(entity, value);
                        }
                    }
                }
            }
        }

        public static T ToEntity<T>(this DataRow source) where T : new()
        {
            var entity = new T();

            if (source != null)
            {
                source.MapTo(entity);
            }

            return entity;
        }

        // todo: refactor
        public static IEnumerable<T> ToEntityList<T>(this DataTable source) where T : new()
        {
            if (source != null)
            {
                var type = typeof(T);
                var properties = type.GetProperties(BindingFlags.Public | BindingFlags.Instance);

                foreach (DataRow row in source.Rows)
                {
                    var entity = new T();

                    foreach (DataColumn column in source.Columns)
                    {
                        var property = properties.FirstOrDefault(p => p.Name.Equals(column.ColumnName, StringComparison.OrdinalIgnoreCase));
                        if (property != null && property.CanWrite)
                        {
                            if (row[column] == DBNull.Value)
                            {
                                property.SetValue(entity, null);
                            }
                            else
                            {
                                var propertyType = property.PropertyType;

                                var underlyingType = Nullable.GetUnderlyingType(propertyType);
                                if (underlyingType != null)
                                {
                                    propertyType = underlyingType;
                                }

                                object value;

                                if (propertyType == typeof(bool) &&
                                    column.DataType.IsIn(typeof(char), typeof(string)))
                                {
                                    value = row[column]
                                        .ToString()
                                        .ToUpperInvariant()
                                        .IsIn("Y", "TRUE");
                                }
                                else
                                {
                                    value = Convert.ChangeType(
                                        row[column],
                                        propertyType,
                                        CultureInfo.InvariantCulture);
                                }

                                property.SetValue(entity, value);
                            }
                        }
                    }

                    yield return entity;
                }
            }
        }
    }
}
