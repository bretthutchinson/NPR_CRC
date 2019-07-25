using System;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using InfoConcepts.Library.Validation;
using CsvHelper.Configuration;
using CsvHelper.TypeConversion;
using CsvHelper;

namespace NPR.CRC.Web.ViewModels.StationAdmin
{
    public class ImportAQHCumeViewModel
    {
        public string Station { get; set; }

        public string CallLetters
        {
            get
            {
                return Station.IndexOf("-") != -1 ? Station.Substring(0, Station.IndexOf("-")).Trim() : Station;
            }
        }

        public string Band
        {
            get
            {
                return Station.IndexOf("-") != -1 ? Station.Substring(Station.IndexOf("-") + 1).Trim() : "ER";
            }
        }

        public string AQH { get; set; }

        public string Cume { get; set; }

        public long Result { get; set; }

        public string ResultMessage
        {
            get
            {
                return Result == 0 ? "failed" : "passed";
            }
        }
    }

    public class ImportAQHCumeMap : CsvClassMap<ImportAQHCumeViewModel>
    {
        public override void CreateMap()
        {
            Map(m => m.Station).Index(0);
            Map(m => m.AQH).Index(1);
            Map(m => m.Cume).Index(2);
        }
    }
}