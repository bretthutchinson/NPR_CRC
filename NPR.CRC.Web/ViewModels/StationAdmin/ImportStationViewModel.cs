using System;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using InfoConcepts.Library.Validation;
using CsvHelper.Configuration;
using CsvHelper.TypeConversion;
using CsvHelper;

namespace NPR.CRC.Web.ViewModels.StationAdmin
{
    public class ImportStationViewModel
    {        
        public string Station { get; set; }
        public string CallLetters
        {
            get
            {
                return Station.IndexOf("-") != -1 ? Station.Substring(0,Station.IndexOf("-")).Trim() : Station;
            }
        }
        public string Band
        {
            get
            {
                return Station.IndexOf("-") != -1 ? Station.Substring(Station.IndexOf("-") + 1).Trim() : "ER";
            }
        }
        public string Rank
        {
            get;
            set;
        }
        public string Market { get; set; }
        public long Result { get; set; }
        public string ResultMessage
        {
            get
            {
                return Result == 0 ? "failed" : "passed";
            }
        }
    }

    public class ImportStationMap : CsvClassMap<ImportStationViewModel>
    {
        public override void CreateMap()
        {
            Map(m => m.Station).Index(0);
            Map(m => m.Rank).Index(1);
            Map(m => m.Market).Index(2);
        }
    }
}