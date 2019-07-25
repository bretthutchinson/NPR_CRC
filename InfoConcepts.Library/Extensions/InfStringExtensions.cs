using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Text.RegularExpressions;

namespace InfoConcepts.Library.Extensions
{
    public static class InfStringExtensions
    {
        /// <summary>
        /// Performs a string replace, with the option of case-insensitivity.
        /// </summary>
        public static string Replace(this string source, string oldValue, string newValue, bool caseSensitive)
        {
            if (caseSensitive)
            {
                return source.Replace(oldValue, newValue);
            }
            else
            {
                return Regex.Unescape(Regex.Replace(source, Regex.Escape(oldValue), Regex.Escape(newValue), RegexOptions.IgnoreCase));
            }
        }

        /// <summary>
        /// Replaces tokens in the string with the corresponding values from a dictionary object.
        /// Tokens should have the format "{FieldName}".
        /// </summary>
        public static string ReplaceTokens(this string source, IDictionary<string, object> tokens)
        {
            return source.ReplaceTokens(tokens, null);
        }

        /// <summary>
        /// Replaces tokens in the string with the corresponding values from a dictionary object.
        /// Use the options argument to indicate the prefix and/or suffix used to denote tokens.
        /// </summary>
        public static string ReplaceTokens(this string source, IDictionary<string, object> tokens, InfTokenOptions options)
        {
            if (options == null)
            {
                options = new InfTokenOptions();
            }

            var replaced = source;

            foreach (var token in tokens)
            {
                var tokenName = token.Key;

                if (!string.IsNullOrWhiteSpace(options.TokenPrefix) && !tokenName.StartsWith(options.TokenPrefix, StringComparison.OrdinalIgnoreCase))
                {
                    tokenName = options.TokenPrefix + tokenName;
                }

                if (!string.IsNullOrWhiteSpace(options.TokenSuffix) && !tokenName.EndsWith(options.TokenSuffix, StringComparison.OrdinalIgnoreCase))
                {
                    tokenName = tokenName + options.TokenSuffix;
                }

                var tokenValue = string.Format(CultureInfo.InvariantCulture, "{0}", token.Value);

                replaced = replaced.Replace(tokenName, tokenValue, false);
            }

            return replaced;
        }

        /// <summary>
        /// Replaces tokens in the string with the corresponding values from a data row object.
        /// Tokens should have the format "{FieldName}".
        /// </summary>
        public static string ReplaceTokens(this string source, DataRow tokens)
        {
            return source.ReplaceTokens(tokens, null);
        }

        /// <summary>
        /// Replaces tokens in the string with the corresponding values from a data row object.
        /// Use the options argument to indicate the prefix and/or suffix used to denote tokens.
        /// </summary>
        public static string ReplaceTokens(this string source, DataRow tokens, InfTokenOptions options)
        {
            return source.ReplaceTokens(tokens.ToDictionary(), options);
        }

        /// <summary>
        /// Returns "Y" if true or "N" if false.
        /// </summary>
        public static string ToIndicator(this bool source)
        {
            return source ? "Y" : "N";
        }

        /// <summary>
        /// Returns "Y" if true, "N" if false, or an empty string if null.
        /// </summary>
        public static string ToIndicator(this bool? source)
        {
            return source.HasValue ? source.Value.ToIndicator() : string.Empty;
        }
    }

    public class InfTokenOptions
    {
        private string _tokenPrefix = "{";
        private string _tokenSuffix = "}";

        public string TokenPrefix
        {
            get { return _tokenPrefix; }
            set { _tokenPrefix = value; }
        }

        public string TokenSuffix
        {
            get { return _tokenSuffix; }
            set { _tokenSuffix = value; }
        }
    }
}
