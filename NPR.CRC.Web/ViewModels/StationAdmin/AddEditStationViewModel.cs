using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using InfoConcepts.Library.Web.Mvc;
using NPR.CRC.Library.DataAccess;
using InfoConcepts.Library.Extensions;

namespace NPR.CRC.Web.ViewModels.StationAdmin
{
    public class AddEditStationViewModel
    {
        public long? StationId { get; set; }

        [Required]
        [DisplayName("Call Letters")]
        public string CallLetters { get; set; }

        [Required]
        [DisplayName("Band")]
        public long? BandId { get; set; }

        [Required]
        [DisplayName("Frequency")]
        public string Frequency { get; set; }

        [Required]
        [DisplayName("Repeater Status")]
        public long? RepeaterStatusId { get; set; }

        [DisplayName("Flagship")]
        public long? FlagshipStationId { get; set; }

        [Required]
        [DisplayName("Member Status")]
        public long? MemberStatusId { get; set; }

        [Required]
        [DisplayName("Minority Status")]
        public long? MinorityStatusId { get; set; }

        [Required]
        [DisplayName("Status Date")]
        [DisplayFormat(DataFormatString = "{0:d}")]
        public DateTime? StatusDate { get; set; }

        [Required]
        [DisplayName("Licensee Type")]
        public long? LicenseeTypeId { get; set; }

        [DisplayName("Licensee Name")]
        public string LicenseeName { get; set; }

        [DisplayName("Address 1")]
        public string AddressLine1 { get; set; }

        [DisplayName("Address 2")]
        public string AddressLine2 { get; set; }

        [DisplayName("City")]
        public string City { get; set; }

        [DisplayName("State")]
        [DataType("State")]
        public long? StateId { get; set; }

        [DisplayName("County")]
        public string County { get; set; }

        [DisplayName("Country")]
        public string Country { get; set; }

        [DisplayName("Zip")]
        [DataType(DataType.PostalCode)]
        public string ZipCode { get; set; }

        [DisplayName("Phone")]
        [DataType(DataType.PhoneNumber)]
        public string Phone { get; set; }

        [DisplayName("Fax")]
        [DataType(DataType.PhoneNumber)]
        public string Fax { get; set; }

        [DisplayName("Email")]
        [DataType(DataType.EmailAddress)]
        public string Email { get; set; }

        [DisplayName("Web Page")]
        //[RegularExpression(@"^([a-zA-Z0-9]+(\.[a-zA-Z0-9]+)+.*)$", ErrorMessage = "Please enter valid url (without protocol like http,https or ftp).")]
        //[RegularExpression(@"^((?!http:/|https:/|ftp:/).)*$", ErrorMessage = "Please enter valid url (without protocol like http,https or ftp).")]
        public string WebPage { get; set; }

        [DisplayName("TSA Cume")]
        public string TsaCume { get; set; }

        [DisplayName("TSAAQH")]
        public string Tsaaqh { get; set; }

        [DisplayName("Metro Market")]
        public long? MetroMarketId { get; set; }

        [DisplayName("Metro Ranking")]
        public int? MetroMarketRank { get; set; }

        [DisplayName("DMA Market")]
        public long? DmaMarketId { get; set; }

        [DisplayName("DMA Ranking")]
        public int? DmaMarketRank { get; set; }

        [Required]
        [DisplayName("Time Zone")]
        public long? TimeZoneId { get; set; }

        [DisplayName("Hrs. from Flagship")]
        public int? HoursFromFlagship { get; set; }

        [DisplayName("Max. No. of Users")]
        public int? MaxNumberOfUsers { get; set; }

        [DisplayName("Enabled")]
        public bool EnabledInd { get; set; }

        public string CopyInd { get; set; }

        [DisplayName("Affiliations")]
        public IEnumerable<long> AffiliateIds { get; set; }

        public IEnumerable<SelectListItem> BandList { get; private set; }
        public IEnumerable<SelectListItem> RepeaterStatusList { get; private set; }
        public IEnumerable<SelectListItem> FlagshipStationList { get; private set; }
        public IEnumerable<SelectListItem> MemberStatusList { get; private set; }
        public IEnumerable<SelectListItem> MinorityStatusList { get; private set; }
        public IEnumerable<SelectListItem> LicenseeTypeList { get; private set; }
        public IEnumerable<SelectListItem> MetroMarketList { get; private set; }
        public IEnumerable<SelectListItem> DMAMarketList { get; private set; }
        public IEnumerable<SelectListItem> TimeZoneList { get; private set; }
        public IEnumerable<SelectListItem> AffiliateList { get; private set; }

        public AddEditStationViewModel()
        {
            CopyInd = "N";
            BandList = CRCDataAccess.GetBands().ToSelectListItems().OrderBy(li => li.Text).AddBlankFirstItem();
            RepeaterStatusList = CRCDataAccess.GetRepeaterStatuses().ToSelectListItems().OrderBy(li => li.Text).AddBlankFirstItem();
            FlagshipStationList = CRCDataAccess.GetFlagshipStationsList().ToSelectListItems().OrderBy(li => li.Text).AddBlankFirstItem();
            MemberStatusList = CRCDataAccess.GetMemberStatuses().ToSelectListItems().OrderBy(li => li.Text).AddBlankFirstItem();
            MinorityStatusList = CRCDataAccess.GetMinorityStatuses().ToSelectListItems().OrderBy(li => li.Text).AddBlankFirstItem();
            LicenseeTypeList = CRCDataAccess.GetDropDownLicenseeTypes().ToSelectListItems().OrderBy(li => li.Text).AddBlankFirstItem();
            MetroMarketList = CRCDataAccess.GetMetroMarkets().ToSelectListItems().OrderBy(li => li.Text).AddBlankFirstItem();
            DMAMarketList = CRCDataAccess.GetDMAMarkets().ToSelectListItems().OrderBy(li => li.Text).AddBlankFirstItem();
            TimeZoneList = CRCDataAccess.GetTimeZones().ToSelectListItems().AddBlankFirstItem();
            AffiliateList = CRCDataAccess.GetAffiliates().ToSelectListItems().OrderBy(li => li.Text);
        }
    }
}