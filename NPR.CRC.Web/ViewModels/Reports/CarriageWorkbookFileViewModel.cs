using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using InfoConcepts.Library.Extensions;
using InfoConcepts.Library.Validation;
using NPR.CRC.Library.DataAccess;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using InfoConcepts.Library.Utilities;

namespace NPR.CRC.Web.ViewModels.Reports
{
    public class CarriageWorkbookFileViewModel
    {
        #region Properties

        public long CarriageTypeId { get; set; }

        [DisplayName("Carriage Type:")]
        public string CarriageType { get; set; }

        public string Season { get; set; }

        [DisplayName("Survey Season:")]
        public string SeasonName { get; set; }

        public int Years { get; set; }
        public string Band { get; set; }
        public string StationEnabled { get; set; }
        public long? MemberStatusId { get; set; }
        public string Format { get; set; }

        public IList<CarriageWorkbookFileProgramList> ProgramList { get; private set; }
        #endregion

        #region Constructors

        public CarriageWorkbookFileViewModel() {}

        public CarriageWorkbookFileViewModel(long carriageTypeId, string carriageType, string season, string seasonName, int years, string band, string stationEnabled, long? memberStatusId, string format) 
        {
            CarriageTypeId = carriageTypeId;
            CarriageType = carriageType;
            Season = season;
            SeasonName = seasonName;
            Years = years;
            Band = band;
            StationEnabled = stationEnabled;
            MemberStatusId = memberStatusId.HasValue ? memberStatusId.Value : default(long?);
            Format = format;

            ProgramList = new List<CarriageWorkbookFileProgramList>();
        }

        #endregion

        #region Methods
        #endregion

        #region Validators
        #endregion
    }

    public class CarriageWorkbookFileProgramList
    {
        public long ProgramId { get; set; }
        public string Program { get; set; }

    }
}