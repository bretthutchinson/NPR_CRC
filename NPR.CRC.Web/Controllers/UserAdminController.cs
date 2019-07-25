using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web.Mvc;
using InfoConcepts.Library.Email;
using InfoConcepts.Library.Extensions;
using MvcJqGrid;
using NPR.CRC.Library.DataAccess;
using NPR.CRC.Web.ViewModels.UserAdmin;
using NPR.CRC.Library;
using System.Data;

namespace NPR.CRC.Web.Controllers
{
    [Authorize(Roles = CRCUserRoles.Administrator + ", " + CRCUserRoles.CRCManager)]
    public class UserAdminController : BaseController
    {
        //private bool status = true;
        public ActionResult Index()
        {
            var viewModel = new SearchCRCUsersViewModel();
            return View(viewModel);
        }

        public ActionResult CRCUsersGridData(GridSettings gridSettings, string userEnabled, string stationEnabled, string userName, long? repeaterStatusId, string userRole, string band, string userPermission, long? stationId)
        {
            using (var dataTable = CRCDataAccess.SearchUsers(userEnabled, stationEnabled, userName, repeaterStatusId, userRole, band, userPermission, stationId))
            {
                return InfJqGridData(dataTable, gridSettings);
            }
        }

        public ActionResult AddEditCRCUser(long? userId)
        {
            var viewModel = new AddEditCRCUserViewModel();
            if (userId.HasValue)
            {
                var drUser = CRCDataAccess.GetCRCUser(userId.Value);
                drUser.MapTo(viewModel);

                viewModel.EnabledInd = !(drUser["DisabledDate"] is DateTime);

                var adminInd = drUser["AdministratorInd"].ToString().Equals("Y", StringComparison.OrdinalIgnoreCase);
                var userRoleName = adminInd ? "admin" : "station";
                viewModel.UserRole = viewModel.UserRolesList.First(li => li.Value.IndexOf(userRoleName, StringComparison.OrdinalIgnoreCase) >= 0).Value;
            }

            return View(viewModel);
        }

        [HttpPost]
        public ActionResult AddEditCRCUser(AddEditCRCUserViewModel viewModel)
        {
            if (ModelState.IsValid)
            {
                var adminInd = viewModel.UserRole.IndexOf("admin", StringComparison.OrdinalIgnoreCase) >= 0;
                var crcManagerInd = adminInd && viewModel.CrcManagerInd;

                viewModel.UserId = CRCDataAccess.SaveCRCUser(
                    viewModel.UserId,
                    viewModel.Email,
                    viewModel.SalutationId,
                    viewModel.FirstName,
                    viewModel.MiddleName,
                    viewModel.LastName,
                    viewModel.Suffix,
                    viewModel.JobTitle,
                    viewModel.AddressLine1,
                    viewModel.AddressLine2,
                    viewModel.City,
                    viewModel.StateId,
                    viewModel.County,
                    viewModel.Country,
                    viewModel.ZipCode,
                    viewModel.Phone,
                    viewModel.Fax,
                    adminInd,
                    crcManagerInd,
                    viewModel.EnabledInd ? (DateTime?)null : DateTime.UtcNow,
                    viewModel.EnabledInd ? (long?)null : CRCUser.UserId,
                    CRCUser.UserId);

                return RedirectToAction("Index");
            }
            else
            {
                return View(viewModel);
            }
        }

        [HttpPost]
        public ActionResult SendPasswordResetEmail(string userEmail)
        {
            var drResetPassword = CRCDataAccess.SaveCRCUserPasswordReset(userEmail, null);
            if (drResetPassword != null)
            {
                InfEmail.AddToQueue(
                    "Reset Password",
                    new
                    {
                        ResetPasswordLink = string.Format(CultureInfo.InvariantCulture, "{0}?token={1}", Url.Action("ResetPassword", "Home", null, Request.Url.Scheme), drResetPassword["Token"].ToString()),
                        CRCUserFirstName = drResetPassword["CRCUserFirstName"].ToString(),
                        CRCUserLastName = drResetPassword["CRCUserLastName"].ToString(),
                        CRCUserEmail = drResetPassword["CRCUserEmail"].ToString(),
                        CRCManagerFirstName = drResetPassword["CRCManagerFirstName"].ToString(),
                        CRCManagerLastName = drResetPassword["CRCManagerLastName"].ToString(),
                        CRCManagerEmail = drResetPassword["CRCManagerEmail"].ToString(),
                        CRCManagerPhone = drResetPassword["CRCManagerPhone"].ToString(),
                        CRCManagerJobTitle = drResetPassword["CRCManagerJobTitle"].ToString()
                    },
                    CRCUser != null ? CRCUser.UserId : (long)drResetPassword["UserId"]);

                return Json(true);
            }

            return Json(false);
        }

