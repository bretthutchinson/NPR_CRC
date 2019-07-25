using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Reflection;
using System.Web.Mvc;

namespace InfoConcepts.Library.Extensions
{
    public static class InfCollectionExtensions
    {
        public static bool IsIn<T>(this T item, IEnumerable<T> list)
        {
            return list.Any(x => x.Equals(item));
        }
        
        public static bool IsIn<T>(this T item, params T[] list)
        {
            return item.IsIn(list.AsEnumerable());
        }

        public static DataTable ToDataTable<T>(this IEnumerable<T> source)
        {
            var itemType = typeof(T);
            var properties = itemType.GetProperties(BindingFlags.Public | BindingFlags.Instance);

            using (var dataTable = new DataTable())
            {
                dataTable.Locale = CultureInfo.InvariantCulture;
                dataTable.TableName = itemType.Name;

                foreach (var property in properties)
                {
                    var propertyType = property.PropertyType;

                    if (propertyType.IsGenericType &&
                        propertyType.GetGenericTypeDefinition().Equals(typeof(Nullable<>)))
                    {
                        propertyType = new NullableConverter(propertyType).UnderlyingType;
                    }

                    var indexParameters = property.GetIndexParameters();
                    if (indexParameters == null || indexParameters.Length < 1)
                    {
                        if (!dataTable.Columns.Contains(property.Name))
                        {
                            dataTable.Columns.Add(property.Name, propertyType);
                        }
                    }
                }

                foreach (var item in source)
                {
                    var row = dataTable.NewRow();
                    foreach (var property in properties)
                    {
                        var indexParameters = property.GetIndexParameters();
                        if (indexParameters == null || indexParameters.Length < 1)
                        {
                            row[property.Name] = property.GetValue(item, null) ?? DBNull.Value;
                        }
                    }
                    dataTable.Rows.Add(row);
                }

                return dataTable;
            }
        }

        public static DataTable ToDataTable(this IEnumerable source)
        {
            using (var dataTable = new DataTable())
            {
                dataTable.Locale = CultureInfo.InvariantCulture;

                foreach (var item in source)
                {
                    var itemType = item.GetType();
                    var properties = itemType.GetProperties(BindingFlags.Public | BindingFlags.Instance);

                    if (string.IsNullOrEmpty(dataTable.TableName))
                    {
                        dataTable.TableName = itemType.Name;
                    }

                    foreach (var property in properties)
                    {
                        var propertyType = property.PropertyType;

                        if (propertyType.IsGenericType &&
                            propertyType.GetGenericTypeDefinition().Equals(typeof(Nullable<>)))
                        {
                            propertyType = new NullableConverter(propertyType).UnderlyingType;
                        }

                        var indexParameters = property.GetIndexParameters();
                        if (indexParameters == null || indexParameters.Length < 1)
                        {
                            if (!dataTable.Columns.Contains(property.Name))
                            {
                                dataTable.Columns.Add(property.Name, propertyType);
                            }
                        }
                    }

                    var row = dataTable.NewRow();
                    foreach (var property in properties)
                    {
                        var indexParameters = property.GetIndexParameters();
                        if (indexParameters == null || indexParameters.Length < 1)
                        {
                            row[property.Name] = property.GetValue(item, null) ?? DBNull.Value;
                        }
                    }
                    dataTable.Rows.Add(row);
                }

                return dataTable;
            }
        }

        public static void AddRange<T>(this IList<T> source, IEnumerable<T> collection)
        {
            foreach (var item in collection)
            {
                source.Add(item);
            }
        }

        public static IEnumerable<SelectListItem> ToSelectListItems(this IEnumerable source)
        {
            return source.Cast<object>().ToSelectListItems();
        }

        public static IEnumerable<SelectListItem> ToSelectListItems<T>(this IEnumerable<T> source)
        {
            foreach (var item in source)
            {
                var itemText = string.Format(CultureInfo.InvariantCulture, "{0}", item);

                yield return new SelectListItem
                {
                    Text = itemText,
                    Value = itemText
                };
            }
        }

        /*
        public static IEnumerable<SelectListItem> ToSelectListItems(this IDictionary source)
        {
            foreach (var key in source.Keys)
            {
                yield return new SelectListItem
                {
                    Text = string.Format(CultureInfo.InvariantCulture, "{0}", source[key]),
                    Value = string.Format(CultureInfo.InvariantCulture, "{0}", key)
                };
            }
        }
        */

        public static IEnumerable<SelectListItem> ToSelectListItems<TKey, TValue>(this IDictionary<TKey, TValue> source)
        {
            foreach (var key in source.Keys)
            {
                yield return new SelectListItem
                {
                    Text = string.Format(CultureInfo.InvariantCulture, "{0}", source[key]),
                    Value = string.Format(CultureInfo.InvariantCulture, "{0}", key)
                };
            }
        }

        public static string ToDelimitedString<T>(this IEnumerable<T> source, string delimiter, Func<T, string> transform)
        {
            var list = new List<string>();

            foreach (var item in source)
            {
                list.Add(transform(item));
            }

            return string.Join(delimiter, list);
        }

        public static string ToCsvString<T>(this IEnumerable<T> source)
        {
            return source.ToDelimitedString(
                ",",
                item => string.Concat(
                    "\"",
                    string.Format(CultureInfo.InvariantCulture, "{0}", item)
                        .Trim()
                        .Replace("\"", "\"\""),
                    "\""));
        }
    }
}
