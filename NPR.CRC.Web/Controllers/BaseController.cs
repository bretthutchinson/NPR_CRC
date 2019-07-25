using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using InfoConcepts.Library.Web.Mvc;
using NPR.CRC.Library;

namespace NPR.CRC.Web.Controllers
{
    public class BaseController : InfBaseController
    {
        protected CRCUserPrincipal CRCUser
        {
            get { return User as CRCUserPrincipal; }
        }
    }
}
