#region Using
using System;
using System.Runtime.Serialization;
#endregion

namespace InfoConcepts.Library.DataAccess
{
    [Serializable]
    public class InfSqlValidationException : Exception
    {
        protected InfSqlValidationException(SerializationInfo info, StreamingContext context)
            : base(info, context)
        {
        }

        public InfSqlValidationException(string message)
            : base(message)
        {
        }

        public InfSqlValidationException(string message, Exception innerException)
            : base(message, innerException)
        {
        }

        public InfSqlValidationException()
            : base("A sequence of characters was found in the command and/or one or more of its parameters that could potentially represent an attempt at SQL injection.")
        {
        }
    }
}
