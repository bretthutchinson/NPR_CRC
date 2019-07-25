using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InfoConcepts.Library.Logging
{
    internal interface IInfLogger
    {
        void Log(InfLogEntry logEntry);
    }
}
