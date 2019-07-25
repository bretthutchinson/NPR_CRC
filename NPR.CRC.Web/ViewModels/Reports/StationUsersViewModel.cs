using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using InfoConcepts.Library.Extensions;
using InfoConcepts.Library.Validation;
using NPR.CRC.Library.DataAccess;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace NPR.CRC.Web.ViewModels.Reports
{
    public class StationUsersViewModel
    {
        #region Properties

        [Required]
        [DisplayName("User Permisson:")]
        public string UserPermission { get; set; }
        public IEnumerable<SelectListItem> UserPermissionList { get; private set; }


        [Required]
        [DisplayName("Band:")]
        public string Band { get; set; }
        public IEnumerable<SelectListItem> BandList { get; private set; }

        [Required]
        [DisplayName("Repeater Status:")]
        public string RepeaterStatus { get; set; }
        public IEnumerable<SelectListItem> RepeaterStatusList { get; set; }

        [Required]
        [DisplayName("Format:")]
        public string Format { get; set; }
        public IEnumerable<SelectListItem> FormatList { get; private set; }

        #endregion

        #region Constructors

        public StationUsersViewModel()
        {
            UserPermissionList = GetUserPermissionList();
            BandList = GetBandList();
            RepeaterStatusList = GetRepeaterStatusList();
            FormatList = new[] { "CSV", "Excel", "PDF" }.ToSelectListItems();
        }

        #endregion

        #region Methods

        private static IEnumerable<SelectListItem> GetBandList()
        {
            var bandsList = new List<SelectListItem>
            {
                new SelectListItem { Value = "|AM|, |FM|", Text = "Terrestrial" },
                new SelectListItem { Value = "|AM|, |AM-HD2|, |AM-HD3|, |AM-HD4|, |AM-HD5|, |AM-HD6|, |FM|, |FM-HD2|, |FM-HD3|, |FM-HD4|, |FM-HD5|, |FM-HD6|", Text = "Terrestrial & HD Multicast" },
                new SelectListItem { Value = "|AM-HD2|, |AM-HD3|, |AM-HD4|, |AM-HD5|, |AM-HD6|, |FM-HD2|, |FM-HD3|, |FM-HD4|, |FM-HD5|, |FM-HD6|", Text = "HD Multicast" },
                new SelectListItem { Value = "|AM-HD1|, |AM-HD2|, |AM-HD3|, |AM-HD4|, |AM-HD5|, |AM-HD6|, |FM-HD1|, |FM-HD2|, |FM-HD3|, |FM-HD4|, |FM-HD5|, |FM-HD6|", Text = "HD All" },
            };

            return bandsList.SetSelected("AM, FM");
        }

        private static IEnumerable<SelectListItem> GetUserPermissionList()
        {
            var userPermissionsList = new List<SelectListItem>
            {
                new SelectListItem { Value = "P", Text = "Primary" },
                new SelectListItem { Value = "G", Text = "Grid Write" },
                new SelectListItem { Value = "A", Text = "All" },
            };

            return userPermissionsList;
        }

        private static IEnumerable<SelectListItem> GetRepeaterStatusList()
        {
            var repeaterStatusList = new List<SelectListItem>
            {
                new SelectListItem { Value = "F", Text = "Flagship" },
                new SelectListItem { Value = "R", Text = "100% Repeater" },
                new SelectListItem { Value = "N", Text = "Non-100% Repeater" },
                new SelectListItem { Value = "A", Text = "All Statuses except 100% Reapeter" },
            };

            return repeaterStatusList;
        }

        #endregion
    }
}