using System;
using System.ComponentModel.DataAnnotations;
using System.Globalization;
using InfoConcepts.Library.Extensions;

namespace InfoConcepts.Library.Validation
{
    [AttributeUsage(AttributeTargets.Property)]
    public sealed class InfUniqueAttribute : ValidationAttribute
    {
        public string TableName { get; private set; }
        public string ColumnName { get; private set; }
        public string IdPropertyName { get; private set; }

        public InfUniqueAttribute(string tableName, string columnName, string idPropertyName)
        {
            this.TableName = tableName;
            this.ColumnName = columnName;
            this.IdPropertyName = idPropertyName;
        }

        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            if (!string.IsNullOrWhiteSpace(value as string))
            {
                var idPropertyInfo = validationContext.ObjectType.GetProperty(IdPropertyName);
                if (!idPropertyInfo.PropertyType.IsIn(typeof(int), typeof(long), typeof(int?), typeof(long?)))
                {
                    var message = string.Format(CultureInfo.InvariantCulture, "The \"idPropertyName\" argument passed to {0} must reference a property of one of the following types: int, int?, long, long?. Property \"{1}\" is of type {2}.", this.GetType().Name, IdPropertyName, idPropertyInfo.PropertyType.Name);
                    throw new InvalidOperationException(message);
                }

                var idPropertyValue = (long?)idPropertyInfo.GetValue(validationContext.ObjectInstance);

                var isUnique = InfValidationHelper.IsValueUnique(value, TableName, ColumnName, idPropertyValue);
                if (!isUnique)
                {
                    var message = string.Format(CultureInfo.InvariantCulture, "{0} must be unique. \"{1}\" is already in use.", validationContext.DisplayName, value);
                    return new ValidationResult(message, new[] { validationContext.MemberName });
                }
            }

            return ValidationResult.Success;
        }
    }
}
