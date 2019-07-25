using System;
using System.Web.Mvc;
using MvcJqGrid;
using NPR.CRC.Library;
using NPR.CRC.Library.DataAccess;
using NPR.CRC.Web.ViewModels.ScheduleAdmin;

namespace NPR.CRC.Web.Controllers
{
    [Authorize(Roles = CRCUserRoles.Administrator + ", " + CRCUserRoles.CRCManager)]
    public class ScheduleAdminController : BaseController
    {
        public ActionResult Index()
        {
            var viewModel = new ManageSchedulesViewModel();
            return View(viewModel);
        }

        public ActionResult SearchSchedulesGridData(GridSettings gridSettings, int? month, int? year, string status)
        {
            using (var dataTable = CRCDataAccess.SearchSchedules(null, month, year, status))
            {
                return InfJqGridData(dataTable, gridSettings);
            }
        }

        public ActionResult SearchSchedulesGridDataManage(GridSettings gridSettings, int? month, int? year, string status)
        {
            using (var dataTable = CRCDataAccess.SearchSchedulesManage(null, month, year, status))
            {
                return InfJqGridData(dataTable, gridSettings);
            }
        }


        [HttpPost]
        public JsonResult UpdateScheduleStatus(string[][] schedulesList)
        {
            string scheduleId, status;

            for (int i = 0; i < schedulesList.Length; i++)
            {
                scheduleId = schedulesList[i][0];
                status = schedulesList[i][1];
                CRCDataAccess.SaveScheduleStatus(DataParser.GetLong(scheduleId), status, CRCUser.UserId);
            }

            return Json(true, JsonRequestBehavior.AllowGet);
        }
    }
}