        public ActionResult ManageStationLinks(long userId)
        {
            var viewModel = new ManageStationLinksViewModel();
            viewModel.UserId = userId;
            return View(viewModel);
        }

        public ActionResult ManageStationLinksGridData(GridSettings gridSettings, long userId)
        {
            using (var dataTable = CRCDataAccess.GetStationsForUserId(userId))
            {
                return InfJqGridData(dataTable, gridSettings);
            }
        }

        public ActionResult AddEditStationLink(long? userId, long? stationId)
        {
            //status = true;
            var viewModel = new AddEditStationLinkViewModel();
            if (userId.HasValue)
            {
                viewModel.UserId = userId.Value;

                if (stationId.HasValue)
                {
                    viewModel.StationId = stationId;
                    // status = false;
                    var drStationUser = CRCDataAccess.GetStationUser(stationId.Value, userId.Value);
                    drStationUser.MapTo(viewModel);
                }
            }

            return PartialView(viewModel);
        }

        [HttpPost]
        public ActionResult AddEditStationLink(AddEditStationLinkViewModel viewModel)
        {
            if (!(viewModel.StationId.HasValue))
            {
                var dataTable = CRCDataAccess.GetStationLinkStatus(viewModel.UserId, viewModel.StationId);


                if (dataTable.Rows.Count != 0)
                {

                    ModelState.AddModelError("StationId", "This user is already linked to this station.");
                    return PartialView(viewModel);
                    // return Json(true);

                }
            }

            //if (viewModel.PrimaryUserInd)
            //{

            //    var dataTable = CRCDataAccess.GetStationLinkPrimaryUser(viewModel.StationId);
            //    if (dataTable.Rows.Count != 0)
            //    {
            //        string name = "";
            //        foreach (System.Data.DataRow dr in dataTable.Rows)
            //        {
            //            name = name + dr["FirstName"].ToString() + " " + dr["MiddleName"].ToString() + " " + dr["LastName"].ToString() + " is the current primary user. Only one user may be designated the primary user for this station.";
            //        }
            //        ModelState.AddModelError("", name);
            //        return PartialView(viewModel);
            //    }
            //}

            if (ModelState.IsValid)
            {
                if (viewModel.PrimaryUserInd)
                {
                    viewModel.GridWritePermissionsInd = true;
                }
                CRCDataAccess.SaveStationUser(viewModel.StationId.Value, viewModel.UserId, viewModel.PrimaryUserInd, viewModel.GridWritePermissionsInd, CRCUser.UserId);
                return Json(true);
            }
            else
            {
                return PartialView(viewModel);
            }

            return PartialView(viewModel);

        }

        public ActionResult AddEditStationLinkGridData(GridSettings gridSetting, long userId)
        {
            using (var dataTable = CRCDataAccess.GetStationListForGrid(userId))
            {
                return InfJqGridData(dataTable, gridSetting);
            }

        }

        public ActionResult RemoveStationUserLink(long userId, long stationId, long? primaryUserId)
        {
            try
            {
                CRCDataAccess.RemoveUserStationLink(userId, stationId);
            }
            catch (EntitySqlException e)
            {
                Console.Write(e);
            }


            if (primaryUserId.HasValue)
            {

                if (userId == primaryUserId)
                {
                    CRCDataAccess.UpdatePrimaryUserStatus(stationId);
                }
            }
            return Empty();
        }



		public ActionResult NewUserRequest(long userId)
        {

			if(userId==1)
			{
				userId = 1;
			}
			//try
			//{
			//	CRCDataAccess.RemoveUserStationLink(userId, stationId);
			//}
			//catch (EntitySqlException e)
			//{
			//	Console.Write(e);
			//}


			//if (primaryUserId.HasValue)
			//{

			//	if (userId == primaryUserId)
			//	{
			//		CRCDataAccess.UpdatePrimaryUserStatus(stationId);
			//	}
			//}
            return Json( "1",JsonRequestBehavior.AllowGet);
        }
    }

}