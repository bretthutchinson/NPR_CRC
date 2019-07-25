#region Using
using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Globalization;
#endregion

namespace InfoConcepts.Library.Extensions
{
    public static class InfObjectExtensions
    {
        public static T ConvertTo<T>(this object value)
        {
            return (T)Convert.ChangeType(value, typeof(T), CultureInfo.InvariantCulture);
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1031:DoNotCatchGeneralExceptionTypes")]
        public static T TryConvertTo<T>(this object value, T defaultValue)
        {
            try
            {
                return ConvertTo<T>(value);
            }
            catch
            {
                return defaultValue;
            }
        }

        public static IDictionary<string, object> ToDictionary(this object source)
        {
            var dictionary = new Dictionary<string, object>();

            if (source != null)
            {
                foreach (PropertyDescriptor propertyDescriptor in TypeDescriptor.GetProperties(source))
                {
                    var key = propertyDescriptor.Name;
                    var value = propertyDescriptor.GetValue(source);

                    dictionary.Add(key, value);
                }
            }

            return dictionary;
        }
    }
}
