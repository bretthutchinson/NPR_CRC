using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Principal;
using System.Text;
using System.Threading.Tasks;
using InfoConcepts.Library.Security;

namespace NPR.CRC.Library
{
    public class CRCUserPrincipal : InfUserPrincipal
    {
        public long? SalutationId
        {
            get;
            set;
        }

        public string MiddleName
        {
            get;
            set;
        }

        public string Suffix
        {
            get;
            set;
        }

        public string JobTitle
        {
            get;
            set;
        }

        public string AddressLine1
        {
            get;
            set;
        }

        public string AddressLine2
        {
            get;
            set;
        }

        public string City
        {
            get;
            set;
        }

        public long? StateId
        {
            get;
            set;
        }

        public string County
        {
            get;
            set;
        }

        public string Country
        {
            get;
            set;
        }

        public string ZipCode
        {
            get;
            set;
        }

        public string Phone
        {
            get;
            set;
        }

        public string Fax
        {
            get;
            set;
        }

        public bool AdministratorInd
        {
            get;
            set;
        }

        public bool CrcManagerInd
        {
            get;
            set;
        }

        public override bool IsActive
        {
            get
            {
                return DisabledDate != null;
            }
        }

        public DateTime? DisabledDate
        {
            get;
            set;
        }

        public long? DisabledUserId
        {
            get;
            set;
        }

        public DateTime? CreatedDate
        {
            get;
            set;
        }

        public long? CreatedUserId
        {
            get;
            set;
        }

        public DateTime? LastUpdatedDate
        {
            get;
            set;
        }

        public long? LastUpdatedUserId
        {
            get;
            set;
        }

        /// <summary>
        /// For station users, contains the list of stations the user has access to,
        /// and whether or not the access includes grid-write permissions
        /// </summary>
        public IDictionary<long, bool> Stations
        {
            get
            {
                var stations = UserData.ContainsKey("Stations") ? UserData["Stations"] as IDictionary<long, bool> : null;
                if (stations == null)
                {
                    stations = new Dictionary<long, bool>();
                    UserData["Stations"] = stations;
                }

                return stations;
            }
        }

        public CRCUserPrincipal(IIdentity identity, string[] roles)
            : base(identity, roles)
        {
        }
    }
}
