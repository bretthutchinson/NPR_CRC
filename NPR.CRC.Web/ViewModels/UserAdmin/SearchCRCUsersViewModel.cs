using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using InfoConcepts.Library.Extensions;
using NPR.CRC.Library.DataAccess;

namespace NPR.CRC.Web.ViewModels.UserAdmin
{
    public class SearchCRCUsersViewModel
    {
        public IEnumerable<SelectListItem> EnabledList { get; private set; }
        public IEnumerable<SelectListItem> UserRoleList { get; private set; }
        public IEnumerable<SelectListItem> UserPermissionList { get; private set; }
        public IEnumerable<SelectListItem> BandList { get; private set; }

        public IEnumerable<SelectListItem> StationList { get; private set; }
        public IEnumerable<SelectListItem> StationStatusList { get; private set; }

        public SearchCRCUsersViewModel()
        {
            EnabledList = new[] { "Yes", "No", "Both" }.ToSelectListItems();
            UserRoleList = new[] { "All", "Station User", "Administrator" }.ToSelectListItems();
            UserPermissionList = new[] { "All", "Primary Users Only", "Grid Write Users Only" }.ToSelectListItems();
            BandList = new[] { "Terrestrial", "HD" }.ToSelectListItems().AddBlankFirstItem();

            StationList = CRCDataAccess.GetStationsList().ToSelectListItems().OrderBy(li => li.Text).AddBlankFirstItem();
            StationStatusList = CRCDataAccess.GetRepeaterStatuses().ToSelectListItems().AddBlankFirstItem();
        }
    }
}