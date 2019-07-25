using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace NPR.CRC.Library
{
    public static class DataParser
    {
        public static int? GetNullableInteger(DataRow row, string key)
        {
            if (row.Table.Columns.Contains(key))
            {
                int parseValue;
                if (row[key] != null && Int32.TryParse(row[key].ToString(), out parseValue))
                {
                    return (int?)parseValue;
                }
            }

            return null;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="row"></param>
        /// <param name="key"></param>
        /// <returns></returns>
        public static long? GetNullableLong(DataRow row, string key)
        {
            if (row.Table.Columns.Contains(key))
            {
                long parseValue;
                if (row[key] != null && long.TryParse(row[key].ToString(), out parseValue))
                {
                    return (long?)parseValue;
                }
            }

            return null;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="data"></param>
        /// <returns></returns>
        public static long? GetNullableLong(string data)
        {
            long number;
            if (long.TryParse(data, out number))
            {
                return (long?)number;
            }
            else
            {
                return null;
            }
        }

        public static long GetLong(string data)
        {
            return long.Parse(data);
        }

        public static int GetInt(string data)
        {
            return int.Parse(data);
        }

        public static int? GetNullableInt(string data)
        {
            int number;
            if (int.TryParse(data, out number))
            {
                return (int?)number;
            }
            else
            {
                return null;
            }
        }

        public static DateTime? GetNullableDateTime(string data)
        {
            DateTime date;
            if (DateTime.TryParse(data, out date))
            {
                return date;
            }
            else
            {
                return null;
            }
        }

        public static string GetNullableDate(string data)
        {
            DateTime date;
            if (DateTime.TryParse(data, out date))
            {
                return date.ToString("d");
            }
            else
            {
                return null;
            }
        }

        public static bool GetBool(string data)
        {
            return bool.Parse(data);
        }

        public static Guid GetGuid(string data)
        {
            return new Guid(data);
        }

        public static char GetDbValue(bool value)
        {
            return value ? 'Y' : 'N';
        }

        public static object GetDbValue(string value)
        {
            return value != null ? (object)value : (object)DBNull.Value;
        }

        public static object GetDbValue(DateTime? value)
        {
            return value != null ? (object)value : (object)DBNull.Value;
        }

        public static object GetDbValue(int value)
        {
            return value > -1 ? (object)value : (object)DBNull.Value;
        }

        public static object GetDbValue(long value)
        {
            return value > -1 ? (object)value : (object)DBNull.Value;
        }

        public static object GetDbValue(long? value)
        {
            return value.HasValue && value > -1 ? (object)value.Value : (object)DBNull.Value;
        }

        public static object GetDbValue(int? value)
        {
            return value.HasValue && value > -1 ? (object)value : (object)DBNull.Value;
        }

        public static object GetDbValueAllowNegative(int? value)
        {
            return value.HasValue ? (object)value : DBNull.Value;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="row"></param>
        /// <param name="key"></param>
        /// <returns></returns>
        public static bool? GetNullableBoolean(DataRow row, string key)
        {
            if (row.Table.Columns.Contains(key))
            {
                if (row[key] != null && row[key].ToString().Equals("Y", StringComparison.CurrentCultureIgnoreCase))
                {
                    return (bool?)true;
                }
                else if (row[key] != null && row[key].ToString().Equals("N", StringComparison.CurrentCultureIgnoreCase))
                {
                    return (bool?)false;
                }

            }

            return null;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static bool? GetNullableBoolean(string value)
        {
            if ((!String.IsNullOrEmpty(value) && value.Equals("Y", StringComparison.CurrentCultureIgnoreCase))
                || (!String.IsNullOrEmpty(value) && value.Equals("true", StringComparison.CurrentCultureIgnoreCase)))
            {
                return (bool?)true;
            }
            else if ((!String.IsNullOrEmpty(value) && value.Equals("N", StringComparison.CurrentCultureIgnoreCase)) ||
                (!String.IsNullOrEmpty(value) && value.Equals("false", StringComparison.CurrentCultureIgnoreCase)))
            {
                return (bool?)false;
            }
            else
            {
                return null;
            }
        }

        public static DateTime GetDateTime(DataRow row, string key)
        {
            return DateTime.Parse(row[key].ToString());
        }

        public static DateTime? GetNullableDateTime(DataRow row, string key)
        {
            if (row.Table.Columns.Contains(key))
            {
                if (row[key] != null)
                {
                    return row[key] as DateTime?;
                }

            }

            return null;
        }

        public static DateTime GetDateTime(string value)
        {
            return DateTime.Parse(value);
        }

        public static DateTime GetDateTime(string date, string time)
        {
            return DateTime.Parse(date + " " + time);
        }

        public static char GetChar(DataRow row, string key)
        {
            return Char.Parse(row[key].ToString());
        }

        public static string FormatDate(DataRow row, string key)
        {
            DateTime date;
            if (DateTime.TryParse(row[key].ToString(), out date))
            {
                return date.ToString("MM/dd/yyyy");
            }
            else
            {
                return null;
            }
        }

        public static string ParseDate(DataRow row, string key)
        {
            return row[key].ToString().Length > 0
                ? ((DateTime)row[key]).ToString("d")
                : string.Empty;
        }

        public static string[] ParseJsonStringToArray(string jsonString)
        {
            return ParseJsonStringToArray(jsonString, true);
        }

        public static DateTime ParseDateTime(string value)
        {
            int timeStamp = Int32.Parse(value);
            return new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Local).AddSeconds(timeStamp).Date;
        }

        public static DateTime? ParseNullableDateTime(string value)
        {
            return ParseNullableDateTime(value, true);
        }

        public static DateTime? ParseNullableDateTime(string value, bool enforceSqlDateTimeRange)
        {
            DateTime parsedDateTime;
            if (DateTime.TryParse(value, out parsedDateTime))
            {
                if (enforceSqlDateTimeRange)
                {
                    if (parsedDateTime >= new DateTime(1753, 1, 1) &&
                        parsedDateTime <= new DateTime(9999, 12, 31))
                    {
                        return parsedDateTime;
                    }
                }
                else
                {
                    return parsedDateTime;
                }
            }

            return (DateTime?)null;
        }

        public static bool? ParseNullableBoolean(string value)
        {
            bool parsedBoolean;
            return bool.TryParse(value, out parsedBoolean) ? parsedBoolean : (bool?)null;
        }

        public static string ParseDateAndTimeToString(DataRow row, string dateKey, string timeKey)
        {
            DateTime date = DateTime.Parse(GetDateTime(row, dateKey).ToString("MM/dd/yyyy") + " " + row[timeKey].ToString());
            return date.ToString("yyyy-MM-dd HH:mm");
        }

        public static string ParseDateAndTimeToString(DataRow row, DateTime date, string timeKey)
        {
            DateTime returnDate = DateTime.Parse(date.ToString("MM/dd/yyyy") + " " + row[timeKey].ToString());
            return returnDate.ToString("yyyy-MM-dd HH:mm");
        }

        public static string[] ParseJsonStringToArray(string jsonString, bool ignoreEmpty)
        {
            string pattern = "\\[\\\\\"|\\\\\",\\\\\"|\",\"\\[\\\"|\",\"|\\[\"|\"\\]|\\\\";
            string[] returnStrings = Regex.Split(jsonString, pattern);
            if (ignoreEmpty)
            {
                return returnStrings.Where(x => !String.IsNullOrEmpty(x)).Select(x => x.Trim()).ToArray();
            }
            else
            {
                return returnStrings;
            }
        }

        public static string[][] ParseJsonStringTo2DArray(string jsonStrings)
        {
            string pattern = "\"\\],\\[\"|\"\\]|\\[\"";
            string[] rows = Regex.Split(jsonStrings, pattern).Where(x => !String.IsNullOrEmpty(x)).ToArray();
            string[][] returnStrings = new string[rows.Length - 1][];
            for (int i = 1; i < rows.Length; i++)
            {
                string[] parsedValues = ParseJsonStringToArray(rows[i], false);
                returnStrings[i - 1] = parsedValues.Where((x, index) => index > 1 && index != parsedValues.Length - 1).Select(x => "\"" + x + "\"").ToArray();
            }
            return returnStrings;
        }

        public static TimeSpan ParseTimeSpan(string data)
        {
            var dt = DateTime.ParseExact(data, data.Length > 7 ? "hh:mm tt" : "h:mm tt", System.Globalization.CultureInfo.InvariantCulture);
            return dt.TimeOfDay;
        }

        public static byte? GetNullableByte(string data)
        {
            byte content;
            if (byte.TryParse(data, out content))
            {
                return (byte?)content;
            }
            else
            {
                return null;
            }
        }

        public static decimal? GetNullableDecimal(string data)
        {
            decimal content;
            if (decimal.TryParse(data, out content))
            {
                return (decimal?)content;
            }
            else
            {
                return null;
            }
        }

        public static decimal? GetNullableDecimal(DataRow row, string dateKey)
        {
            decimal content;
            if (row[dateKey] != null && decimal.TryParse(row[dateKey].ToString(), out content))
            {
                return (decimal?)content;
            }
            else
            {
                return null;
            }
        }

        public static decimal GetDecimal(string data)
        {
            return decimal.Parse(data);
        }

        public static string ParseTimeSpanToString(string timeSpan)
        {
            var date = DateTime.Parse("1/1/2001" + " " + timeSpan);
            return date.ToString("h:mm tt");
        }
    }
}
