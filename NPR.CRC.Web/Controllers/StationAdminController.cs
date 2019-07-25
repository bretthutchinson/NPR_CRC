using System;
using System.Data;
using System.Collections;
using System.Linq;
using System.Web.Mvc;
using InfoConcepts.Library.Extensions;
using MvcJqGrid;
using NPR.CRC.Library.DataAccess;
using InfoConcepts.Library.Utilities;
using NPR.CRC.Web.ViewModels.StationAdmin;
using NPR.CRC.Library;
using System.Collections.Generic;
using CsvHelper;
using CsvHelper.Configuration;
using System.IO;
using System.Threading;


namespace NPR.CRC.Web.Controllers
{
    [Authorize(Roles = CRCUserRoles.Administrator + ", " + CRCUserRoles.CRCManager)]
    public class StationAdminController : BaseController
    {
        public ActionResult Index()
        {
            var viewModel = new SearchStationsViewModel();
            return View(viewModel);
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1822:MarkMembersAsStatic"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", MessageId = "gridSettings")]
        public ActionResult StationsGridDataReport(GridSettings gridSettings, long? stationId, long? repeaterStatusId, long? metroMarketId, string enabled, long? memberStatusId, long? dmaMarketId, string bandId, long? stateId, long? licenseeTypeId, long? affiliateId)
        {
            using (var dataTable = CRCDataAccess.SearchStations(stationId, repeaterStatusId, metroMarketId, enabled, memberStatusId, dmaMarketId, bandId, stateId, licenseeTypeId, affiliateId))
            {
                //return InfJqGridData(dataTable, gridSettings);
                ConvertToXLSX(dataTable, "test", false, -1);
                return null;
            }
        }


        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1804:RemoveUnusedLocals", MessageId = "h"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", MessageId = "sheetName"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1820:TestForEmptyStringsUsingStringLength")]
        public void ConvertToXLSX(DataTable table, string fileName, bool header, int multiDayColumn)
        {
            MemoryStream Result = new MemoryStream();
            OfficeOpenXml.ExcelPackage pack = new OfficeOpenXml.ExcelPackage();
            OfficeOpenXml.ExcelWorksheet ws = null;
            OfficeOpenXml.Style.Border br;

            int col = 1;
            int row = 1;
            int scnt = 0;
            Hashtable h = new Hashtable();
            ws = pack.Workbook.Worksheets.Add("Sheet 1");

            if (row == 1 && header == true)
            {

                foreach (DataColumn cl in table.Columns)
                {
                    if (col > 0)
                    {


                        ws.Cells[row, col].Value = cl.ColumnName;
                        ws.Cells[row, col].Style.Font.Bold = true;
                        ws.Cells[row, col].Style.Fill.PatternType = OfficeOpenXml.Style.ExcelFillStyle.Solid;

                        ws.Cells[row, col].Style.Fill.BackgroundColor.SetColor(System.Drawing.Color.LightGray);
                        ws.Cells[row, col].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Left;
                        br = ws.Cells[row, col].Style.Border;
                        br.Left.Style = br.Right.Style = br.Bottom.Style = br.Top.Style = OfficeOpenXml.Style.ExcelBorderStyle.Thin;

                    }
                    col++;
                }
                row++;
                col = 1;
            }

            foreach (DataRow rw in table.Rows)
            {

                double number;
                foreach (DataColumn cl in table.Columns)
                {

                    if (col > 0)
                    {

                        if (rw[cl.ColumnName] != DBNull.Value)
                        {
                            if (col != multiDayColumn)
                            {
                                //ws.Cells[row, col].Value = rw[cl.ColumnName].ToString();
                                if (Double.TryParse(rw[cl.ColumnName].ToString(), out number))
                                {
                                    ws.Cells[row, col].Value = number;
                                    //if (col == 14 || col == 15 || col == 19 || col == 21 || col == 22 || col == 23)
                                    //    ws.Cells[row, col].Style.Numberformat.Format = "0.00";
                                }
                                else
                                    ws.Cells[row, col].Value = rw[cl.ColumnName].ToString();
                                //if (rw[cl.ColumnName].ToString().IndexOf("%") != -1)
                                //{
                                //    ws.Cells[row, col].Style.Numberformat.Format = "0%";
                                //    ws.Cells[row, col].Value = Double.Parse(rw[cl.ColumnName].ToString().TrimEnd('%')) / 100;
                                //}
                            }
                            
                        }
                        br = ws.Cells[row, col].Style.Border;
                        br.Left.Style = br.Right.Style = br.Bottom.Style = br.Top.Style = OfficeOpenXml.Style.ExcelBorderStyle.Thin;
                        ws.Cells[row, col].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Left;

                    }

                    col++;
                }
                scnt++;
                row++;
                col = 1;

            }
            if (row > 1)
            {
                ws.Cells.AutoFitColumns();
                ws.View.ShowGridLines = false;
                ws.PrinterSettings.FitToPage = true;
                ws.PrinterSettings.FitToWidth = 1;
                ws.PrinterSettings.FitToHeight = 0;
                if (header)
                    ws.PrinterSettings.RepeatRows = ws.Cells["1:1"];
            }

            pack.SaveAs(Result);
            Result.WriteTo(Response.OutputStream);

            Response.AddHeader("Content-Disposition", "attachment;filename=" + fileName + ".xlsx");
            Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            Response.StatusCode = 200;
      

        }



        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1822:MarkMembersAsStatic"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", MessageId = "gridSettings")]
        public ActionResult StationsGridData(GridSettings gridSettings, long? stationId, long? repeaterStatusId, long? metroMarketId, string enabled, long? memberStatusId, long? dmaMarketId, string bandId, long? stateId, long? licenseeTypeId, long? affiliateId)
        {
            using (var dataTable = CRCDataAccess.SearchStations(stationId, repeaterStatusId, metroMarketId, enabled, memberStatusId, dmaMarketId, bandId, stateId, licenseeTypeId, affiliateId))
            {
                return InfJqGridData(dataTable, gridSettings);
                //return null;
            }
        }

        public ActionResult AddEditStation(long? stationId, string copyInd)
        {
            var viewModel = new AddEditStationViewModel();
            if (stationId.HasValue)
            {
                var drStation = CRCDataAccess.GetStation(stationId.Value);
                drStation.MapTo(viewModel);

                viewModel.EnabledInd = !(drStation["DisabledDate"] is DateTime);
                viewModel.CopyInd = copyInd.Equals("Y", StringComparison.OrdinalIgnoreCase) ? "Y" : "N";

                using (var dtStationAffiliates = CRCDataAccess.GetStationAffiliates(stationId.Value))
                {
                    viewModel.AffiliateIds = dtStationAffiliates.AsEnumerable().Select(row => (long)row["AffiliateId"]);
                }
            }
            else
            {
                //Set default values when adding a new station
                viewModel.EnabledInd = true;
                viewModel.MemberStatusId = InfLookupHelper.ReverseLookup("MemberStatus", "MemberStatusName", "Full");
                viewModel.MinorityStatusId = InfLookupHelper.ReverseLookup("MinorityStatus", "MinorityStatusName", "None");
                viewModel.StatusDate = DateTime.UtcNow.AddHours(InfDate.GetUtcOffSet);
                //viewModel.TimeZoneId = InfLookupHelper.ReverseLookup("TimeZone", "TimeZoneCode", "Eastern Standard Time");
                viewModel.MaxNumberOfUsers = 4;
            }

            return View(viewModel);
        }

        [HttpPost]
        public ActionResult AddEditStation(AddEditStationViewModel viewModel)
        {
            if (!CRCDataAccess.ValidateCallLettersIsUnique(viewModel.CopyInd.Equals("Y", StringComparison.OrdinalIgnoreCase) ? null : viewModel.StationId, viewModel.CallLetters, viewModel.BandId))
            {
                ModelState.AddModelError("CallLetters", "Call Letters: " + viewModel.CallLetters + " already exists.");
            }
            if (ModelState.IsValid)
            {
                long stationId;
                stationId = CRCDataAccess.SaveStation(
                    viewModel.CopyInd.Equals("Y", StringComparison.OrdinalIgnoreCase) ? null : viewModel.StationId,
                    viewModel.CallLetters,
                    viewModel.BandId,
                    viewModel.Frequency,
                    viewModel.RepeaterStatusId,
                    viewModel.FlagshipStationId,
                    viewModel.MemberStatusId,
                    viewModel.MinorityStatusId,
                    viewModel.StatusDate,
                    viewModel.LicenseeTypeId,
                    viewModel.LicenseeName,
                    viewModel.AddressLine1,
                    viewModel.AddressLine2,
                    viewModel.City,
                    viewModel.StateId,
                    viewModel.County,
                    viewModel.Country,
                    viewModel.ZipCode,
                    viewModel.Phone,
                    viewModel.Fax,
                    viewModel.Email,
                    viewModel.WebPage,
                    viewModel.TsaCume,
                    viewModel.Tsaaqh,
                    viewModel.MetroMarketId,
                    viewModel.MetroMarketRank,
                    viewModel.DmaMarketId,
                    viewModel.DmaMarketRank,
                    viewModel.TimeZoneId,
                    viewModel.HoursFromFlagship,
                    viewModel.MaxNumberOfUsers,
                    viewModel.EnabledInd ? (DateTime?)null : DateTime.UtcNow,
                    viewModel.EnabledInd ? (long?)null : CRCUser.UserId,
                    CRCUser.UserId);

                CRCDataAccess.DeleteStationAffiliates(stationId);
                if (viewModel.AffiliateIds != null)
                {
                    foreach (long affiliateId in viewModel.AffiliateIds)
                    {
                        CRCDataAccess.SaveStationAffiliate(0, stationId, affiliateId, CRCUser.UserId);
                    }
                }


                return RedirectToAction("StationDetail", new { stationId = stationId });
                /* if (viewModel.StationId.HasValue)
                 {
                    return RedirectToAction("StationDetail", new { stationId=viewModel.StationId});
                 }
                 return RedirectToAction("Index"); */
            }
            else
            {
                return View(viewModel);
            }

        }


        public ActionResult StationDetail(long? stationId)
        {
            var viewModel = new StationDetailViewModel();
            if (stationId.HasValue)
            {
                var drStation = CRCDataAccess.GetStationDetail(stationId.Value);
                drStation.MapTo(viewModel);
                viewModel.EnabledInd = !(drStation["DisabledDate"] is DateTime);

            }

            return View(viewModel);
        }

        public ActionResult StationAssociatesGridData(GridSettings gridSettings, long stationId, string hdFlag)
        {
            using (var dataTable = CRCDataAccess.GetStationAssociates(stationId, hdFlag))
            {
                return InfJqGridData(dataTable, gridSettings);
            }
        }

        public ActionResult StationUsersGridData(GridSettings gridSettings, long stationId)
        {
            using (var dataTable = CRCDataAccess.GetStationUsers(stationId))
            {
                return InfJqGridData(dataTable, gridSettings);
            }
        }

        public ActionResult StationNotesGridData(GridSettings gridSettings, long stationId)
        {
            using (var dataTable = CRCDataAccess.GetStationNotes(stationId))
            {
                return InfJqGridData(dataTable, gridSettings);
            }
        }

        public ActionResult AddEditStationNote(long? stationNoteId, long stationId, string callLetters)
        {
            var viewModel = new AddEditStationNoteViewModel();

            if (stationNoteId.HasValue)
            {
                var drStationNote = CRCDataAccess.GetStationNote(stationNoteId.Value);
                drStationNote.MapTo(viewModel);
                viewModel.NoteText = viewModel.NoteText.Replace("''", "'");
            }
            else
            {
                viewModel.StationId = stationId;
            }

            viewModel.CallLetters = callLetters;

            return PartialView(viewModel);
        }

        [HttpPost]
        public void AddEditStationNote(AddEditStationNoteViewModel viewModel)
        {
            if (ModelState.IsValid)
            {
                CRCDataAccess.SaveStationNote(
                    viewModel.StationNoteId,
                    viewModel.StationId,
                    viewModel.NoteText.Replace("'", ""),
                    (DateTime?)null,
                    (long?)null,
                    CRCUser.UserId
                    );
            }
        }

        public ActionResult DeleteStationNote(long stationNoteId, string deleteInd)
        {
            if (deleteInd.Equals("Y", StringComparison.OrdinalIgnoreCase))
            {
                CRCDataAccess.DeleteStationNote(stationNoteId, DateTime.Now, CRCUser.UserId, DateTime.Now, CRCUser.UserId);
            }
            else
            {
                CRCDataAccess.DeleteStationNote(stationNoteId, null, null, DateTime.Now, CRCUser.UserId);
            }
            return Json(true, JsonRequestBehavior.AllowGet);
        }

        public ActionResult Affiliates()
        {
            return View();
        }

        public ActionResult AffiliatesGridData(GridSettings gridSettings)
        {
            using (var dataTable = CRCDataAccess.GetAffiliates())
            {
                return InfJqGridData(dataTable, gridSettings);
            }
        }

        public ActionResult AddEditAffiliate(long? affiliateId)
        {
            var viewModel = new AddEditAffiliateViewModel();
            if (affiliateId.HasValue)
            {
                var drAffiliate = CRCDataAccess.GetAffiliate(affiliateId.Value);
                drAffiliate.MapTo(viewModel);

                viewModel.EnabledInd = !(drAffiliate["DisabledDate"] is DateTime);
            }

            return PartialView(viewModel);
        }

        [HttpPost]
        public ActionResult AddEditAffiliate(AddEditAffiliateViewModel viewModel)
        {
            if (ModelState.IsValid)
            {
                CRCDataAccess.SaveAffiliate(
                    viewModel.AffiliateId,
                    viewModel.AffiliateName,
                    viewModel.AffiliateCode,
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
        #region LicenseType

        public ActionResult LicenseeType()
        {
            return View();
        }

        public ActionResult LicenseeTypeGridData(GridSettings gridSettings)
        {
            using (var dataTable = CRCDataAccess.GetLicenseeTypes())
            {
                return InfJqGridData(dataTable, gridSettings);
            }
        }

        public ActionResult AddEditLicenseeType(long? licenseeTypeId)
        {
            var viewModel = new AddEditLicenseeTypeViewModel();
            if (licenseeTypeId.HasValue)
            {
                var drLicenseeType = CRCDataAccess.GetLicenseeType(licenseeTypeId.Value);
                drLicenseeType.MapTo(viewModel);

                viewModel.EnabledInd = !(drLicenseeType["DisabledDate"] is DateTime);
            }
            return PartialView(viewModel);
        }

        [HttpPost]
        public ActionResult AddEditLicenseeType(AddEditLicenseeTypeViewModel viewModel)
        {
            if (ModelState.IsValid)
            {
                CRCDataAccess.SaveLicenseeType(
                    viewModel.LicenseeTypeId,
                    viewModel.LicenseeTypeName,
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
        #endregion LicenseType

        #region Member Status

        public ActionResult MemberStatus()
        {
            return View();
        }

        public ActionResult MemberStatusGridData(GridSettings gridSettings)
        {
            using (var dataTable = CRCDataAccess.GetMemberStatuses())
            {
                return InfJqGridData(dataTable, gridSettings);
            }
        }

        public ActionResult AddEditMemberStatus(long? memberStatusId)
        {
            var viewModel = new AddEditMemberStatusViewModel();
            if (memberStatusId.HasValue)
            {
                var drMemberStatus = CRCDataAccess.GetMemberStatus(memberStatusId.Value);
                drMemberStatus.MapTo(viewModel);

                viewModel.NPRMemberShipInd = !(drMemberStatus["DisabledDate"] is DateTime);
            }
            return PartialView(viewModel);
        }

        [HttpPost]
        public ActionResult AddEditMemberStatus(AddEditMemberStatusViewModel viewModel)
        {
            if (ModelState.IsValid)
            {
                CRCDataAccess.SaveMemberStatus(
                    viewModel.MemberStatusId,
                    viewModel.MemberStatusName,
                    viewModel.NPRMemberShipInd,
                    viewModel.NPRMemberShipInd ? (DateTime?)null : DateTime.UtcNow,
                    viewModel.NPRMemberShipInd ? (long?)null : CRCUser.UserId,
                    CRCUser.UserId);
                return Json(true);
            }
            else
            {
                return PartialView(viewModel);
            }
        }
        #endregion Member Status
        #region Minority Status

        public ActionResult MinorityStatus()
        {
            return View();
        }

        public ActionResult MinorityStatusGridData(GridSettings gridSettings)
        {
            using (var dataTable = CRCDataAccess.GetMinorityStatuses())
            {
                return InfJqGridData(dataTable, gridSettings);
            }
        }

        public ActionResult AddEditMinorityStatus(long? minorityStatusId)
        {
            var viewModel = new AddEditMinorityStatusViewModel();
            if (minorityStatusId.HasValue)
            {
                var drMinorityStatus = CRCDataAccess.GetMinorityStatus(minorityStatusId.Value);
                drMinorityStatus.MapTo(viewModel);

                viewModel.EnabledInd = !(drMinorityStatus["DisabledDate"] is DateTime);
            }
            return PartialView(viewModel);
        }

        [HttpPost]
        public ActionResult AddEditMinorityStatus(AddEditMinorityStatusViewModel viewModel)
        {
            if (ModelState.IsValid)
            {
                CRCDataAccess.SaveMinorityStatus(
                    viewModel.MinorityStatusId,
                    viewModel.MinorityStatusName,
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
        #endregion Minority Status

        #region Band
        public ActionResult Bands()
        {
            return View();
        }

        public ActionResult BandGridData(GridSettings gridSettings)
        {
            using (var dataTable = CRCDataAccess.GetBands())
            {
                return InfJqGridData(dataTable, gridSettings);
            }
        }

        public ActionResult AddEditBand(long? bandId)
        {
            var viewModel = new AddEditBandViewModel();
            if (bandId.HasValue)
            {
                var drBand = CRCDataAccess.GetBand(bandId.Value);
                drBand.MapTo(viewModel);

                viewModel.EnabledInd = !(drBand["DisabledDate"] is DateTime);
            }
            return PartialView(viewModel);
        }

        [HttpPost]
        public ActionResult AddEditBand(AddEditBandViewModel viewModel)
        {
            if (ModelState.IsValid)
            {
                CRCDataAccess.SaveBand(
                    viewModel.BandId,
                    viewModel.BandName,
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
        #endregion Band


        #region DMA / Metro
        public ActionResult DMAMetro()
        {
            var viewModel = new ImportDocumentViewModel();
            return View(viewModel);
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1804:RemoveUnusedLocals", MessageId = "rank"), HttpPost]
        public ActionResult DMAMetro(ImportDocumentViewModel viewModel)
        {
            if (ModelState.IsValid)
            {
                StreamReader streamReader = new StreamReader(viewModel.Document.InputStream);
                CsvReader csvReader = new CsvReader(streamReader);
                csvReader.Configuration.RegisterClassMap<ImportStationMap>();
                IEnumerable<ImportStationViewModel> records = csvReader.GetRecords<ImportStationViewModel>().ToList();
                long rank = 0;
                foreach (var rec in records)
                {
                    if (!rec.Band.Equals("ER", StringComparison.CurrentCultureIgnoreCase) && rec.Market.Length != 0 && rec.Rank.Length != 0 && viewModel.ImportType != null)
                    {
                        if (viewModel.ImportType.Equals("DMA"))
                        {
                            //rank = Int64.Parse(rec.Rank.Replace("t", ""));
                            rec.Result = CRCDataAccess.UpdateDMAMarket(rec.CallLetters, rec.Band, rec.Market, rec.Rank, CRCUser.UserId);
                        }
                        else
                        {
                            rec.Result = CRCDataAccess.UpdateMetroMarket(rec.CallLetters, rec.Band, rec.Market, rec.Rank.Replace("t", ""), CRCUser.UserId);
                        }
                    }
                }

                viewModel.Results = records.ToList();
                return PartialView(viewModel);
            }
            else
            {
                return PartialView(viewModel);
            }
        }
        #endregion DMA / Metro

        #region AQHCumeImport

        public ActionResult AQHCumeImport()
        {
            var viewModel = new ImportDocumentAQHCumeViewModel();
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult AQHCumeImport(ImportDocumentAQHCumeViewModel viewModel)
        {
            if (ModelState.IsValid)
            {
                StreamReader streamReader = new StreamReader(viewModel.Document.InputStream);
                CsvReader csvReader = new CsvReader(streamReader);
                csvReader.Configuration.RegisterClassMap<ImportAQHCumeMap>();
                IEnumerable<ImportAQHCumeViewModel> records = csvReader.GetRecords<ImportAQHCumeViewModel>().ToList();
                foreach (var rec in records)
                {
                    if (!rec.Band.Equals("ER", StringComparison.CurrentCultureIgnoreCase) && rec.AQH.Length != 0 && rec.Cume.Length != 0)
                        rec.Result = CRCDataAccess.UpdateStationAQHCume(rec.CallLetters, rec.Band, DataParser.GetLong(rec.AQH), DataParser.GetLong(rec.Cume), CRCUser.UserId);
                }

                viewModel.Results = records.ToList();
                return PartialView(viewModel);
            }
            else
            {
                return PartialView(viewModel);
            }
        }

        #endregion

        #region Helper Methods
        public ActionResult ImportStations(ImportDocumentViewModel viewModel)
        {
            StreamReader streamReader = new StreamReader(viewModel.Document.InputStream);
            CsvReader csvReader = new CsvReader(streamReader);
            csvReader.Configuration.RegisterClassMap<ImportStationMap>();
            IEnumerable<ImportStationViewModel> records = csvReader.GetRecords<ImportStationViewModel>();
            foreach (var rec in records)
            {
                rec.Result = CRCDataAccess.UpdateDMAMarket(rec.CallLetters, rec.Band, rec.Market, rec.Rank, CRCUser.UserId);
            }

            return null;
        }

        #endregion Helper Methods
    }


}
