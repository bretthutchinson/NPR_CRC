using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InfoConcepts.Library.Utilities
{
    public sealed class InfDate
    {
        private InfDate() { }
        /// <summary>
        /// The client wants to see everything in eastern time.  We store everything in Utc.
        /// This function will calculate the offset in hours between utc and eastern time.  This is important
        /// because the time will vary according to daylight savings time.
        /// </summary>
        /// <returns></returns>
        public static int GetUtcOffSet
        {
            get
            {
                DateTime eastern = TimeZoneInfo.ConvertTimeBySystemTimeZoneId(DateTime.UtcNow, "Eastern Standard Time");
                return DateTime.UtcNow.Hour - eastern.Hour;
            }
        }

    }
}
