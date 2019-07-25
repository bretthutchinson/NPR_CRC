using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using InfoConcepts.Library.Web.Mvc;
using MvcJqGrid;

namespace InfoConcepts.Library.Extensions
{
    public static class InfWebExtensions
    {
        public static string ToLogString(this HttpRequest request)
        {
            using (var stringWriter = new StringWriter(CultureInfo.InvariantCulture))
            {
                // request line
                stringWriter.Write(request.HttpMethod);
                stringWriter.Write(" ");
                stringWriter.Write(request.Url);
                stringWriter.Write(" ");
                stringWriter.WriteLine(request.ServerVariables["SERVER_PROTOCOL"]);

                // headers
                foreach (var key in request.Headers.AllKeys)
                {
                    stringWriter.WriteLine(string.Format(CultureInfo.InvariantCulture, "{0}: {1}", key, request.Headers[key]));
                }
                stringWriter.WriteLine();

                // body
                // do not explicitly close/dispose the stream reader object, or wrap it in a using block
                // despite any code analysis warnings that might tell you to do so
                // doing so would also close and dispose the underlying request input stream
                // todo: mask passwords, similar to InfSqlExtensions.ValueAsString
                var streamReader = new StreamReader(request.InputStream);
                try
                {
                    stringWriter.WriteLine(streamReader.ReadToEnd());
                }
                finally
                {
                    streamReader.BaseStream.Position = 0;
                }

                return stringWriter.ToString();
            }
        }

        public static IEnumerable<SelectListItem> AddBlankFirstItem(this IEnumerable<SelectListItem> source)
        {
            return source.AddBlankFirstItem(string.Empty);
        }

        public static IEnumerable<SelectListItem> AddBlankFirstItem(this IEnumerable<SelectListItem> source, string displayText)
        {
            var list = source.ToList();
            list.Insert(0, new SelectListItem { Value = "", Text = displayText });
            return list;
        }

        public static IEnumerable<SelectListItem> AddBlankLastItem(this IEnumerable<SelectListItem> source)
        {
            return source.AddBlankLastItem(string.Empty);
        }

        public static IEnumerable<SelectListItem> AddBlankLastItem(this IEnumerable<SelectListItem> source, string displayText)
        {
            var list = source.ToList();
            list.Add(new SelectListItem { Value = "", Text = displayText });
            return list;
        }

        public static IEnumerable<SelectListItem> SetSelected(this IEnumerable<SelectListItem> source, string selectedValue)
        {
            foreach (var item in source)
            {
                item.Selected = item.Value.Equals(selectedValue, StringComparison.OrdinalIgnoreCase);
            }

            return source;
        }

        public static IEnumerable<SelectListItem> SetSelected(this IEnumerable<SelectListItem> source, object selectedValue)
        {
            var s = string.Format(CultureInfo.InvariantCulture, "{0}", selectedValue);
            return source.SetSelected(s);
        }

        public static IEnumerable<SelectListItem> ResetSelection(this IEnumerable<SelectListItem> source)
        {
            foreach (var item in source)
            {
                item.Selected = false;
            }

            return source;
        }

        public static IEnumerable<SelectListItem> GetAvailableMonths(this IEnumerable<SelectListItem> source, IEnumerable<string> selectedValue)
        {
            foreach (var item in selectedValue)
            {
                source = source.Where(u => u.Value != item).ToList();                
            }
            return source;
        }

        public static byte[] ToByteArray(this HttpPostedFileBase source)
        {
            using (var memoryStream = new MemoryStream())
            {
                source.InputStream.CopyTo(memoryStream);
                return memoryStream.ToArray();
            }
        }
    }
}
