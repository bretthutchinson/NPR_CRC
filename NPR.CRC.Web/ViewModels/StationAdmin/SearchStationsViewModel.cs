using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using InfoConcepts.Library.Extensions;
using NPR.CRC.Library.DataAccess;

namespace NPR.CRC.Web.ViewModels.StationAdmin
{
    public class SearchStationsViewModel
    {
        public IEnumerable<SelectListItem> StationList { get; private set; }
        public IEnumerable<SelectListItem> RepeaterStatusList { get; private set; }
        public IEnumerable<SelectListItem> MetroMarketList { get; private set; }
        public IEnumerable<SelectListItem> DMAMarketList { get; private set; }
        public IEnumerable<SelectListItem> MemberStatusList { get; private set; }
        public IEnumerable<SelectListItem> BandList { get; private set; }
        public IEnumerable<SelectListItem> StateList { get; private set; }
        public IEnumerable<SelectListItem> LicenseeTypeList { get; private set; }
        public IEnumerable<SelectListItem> AffiliateList { get; private set; }
        public IEnumerable<SelectListItem> EnabledList { get; private set; }
        public string StationName { get; set; }

        public SearchStationsViewModel()
        {
            StationList = CRCDataAccess.GetStationsList().ToSelectListItems().OrderBy(li => li.Text).AddBlankFirstItem();
            RepeaterStatusList = CRCDataAccess.GetRepeaterStatuses().ToSelectListItems().OrderBy(li => li.Text).AddBlankFirstItem();
            MetroMarketList = CRCDataAccess.GetMetroMarkets().ToSelectListItems().OrderBy(li => li.Text).AddBlankFirstItem();
            DMAMarketList = CRCDataAccess.GetDMAMarkets().ToSelectListItems().OrderBy(li => li.Text).AddBlankFirstItem();
            MemberStatusList = CRCDataAccess.GetMemberStatuses().ToSelectListItems().OrderBy(li => li.Text).AddBlankFirstItem();
            GetBandList();
            //BandList = CRCDataAccess.GetBands().ToSelectListItems().OrderBy(li => li.Text).AddBlankFirstItem();
            StateList = CRCDataAccess.GetStates().ToSelectListItems("StateId", "Abbreviation").OrderBy(li => li.Text).AddBlankFirstItem();
            LicenseeTypeList = CRCDataAccess.GetDropDownLicenseeTypes().ToSelectListItems().OrderBy(li => li.Text).AddBlankFirstItem();
            AffiliateList = CRCDataAccess.GetAffiliates().ToSelectListItems().OrderBy(li => li.Text).AddBlankFirstItem();
            EnabledList = new[] { "Yes", "No", "Both" }.ToSelectListItems();
        }


        private void GetBandList()
        {
            var bandsList = new List<SelectListItem>
            {
                new SelectListItem { Value = "1, 8", Text = "Terrestrial" },
                new SelectListItem { Value = "3, 4, 5, 6, 7, 10, 11, 12, 13, 14", Text = "HD Multicast" },
                new SelectListItem { Value = "2, 3, 4, 5, 6, 7, 9, 10, 11, 12, 13, 14", Text = "HD All" },
                new SelectListItem { Value = "", Text = "All" },
            };

            var tabBandList = CRCDataAccess.GetBands().ToSelectListItems().OrderBy(li => li.Text);


            bandsList.AddRange(tabBandList);
            BandList = bandsList.AddBlankFirstItem();
        }
    }
}
