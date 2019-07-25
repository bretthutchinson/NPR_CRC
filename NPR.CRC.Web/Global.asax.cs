using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Security.Principal;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;
using System.Web.Security;
using InfoConcepts.Library.Web;
using InfoConcepts.Library.Extensions;
using NPR.CRC.Library;
using NPR.CRC.Library.DataAccess;

namespace NPR.CRC.Web
{
    // Note: For instructions on enabling IIS6 or IIS7 classic mode, 
    // visit http://go.microsoft.com/?LinkId=9394801

    public class MvcApplication : InfBaseGlobal
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1822:MarkMembersAsStatic")]
        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();

            WebApiConfig.Register(GlobalConfiguration.Configuration);
            //FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
            StoredProcedureCachingConfig.RegisterStoredProceduresToCache();
        }

        protected void Application_AuthenticateRequest(Object sender, EventArgs e)
        {
            var authCookie = Request.Cookies[FormsAuthentication.FormsCookieName];
            if (authCookie != null)
            {
                var authTicket = FormsAuthentication.Decrypt(authCookie.Value);
                var userEmail = authTicket.Name;

                var drUser = CRCDataAccess.GetCRCUserByEmail(userEmail);
                if (drUser != null)
                {
                    var userRoles = new List<string>();

                    if (drUser["AdministratorInd"].ToString().Equals("Y", StringComparison.OrdinalIgnoreCase))
                    {
                        userRoles.Add(CRCUserRoles.Administrator);
                    }

                    if (drUser["CRCManagerInd"].ToString().Equals("Y", StringComparison.OrdinalIgnoreCase))
                    {
                        userRoles.Add(CRCUserRoles.CRCManager);
                    }

                    if (userRoles.Count < 1)
                    {
                        userRoles.Add(CRCUserRoles.StationUser);
                    }

                    var userPrincipal = new CRCUserPrincipal(new GenericIdentity(userEmail), userRoles.ToArray());
                    drUser.MapTo(userPrincipal);
                    userPrincipal.UserId = (long)drUser["UserId"];
                    userPrincipal.Email = drUser["Email"].ToString();
                    userPrincipal.FirstName = drUser["FirstName"].ToString();
                    userPrincipal.LastName = drUser["LastName"].ToString();
                    userPrincipal.IsActive = drUser["DisabledDate"] as DateTime? != null;

                    if (userPrincipal.IsInRole(CRCUserRoles.StationUser))
                    {
                        var dtStations = CRCDataAccess.GetStationsForUserId(userPrincipal.UserId);
                        foreach (DataRow drStation in dtStations.Rows)
                        {
                            var stationId = (long)drStation["StationId"];
                            var gridWritePermissionsInd = drStation["GridWritePermissionsInd"].ToString().Equals("Y", StringComparison.OrdinalIgnoreCase);

                            userPrincipal.Stations.Add(stationId, gridWritePermissionsInd);
                        }
                    }

                    Context.User = userPrincipal;
                }
            }
        }
    }
}