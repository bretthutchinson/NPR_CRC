using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Principal;
using System.Text;
using System.Threading.Tasks;

namespace InfoConcepts.Library.Security
{
    public class InfUserPrincipal : GenericPrincipal
    {
        public virtual long UserId { get; set; }
        public virtual string FirstName { get; set; }
        public virtual string LastName { get; set; }
        public virtual string Email { get; set; }
        public virtual bool IsActive { get; set; }
        public Dictionary<string, object> UserData { get; private set; }

        public virtual string DisplayName
        {
            get { return string.Concat(FirstName, " ", LastName).Trim(); }
        }

        public InfUserPrincipal(IIdentity identity, string[] roles)
            : base(identity, roles)
        {
            UserData = new Dictionary<string, dynamic>();
        }
    }
}
