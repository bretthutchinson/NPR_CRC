#region Using
using System;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Text;
using System.Text.RegularExpressions;
using InfoConcepts.Library.DataAccess;
#endregion

namespace InfoConcepts.Library.Extensions
{
    public static class InfSqlClientExtensions
    {
        public static string ToSqlString(this SqlCommand command)
        {
            var sb = new StringBuilder();

            if (command.CommandType == CommandType.StoredProcedure)
            {
                sb.AppendFormat(CultureInfo.InvariantCulture, "EXEC {0}", command.CommandText);
                foreach (SqlParameter parameter in command.Parameters)
                {
                    sb.Append(command.Parameters.IndexOf(parameter) > 0 ? ", " : " ");
                    sb.AppendFormat(CultureInfo.InvariantCulture, "{0} = {1}", parameter.ParameterName, parameter.ValueAsString());
                }
            }
            else if (command.CommandType == CommandType.Text)
            {
                sb.AppendLine("EXEC dbo.sp_executesql");
                sb.AppendFormat("\t@statement = N'{0}'", command.CommandText.Replace("'", "''"));

                if (command.Parameters.Count > 0)
                {
                    sb.AppendLine(",");

                    sb.Append("\t@params = N'");
                    foreach (SqlParameter parameter in command.Parameters)
                    {
                        if (command.Parameters.IndexOf(parameter) > 0)
                        {
                            sb.Append(", ");
                        }
                        sb.AppendFormat(CultureInfo.InvariantCulture, "{0} {1}", parameter.ParameterName, parameter.SqlDbTypeAsString());
                    }
                    sb.AppendLine("',");

                    sb.Append("\t");
                    foreach (SqlParameter parameter in command.Parameters)
                    {
                        if (command.Parameters.IndexOf(parameter) > 0)
                        {
                            sb.Append(", ");
                        }
                        sb.AppendFormat(CultureInfo.InvariantCulture, "{0} = {1}", parameter.ParameterName, parameter.ValueAsString());
                    }
                }
                sb.AppendLine();
            }
            else
            {
                throw new NotSupportedException("Command type must be either \"StoredProcedure\" or \"Text\".");
            }

            return sb.ToString();
        }

        public static string SqlDbTypeAsString(this SqlParameter parameter)
        {
            var typeName = parameter.SqlDbType.ToString().ToUpperInvariant();

            switch (parameter.SqlDbType)
            {
                case SqlDbType.Binary:
                case SqlDbType.Char:
                case SqlDbType.NChar:
                case SqlDbType.NVarChar:
                case SqlDbType.VarBinary:
                case SqlDbType.VarChar:
                    return string.Format(CultureInfo.InvariantCulture,
                        "{0}({1})",
                        typeName,
                        parameter.Size > 0 ? parameter.Size.ToString("d", CultureInfo.InvariantCulture) : "MAX");

                case SqlDbType.Decimal:
                    return string.Format(CultureInfo.InvariantCulture,
                        "{0}({1:d},{2:d})",
                        typeName,
                        parameter.Precision,
                        parameter.Scale);

                case SqlDbType.Float:
                    return string.Format(CultureInfo.InvariantCulture,
                        "{0}({1:d})",
                        typeName,
                        parameter.Precision);

                default:
                    return typeName;
            }
        }

        public static string ValueAsString(this SqlParameter parameter)
        {
            if (parameter.Value == DBNull.Value)
            {
                return "NULL";
            }
            else if (parameter.ParameterName.IndexOf("Password", StringComparison.OrdinalIgnoreCase) >= 0)
            {
                return "'********'";
            }
            else
            {
                switch (parameter.SqlDbType)
                {
                    case SqlDbType.BigInt:
                    case SqlDbType.Int:
                    case SqlDbType.SmallInt:
                    case SqlDbType.TinyInt:
                        return string.Format(CultureInfo.InvariantCulture, "{0:d}", parameter.Value);

                    case SqlDbType.Bit:
                        var b = (bool)parameter.Value;
                        return b ? "1" : "0";

                    case SqlDbType.Binary:
                    case SqlDbType.Image:
                    case SqlDbType.Timestamp:
                    case SqlDbType.VarBinary:
                        return string.Concat("0x", BitConverter.ToString(parameter.Value as byte[]).Replace("-", string.Empty));

                    case SqlDbType.Date:
                    case SqlDbType.DateTime:
                    case SqlDbType.DateTime2:
                    case SqlDbType.DateTimeOffset:
                    case SqlDbType.SmallDateTime:
                    case SqlDbType.Time:
                        return string.Format(CultureInfo.InvariantCulture, "'{0:yyyy-MM-dd HH:mm:ss.fff}'", parameter.Value);

                    case SqlDbType.Decimal:
                    case SqlDbType.Float:
                    case SqlDbType.Money:
                    case SqlDbType.Real:
                    case SqlDbType.SmallMoney:
                        return string.Format(CultureInfo.InvariantCulture, "{0:f}", parameter.Value);

                    default:
                        return string.Format(CultureInfo.InvariantCulture, "'{0}'", parameter.Value);
                }
            }
        }

        private static Regex _validationRegex;

        public static void Validate(this IDbCommand command)
        {
            if (_validationRegex == null)
            {
                var pattern = new StringBuilder();
                pattern.Append("("); // begin group
                pattern.Append(Regex.Escape(";")); // statement terminator
                pattern.Append("|"); // or
                pattern.Append(Regex.Escape("'")); // string literal
                pattern.Append("|"); // or
                pattern.Append(Regex.Escape("--")); // single-line comment
                pattern.Append("|"); // or
                pattern.Append(Regex.Escape("/*")); // begin multi-line comment
                pattern.Append("|"); // or
                pattern.Append(Regex.Escape("*/")); // end multi-line comment
                pattern.Append("|"); // or
                pattern.Append(Regex.Escape("+")); // string concatenation operator
                pattern.Append(")"); // end group

                _validationRegex = new Regex(
                    pattern.ToString(),
                    RegexOptions.Compiled);
            }

            if (_validationRegex.IsMatch(command.CommandText))
            {
                throw new InfSqlValidationException();
            }

            foreach (IDbDataParameter parameter in command.Parameters)
            {
                if (parameter.DbType == DbType.AnsiString ||
                    parameter.DbType == DbType.AnsiStringFixedLength ||
                    parameter.DbType == DbType.String ||
                    parameter.DbType == DbType.StringFixedLength)
                {
                    var value = parameter.Value as string;
                    if (value != null && _validationRegex.IsMatch(value))
                    {
                        throw new InfSqlValidationException();
                    }
                }
            }
        }
    }
}
