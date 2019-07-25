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
    public class StationDetailViewModel
    {
        public long StationId { get; set; }

		public long FlagshipStationId { get; set; }

        [DisplayName("Call Letters")]
        public string CallLetters { get; set; }

        [DisplayName("Band")]
        public string BandName { get; set; }

        [DisplayName("Frequency")]
        public string Frequency { get; set; }

        [DisplayName("Status Date")]
        [DataType(DataType.Date)]
        [DisplayFormat(DataFormatString = "{0:MM/dd/yyyy}")]
        public DateTime? StatusDate { get; set; }

        [DisplayName("Enabled")]
        public bool EnabledInd { get; set; }

        [DisplayName("Repeater Status")]
        public string RepeaterStatusName { get; set; }

        [DisplayName("Flagship")]
        public string FlagshipStationName { get; set; }

        [DisplayName("Member Status")]
        public string MemberStatusName { get; set; }

        [DisplayName("Minority Status")]
        public string MinorityStatusName { get; set; }

        [DisplayName("Licensee Type")]
        public string LicenseeTypeName { get; set; }

        [DisplayName("Licensee Name")]
        public string LicenseeName { get; set; }

        [DisplayName("TSA Cume")]
        public string TSACume { get; set; }

        [DisplayName("TSAAQH")]
        public string TSAAQH { get; set; }

        [DisplayName("Metro Ranking")]
        public int? MetroMarketRank { get; set; }

        [DisplayName("Metro Market")]
        public string MetroMarketName { get; set; }

        [DisplayName("DMA Rank")]
        public int? DMAMarketRank { get; set; }

        [DisplayName("DMA Market")]
        public string DMAMarketName { get; set; }

        [DisplayName("Time Zone")]
        public string TimeZoneName { get; set; }

        [DisplayName("Hrs from Flagship")]
        public string HrsFromFlagship { get; set; }

        [DisplayName("Max. No. of Users")]
        public int? MaxNumberOfUsers { get; set; }

        [DisplayName("Affiliations")]
        public string AffiliateCodesList { get; set; }

        [DisplayName("Address 1")]
        public string AddressLine1 { get; set; }

        [DisplayName("Address 2")]
        public string AddressLine2 { get; set; }

        [DisplayName("City")]
        public string City { get; set; }

        [DisplayName("State")]
        public string StateAbbreviation { get; set; }

        [DisplayName("Zip")]
        [DataType(DataType.PostalCode)]
        public string ZipCode { get; set; }

        [DisplayName("County")]
        public string County { get; set; }

        [DisplayName("Country")]
        public string Country { get; set; }

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
        [DataType(DataType.Url)]
        public string WebPage { get; set; }

        public StationDetailViewModel() { }

		public string AssociatesStationEnabledCnt { get; set; }

		public string HDStationEnabledCnt { get; set; }

    }
}