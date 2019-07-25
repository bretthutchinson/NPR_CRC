using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using MvcJqGrid;
using NPR.CRC.Library.DataAccess;
using NPR.CRC.Web.ViewModels.ProgramAdmin;
using InfoConcepts.Library.Extensions;
using NPR.CRC.Library;

namespace NPR.CRC.Web.Controllers
{
    [Authorize(Roles=CRCUserRoles.Administrator + ", " + CRCUserRoles.CRCManager)]
    public class ProgramAdminController : BaseController
    {
        public ActionResult Index()
        {
            return RedirectToAction("SearchByProgram");
        }

        public ActionResult SearchByProgram()
        {
            var viewModel = new SearchByProgramViewModel();
            return View(viewModel);
        }

        public ActionResult SearchByProgramGridData(GridSettings gridSettings, long? programId, long? programSourceId, string enabled, long? programFormatTypeId, long? majorFormatId)
        {
            using (var dataTable = CRCDataAccess.SearchPrograms(programId, programSourceId, programFormatTypeId, majorFormatId, enabled))
            {
                return InfJqGridData(dataTable, gridSettings);
            }
        }

        public ActionResult SearchByProgramProducer()
        {
            var viewModel = new SearchByProgramProducerViewModel();
            return View(viewModel);
        }

        public ActionResult SearchByProgramProducerGridData(GridSettings gridSettings, long? programId, long? producerId)
        {
            using (var dataTable = CRCDataAccess.SearchProgramProducers(programId, producerId))
            {
                return InfJqGridData(dataTable, gridSettings);
            }
        }

        public ActionResult ProgramNameSearch(string programName, bool startsWithInd)
        {
            using (var dtPrograms = CRCDataAccess.GetProgramsByName(programName, startsWithInd))
            {
                return Json(
                    dtPrograms
                        .AsEnumerable()
                        .Select(row => row["ProgramName"].ToString())
                        .OrderBy(s => s), JsonRequestBehavior.AllowGet);
            }
        }

        public ActionResult AddEditProgram(long? programId)
        {
            var viewModel = new AddEditProgramViewModel();
            if (programId.HasValue)
            {
                var drProgram = CRCDataAccess.GetProgram(programId.Value);
                drProgram.MapTo(viewModel);

                viewModel.EnabledInd = !(drProgram["DisabledDate"] is DateTime);
            }

            return View(viewModel);
        }

