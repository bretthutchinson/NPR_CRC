using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InfoConcepts.Library.Logging
{
    public class InfLogEntry
    {
        public InfLogLevel LogLevel { get; set; }
        public string Message { get; set; }
        public string UserName { get; set; }

        internal string SerialNumber { get; set; }
        internal string Source { get; set; }
        internal string ServerAddress { get; set; }
        internal string ServerHostname { get; set; }
        internal string ClientAddress { get; set; }
        internal string ClientHostname { get; set; }
    }
}
