using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace InfoConcepts.Library.Logging
{
    [Serializable]
    public class InfLoggingFailedException : Exception
    {
        protected InfLoggingFailedException(SerializationInfo info, StreamingContext context)
            : base(info, context)
        {
        }

        public InfLoggingFailedException(string message)
            : base(message)
        {
        }

        public InfLoggingFailedException(string message, Exception innerException)
            : base(message, innerException)
        {
        }

        public InfLoggingFailedException()
            : base("Logging failed with all configured loggers.")
        {
        }
    }
}
