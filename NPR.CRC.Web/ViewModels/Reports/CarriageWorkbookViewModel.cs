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
    public class CarriageWorkbookViewModel
    {
        #region Properties

        [Required]
        [DisplayName("Carriage Type")]
        public long CarriageTypeId { get; set; }
        public IEnumerable<SelectListItem> CarriageTypeList { get; private set; }

        public string CarriageType { get; set; }

        [Required]
        [DisplayName("Select a Survey Season")]
        public string Season { get; set; }
        public IEnumerable<SelectListItem> SeasonList { get; private set; }

        public string SeasonName { get; set; }

        [Required]
        public int Years { get; set; }
        public IEnumerable<SelectListItem> YearsList { get; private set; }

        [Required]
        [DisplayName("Band")]
        public string Band { get; set; }
        public IEnumerable<SelectListItem> BandList { get; private set; }

        [Required]
        [DisplayName("Station Enabled")]
        public string StationEnabled { get; set; }
        public IEnumerable<SelectListItem> StationEnabledList { get; private set; }

        [DisplayName("Member Status")]
        public long? MemberStatusId { get; set; }
        public IEnumerable<SelectListItem> MemberStatusList { get; private set; }

        [Required]
        [DisplayName("Select a Format")]
        public string Format { get; set; }
        public IEnumerable<SelectListItem> FormatList { get; private set; }

        #endregion

        #region Constructors

        public CarriageWorkbookViewModel()
        {
            GetCarriageTypeList();
            GetSeasonList();
            YearsList = CRCDataAccess.GetScheduleYearsList(2).ToSelectListItems().SetSelected(DateTime.UtcNow.Year);
            GetBandList();
            GetStationEnabledList();
            GetMemberStatusList();
            FormatList = new[] { "Excel"}.ToSelectListItems();
        }

        #endregion

        #region Methods

        private void GetSeasonList()
        {
            var seasonList = new List<SelectListItem>
            {
                new SelectListItem { Value = "1, 2, 3", Text = "Winter" },
                new SelectListItem { Value = "4, 5, 6", Text = "Spring" },
                new SelectListItem { Value = "7, 8, 9", Text = "Summer" },
                new SelectListItem { Value = "10, 11, 12", Text = "Fall" },
            };
            SeasonList = seasonList;
        }

        private void GetBandList()
        {
            var bandsList = new List<SelectListItem>
            {
                new SelectListItem { Value = "|AM|, |FM|", Text = "Terrestrial" },
                new SelectListItem { Value = "|AM|, |AM-HD2|, |AM-HD3|, |AM-HD4|, |AM-HD5|, |AM-HD6|, |FM|, |FM-HD2|, |FM-HD3|, |FM-HD4|, |FM-HD5|, |FM-HD6|", Text = "Terrestrial & HD Multicast" },
                new SelectListItem { Value = "|AM-HD2|, |AM-HD3|, |AM-HD4|, |AM-HD5|, |AM-HD6|, |FM-HD2|, |FM-HD3|, |FM-HD4|, |FM-HD5|, |FM-HD6|", Text = "HD Multicast" },
                new SelectListItem { Value = "|AM-HD1|, |AM-HD2|, |AM-HD3|, |AM-HD4|, |AM-HD5|, |AM-HD6|, |FM-HD1|, |FM-HD2|, |FM-HD3|, |FM-HD4|, |FM-HD5|, |FM-HD6|", Text = "HD All" },
            };

            BandList = bandsList.SetSelected("AM, FM");
        }

        private void GetStationEnabledList()
        {
            var stationEnabledList = new List<SelectListItem>
            {
                new SelectListItem { Value = "N", Text = "Yes" },
                new SelectListItem { Value = "Y", Text = "No" },
                new SelectListItem { Value = "B", Text = "Both" },
            };
            StationEnabledList = stationEnabledList;
        }

        private void GetMemberStatusList()
        {
            DataTable dtMemberList = CRCDataAccess.GetMemberStatusEnabled();
            MemberStatusList = (new SelectListItem[] { new SelectListItem() { Text = "", Value = "" } }).Union((from DataRow row in dtMemberList.Rows
                                                                                                                select new SelectListItem()
                                                                                                                {
                                                                                                                    Text = row["MemberStatusName"].ToString(),
                                                                                                                    Value = row["MemberStatusId"].ToString()
                                                                                                                }));
        }

        private void GetCarriageTypeList()
        {
            DataTable dtCarriageList = CRCDataAccess.GetCarriageTypesEnabled();
            CarriageTypeList = (new SelectListItem[] { new SelectListItem() { Text = "", Value = "" } }).Union((from DataRow row in dtCarriageList.Rows
                                                                                   select new SelectListItem()
                                                                                   {
                                                                                       Text = row["CarriageTypeName"].ToString(),
                                                                                       Value = row["CarriageTypeId"].ToString()
                                                                                   }));
        }

        #endregion

        #region Validators
        #endregion
    }
}