        [HttpPost]
        public ActionResult AddEditProgram(AddEditProgramViewModel viewModel)
        {
            if (ModelState.IsValid)
            {
                CRCDataAccess.SaveProgram(
                    viewModel.ProgramId,
                    viewModel.ProgramName,
                    viewModel.ProgramSourceId,
                    viewModel.ProgramFormatTypeId,
                    viewModel.ProgramCode,
                    viewModel.CarriageTypeId,
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

        public ActionResult ManageProgramProducers(long programId)
        {
            var viewModel = new ManageProgramProducersViewModel();
            viewModel.ProgramId = programId;
            return View(viewModel);
        }

        public ActionResult _ManageProgramProducers(long programId)
        {
            var viewModel = new ManageProgramProducersViewModel();
            viewModel.ProgramId = programId;
            return PartialView(viewModel);
        }

        public ActionResult ManageProgramProducersGridData(GridSettings gridSettings, long programId)
        {
            using (var dataTable = CRCDataAccess.GetProgramProducersByProgramId(programId))
            {
                return InfJqGridData(dataTable, gridSettings);
            }
        }

        public ActionResult SelectProgramProducer(long programId)
        {
            var viewModel = new SelectProgramProducerViewModel();
            viewModel.ProgramId = programId;
            return PartialView(viewModel);
        }

        [HttpPost]
        public ActionResult SelectProgramProducer(SelectProgramProducerViewModel viewModel)
        {
            if (ModelState.IsValid)
            {
                CRCDataAccess.SaveProgramProducer(viewModel.ProgramId, viewModel.ProducerId, CRCUser.UserId);
                return Json(true);
            }
            else
            {
                return PartialView(viewModel);
            }
        }

        public ActionResult RemoveProgramProducer(long programProducerId)
        {
            CRCDataAccess.RemoveProgramProducer(programProducerId);
            return Empty();
        }

        public ActionResult MajorFormats()
        {
            return View();
        }

        public ActionResult MajorFormatsGridData(GridSettings gridSettings)
        {
            using (var dataTable = CRCDataAccess.GetMajorFormats())
            {   
                return InfJqGridData(dataTable, gridSettings);
            }
        }

        public ActionResult AddEditMajorFormat(long? majorFormatId)
        {
            var viewModel = new AddEditMajorFormatViewModel();
            if (majorFormatId.HasValue)
            {
                var drMajorFormat = CRCDataAccess.GetMajorFormat(majorFormatId.Value);
                drMajorFormat.MapTo(viewModel);

                viewModel.EnabledInd = !(drMajorFormat["DisabledDate"] is DateTime);
            }

            return PartialView(viewModel);
        }

        [HttpPost]
        public ActionResult AddEditMajorFormat(AddEditMajorFormatViewModel viewModel)
        {
            if (ModelState.IsValid)
            {
                CRCDataAccess.SaveMajorFormat(
                    viewModel.MajorFormatId,
                    viewModel.MajorFormatName,
                    viewModel.MajorFormatCode,
                    viewModel.EnabledInd ? (DateTime?)null : DateTime.UtcNow,
                    viewModel.EnabledInd ? (long?)null : CRCUser.UserId,
                    CRCUser.UserId);

                return Json(true);
            }
            else
            {
                return PartialView(viewModel);
            }
        }

        public ActionResult ProgramSources()
        {
            return View();
        }

        public ActionResult ProgramSourcesGridData(GridSettings gridSettings)
        {
            using (var dataTable = CRCDataAccess.GetProgramSources())
            {
                return InfJqGridData(dataTable, gridSettings);
            }
        }

        public ActionResult AddEditProgramSource(long? programSourceId)
        {
            var viewModel = new AddEditProgramSourceViewModel();
            if (programSourceId.HasValue)
            {
                var drProgramSources = CRCDataAccess.GetProgramSource(programSourceId.Value);
                drProgramSources.MapTo(viewModel);

                viewModel.EnabledInd = !(drProgramSources["DisabledDate"] is DateTime);
            }

            return PartialView(viewModel);
        }

        [HttpPost]
        public ActionResult AddEditProgramSource(AddEditProgramSourceViewModel viewModel)
        {
            if (ModelState.IsValid)
            {
                CRCDataAccess.SaveProgramSource(
                    viewModel.ProgramSourceId,
                    viewModel.ProgramSourceName,
                    viewModel.ProgramSourceCode,
                    viewModel.EnabledInd ? (DateTime?)null : DateTime.UtcNow,
                    viewModel.EnabledInd ? (long?)null : CRCUser.UserId,
                    CRCUser.UserId);

                return Json(true);
            }
            else
            {
                return PartialView(viewModel);
            }
        }

        public ActionResult ProducerContact()
        {
            return View();
        }

        public ActionResult ProducerContactGridData(GridSettings gridSettings)
        {
            using (var dataTable = CRCDataAccess.GetProducers())
            {
                return InfJqGridData(dataTable, gridSettings);
            }
        }

        public ActionResult AddEditProducerContact(long? producerId)
        {
            var viewModel = new AddEditProducerContactViewModel();
            if (producerId.HasValue)
            {
                var drProducersContacts = CRCDataAccess.GetProducer(producerId.Value);
                drProducersContacts.MapTo(viewModel);

                viewModel.EnabledInd = !(drProducersContacts["DisabledDate"] is DateTime);
            }

            return PartialView(viewModel);
        }

        [HttpPost]
        public ActionResult AddEditProducerContact(AddEditProducerContactViewModel viewModel)
        {
            if (ModelState.IsValid)
            {
                CRCDataAccess.SaveProducer(
                    viewModel.ProducerId,
                    viewModel.SalutationId,
                    viewModel.FirstName,
                    viewModel.MiddleName,
                    viewModel.LastName,
                    viewModel.Suffix,
                    viewModel.Role,
                    viewModel.Email,
                    viewModel.Phone,
                    viewModel.EnabledInd ? (DateTime?)null : DateTime.UtcNow,
                    viewModel.EnabledInd ? (long?)null : CRCUser.UserId,
                    CRCUser.UserId);

                return Json(true);
            }
            else
            {
                return PartialView(viewModel);
            }
        }

        public ActionResult CarriageType()
        {
            return View();
        }

        public ActionResult CarriageTypeGridData(GridSettings gridSettings)
        {
            using (var dataTable = CRCDataAccess.GetCarriageTypes())
            {
                return InfJqGridData(dataTable, gridSettings);
            }
        }

        public ActionResult AddEditCarriageType(long? carriageTypeId)
        {
            var viewModel = new AddEditCarriageTypeViewModel();
            if (carriageTypeId.HasValue)
            {
                var drProducersContacts = CRCDataAccess.GetCarriageType(carriageTypeId.Value);
                drProducersContacts.MapTo(viewModel);

                viewModel.EnabledInd = !(drProducersContacts["DisabledDate"] is DateTime);
            }

            return PartialView(viewModel);
        }

        [HttpPost]
        public ActionResult AddEditCarriageType(AddEditCarriageTypeViewModel viewModel)
        {
            if (ModelState.IsValid)
            {
                CRCDataAccess.SaveCarriageType(
                    viewModel.CarriageTypeId,
                    viewModel.CarriageTypeName,                   
                    viewModel.EnabledInd ? (DateTime?)null : DateTime.UtcNow,
                    viewModel.EnabledInd ? (long?)null : CRCUser.UserId,
                    CRCUser.UserId);

                return Json(true);
            }
            else
            {
                return PartialView(viewModel);
            }
        }

        #region Program Format
        public ActionResult ProgramFormat()
        {
            return View();
        }

        public ActionResult ProgramFormatTypeGridData(GridSettings gridSettings)
        {
            using (var dataTable = CRCDataAccess.GetProgramFormatTypes())
            {
                return InfJqGridData(dataTable, gridSettings);
            }
        }

        public ActionResult AddEditProgramFormat(long? programFormatTypeId)
        {
            var viewModel = new AddEditProgramFormatViewModel();
            if (programFormatTypeId.HasValue)
            {
                var drProgramFormat = CRCDataAccess.GetProgramFormatType(programFormatTypeId.Value);
                drProgramFormat.MapTo(viewModel);

                viewModel.EnabledInd = !(drProgramFormat["DisabledDate"] is DateTime);
            }

            return PartialView(viewModel);
        }

        [HttpPost]
        public ActionResult AddEditProgramFormat(AddEditProgramFormatViewModel viewModel)
        {
            if (ModelState.IsValid)
            {
                CRCDataAccess.SaveProgramFormatType(
                    viewModel.ProgramFormatTypeId,
                    viewModel.ProgramFormatTypeName,
                    viewModel.ProgramFormatTypeCode,
                    viewModel.MajorFormatId,
                    viewModel.EnabledInd ? (DateTime?)null : DateTime.UtcNow,
                    viewModel.EnabledInd ? (long?)null : CRCUser.UserId,
                    CRCUser.UserId);

                return Json(true);
            }
            else
            {
                return PartialView(viewModel);
            }
        }
        #endregion Program Format
    }
}
