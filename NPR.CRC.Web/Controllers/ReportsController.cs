using NPR.CRC.Library;
using System;
using System.IO;
using System.Data;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Mvc;
using NPR.CRC.Web.ViewModels.Reports;
using MvcJqGrid;
using NPR.CRC.Library.DataAccess;
using InfoConcepts.Library.Reporting;
using iTextSharp.text;
using iTextSharp.text.pdf;
using iTextSharp.text.html;
using iTextSharp.text.html.simpleparser;
using System.Diagnostics.CodeAnalysis;
using NPR.CRC.Web.NPRSupportFile;
using Microsoft.Reporting.WebForms;
using System.Collections;

namespace NPR.CRC.Web.Controllers
{
    public enum ReportFormat
    {
        CSV,
        Image,
        Excel,
        PDF,
        Word
    }

    [Authorize(Roles = CRCUserRoles.Administrator + ", " + CRCUserRoles.CRCManager)]
    public class ReportsController : BaseController
    {
        public ActionResult Index()
        {
            return RedirectToAction("CarriageListByProgram");
            //return View();
            //GIT Test_X5_3
        }


        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", MessageId = "process")]
        public ActionResult StationsGridDataReport(long? stationId, long? repeaterStatusId, long? metroMarketId, string enabled, long? memberStatusId, long? dmaMarketId, string bandId, long? stateId, long? licenseeTypeId, long? affiliateId)
        {
            var dt = CRCDataAccess.SearchStations(stationId, repeaterStatusId, metroMarketId, enabled, memberStatusId, dmaMarketId, bandId, stateId, licenseeTypeId, affiliateId);
            
            //return InfJqGridData(dataTable, gridSettings);

            dt.Columns.RemoveAt(0);
            dt.Columns.RemoveAt(2);
            ConvertToXLSX(dt, "StationList", true, -1);
            

            return null;
            
        }


        #region StationDataReport

        public ActionResult StationData()
        {
            var viewModel = new StationDataModelViewModel();

            return View(viewModel);

        }
        [HttpPost]
        public ActionResult StationData(StationDataModelViewModel model)
        {

            string fileName = "AllStationsDump";
            DataTable table = CRCDataAccess.GetStationDataReport(model.StationEnabled, model.Band, model.RepeaterStatus);
            int totalRecords = table.Rows.Count;

            switch (model.ReportFormat)
            {
                case "PDF":
                    ConvertToPdfWithHeader(table, "ALL STATION DATA", fileName, string.Empty, totalRecords, 50, string.Empty);
                    // ConvertToPDF(grid, fileName);
                    break;
                case "Excel":
                    //ConvertToExcel(grid, fileName);
                    ConvertToXLSX(table, fileName, true, -1);
                    break;
                case "CSV":
                    ConvertToCSV(table, fileName, false);
                    break;
            }

            //return Json(true, JsonRequestBehavior.AllowGet);
            return null;
            //return View(model);
        }

        #endregion

        #region Repeater Station Report


        public ActionResult RepeaterStation()
        {
            var model = new RepeaterStationViewModel();

            return View(model);
        }
        [HttpPost]
        public ActionResult RepeaterStation(RepeaterStationViewModel model)
        {

            string fileName = "RepeaterStation";
            string StationEnabledStatus = model.StationEnabled == "Yes" ? "Y" : model.StationEnabled == "No" ? "N" : "";
            DataTable table = CRCDataAccess.GetRepeaterStationReport(StationEnabledStatus, model.Band);
            DataTable rTable = NPRReport.getCallLetters_Flagship(table);

            var grid = new GridView();

            grid.DataSource = rTable;
            grid.DataBind();

            switch (model.ReportFormat)
            {
                case "PDF":
                    ConvertToPDF(grid, fileName);
                    break;
                case "Excel":
                    //ConvertToExcel(grid, fileName);
                    ConvertToXLSX(table, fileName, true, -1);
                    break;
                case "CSV":
                    ConvertToCSV(rTable, fileName, true);
                    break;
            }

            // return Json(true, JsonRequestBehavior.AllowGet);
            return null;
        }
        #endregion

        #region Carriage List By Program Report

        public ActionResult CarriageListByProgram()
        {
            var viewModel = new CarriageListByProgramViewModel();
            viewModel.type = "Regular";
            return View(viewModel);

        }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1804:RemoveUnusedLocals", MessageId = "StationCount"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1804:RemoveUnusedLocals", MessageId = "tomonth"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1804:RemoveUnusedLocals", MessageId = "frommonth"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1804:RemoveUnusedLocals", MessageId = "table"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1804:RemoveUnusedLocals", MessageId = "RTable"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Maintainability", "CA1502:AvoidExcessiveComplexity"), HttpPost]
        public ActionResult CarriageListByProgram(CarriageListByProgramViewModel model)
        {
            int fromyear = model.YearsFrom;
            int toyear = model.YearsTo;
            string frommonth = model.MonthsFrom;
            string tomonth = model.MonthsTo;
            int frommon = 0;
            int tomon = 0;
            frommon = Int32.Parse(frommonth);
            tomon = Int32.Parse(tomonth);

            if (fromyear == toyear)
            {
                //if (frommon == tomon)
                //{
                //    ModelState.AddModelError("", "From Survery and To Survey should not be same.");
                //    return View(model);
                //}
                if (tomon < frommon)
                {
                    ModelState.AddModelError("", "Survey Month From must be earlier than Survey Month To.");
                    return View(model);
                }
            }
            if (fromyear > toyear)
            {

                ModelState.AddModelError("", "Starting Survey  must be earlier than ending Survey.");
                return View(model);
            }

            string fileName = "CarriageListByProgram";

            DataSet dataSet = CRCDataAccess.GetCarriageListByProgramReport(model.type, model.ProgramEnabled, model.ProgramID, model.MonthsFrom, model.YearsFrom, model.MonthsTo, model.YearsTo, model.ReportFormat, model.Band, model.StationEnabled, model.MemberStatus, model.StationId, model.City, model.StateId);

            if (dataSet != null)
            {
                string programName = string.Empty;
                int StationCount = 0;
                DataTable table = dataSet.Tables[0];
                table = FormatCarriageListByProgramReport(table);
                DataTable tblProgramName = dataSet.Tables[1];
                DataTable tblStationCount = dataSet.Tables[2];

                if (tblProgramName != null && tblProgramName.Rows.Count > 0)
                {
                    programName = tblProgramName.Rows[0].Field<string>(0);
                }

                if (tblStationCount != null && tblStationCount.Rows.Count > 0)
                {
                    StationCount = tblStationCount.Rows[0].Field<int>(0);
                }

                string monthFrom = new DateTime(model.YearsFrom, int.Parse(model.MonthsFrom), 1)
                                           .ToString("MMM", System.Globalization.CultureInfo.InvariantCulture);
                string monthTo = new DateTime(model.YearsTo, int.Parse(model.MonthsTo), 1)
                                    .ToString("MMM", System.Globalization.CultureInfo.InvariantCulture);

                var timeDuration = monthFrom + "-" + model.YearsFrom + " to " + monthTo + "-" + model.YearsTo + ",";


                switch (model.ReportFormat)
                {
                    case "PDF":

                        ConvertToPdfWithHeader(table, "CARRIAGE LIST", fileName, programName, StationCount, 50, timeDuration);

                        break;
                    case "Excel":

                        ConvertToXLSXCarriageByProgram(table, fileName, true, 8, programName, timeDuration);
                        break;
                    case "CSV":
                        ConvertToCSV(table, fileName, true);
                        break;
                }
            }

            //return Json(true, JsonRequestBehavior.AllowGet);
            return null;
            //return View(model);

        }

        /*
        public ActionResult ShowProgramAsType(string ProgramType)
        {

            DataTable dtPrograms=null;
            switch (ProgramType)
            {
                case "NPR Newscasts":

                    dtPrograms = CRCDataAccess.GetNPRNewscastProgram();
                    break;
                case "Regular":

                    dtPrograms = CRCDataAccess.GetRegularProgram();
                    break; 
            }
                    
            return Json(
                                dtPrograms
                                .AsEnumerable()
                                .Select(row => row["ProgramName"].ToString())
                                .OrderBy(s => s), JsonRequestBehavior.AllowGet);
          }*/

        public ActionResult ShowStationList(string Band, string StationEnabled, string MemberStatus)
        {
            //  DataTable dtStation = null;
            Console.WriteLine(Band);
            Console.WriteLine(StationEnabled);
            Console.WriteLine(MemberStatus);


            if (StationEnabled == "Yes")
            {
                StationEnabled = "Y";

            }
            else if (StationEnabled == "No")
            {
                StationEnabled = "N";
            }
            else
            {
                StationEnabled = "";
            }

            if (string.IsNullOrEmpty(MemberStatus))
            {
                MemberStatus = "";
            }
            using (DataTable dtStation = CRCDataAccess.GetStationList(Band, StationEnabled, MemberStatus))
            {
                return Json(dtStation
                            .AsEnumerable()
                             .Select(row => row["Station"].ToString())
                             .OrderBy(s => s), JsonRequestBehavior.AllowGet);
            }

        }


		public ActionResult ShowStationListLILO(string Band, string StationEnabled, string MemberStatus)
        {
            //  DataTable dtStation = null;
            Console.WriteLine(Band);
            Console.WriteLine(StationEnabled);
            Console.WriteLine(MemberStatus);


            if (StationEnabled == "Yes")
            {
                StationEnabled = "Y";

            }
            else if (StationEnabled == "No")
            {
                StationEnabled = "N";
            }
            else
            {
                StationEnabled = "";
            }

            if (string.IsNullOrEmpty(MemberStatus))
            {
                MemberStatus = "";
            }
            using (DataTable dtStation = CRCDataAccess.GetStationList_LILO(Band, StationEnabled, MemberStatus))
            {
				//return Json(dtStation
				//			.AsEnumerable()
				//			 .Select(row => row["Station"].ToString())
				//			 .OrderBy(s => s), JsonRequestBehavior.AllowGet);


				var searchResults =
                    from DataRow dr in dtStation.Rows
                    select new
                    {
                        value = dr["StationId"],
                        label = dr["CallLetters"]
                    };

                return Json(searchResults, JsonRequestBehavior.AllowGet);
            }

        }


		public ActionResult ShowProgramList(string enabled)
        {
            
            using (DataTable dtProgram = CRCDataAccess.GetProgramLookup_ED(enabled))
            {
				return Json(dtProgram
							.AsEnumerable()
                             .Select(row => row["ProgramName"].ToString())
							 , JsonRequestBehavior.AllowGet 
							 );
                             //.OrderBy(s => s), JsonRequestBehavior.AllowGet);
            }

        }


        #endregion

        #region Station Notes Report

        public ActionResult StationNotes()
        {
            var viewModel = new StationNotesViewModel();
            return View(viewModel);
        }

        public ActionResult StationSearch(string term)
        {
            using (var dt = CRCDataAccess.StationSearch(term))
            {
                var searchResults =
                    from DataRow dr in dt.Rows
                    select new
                    {
                        value = dr["StationId"],
                        label = dr["CallLetters"]
                    };

                return Json(searchResults, JsonRequestBehavior.AllowGet);
            }
        }

        public ActionResult StationActiveSearch(string term)
        {
            using (var dt = CRCDataAccess.StationActiveSearch(term))
            {
                var searchResults =
                    from DataRow dr in dt.Rows
                    select new
                    {
                        value = dr["StationId"],
                        label = dr["CallLetters"]
                    };

                return Json(searchResults, JsonRequestBehavior.AllowGet);
            }
        }

        public ActionResult StationNotesReportGridData(GridSettings gridSettings, long? stationId, string keyword, DateTime? lastUpdatedFromDate, DateTime? lastUpdatedToDate, string noteStatus)
        {
            var deletedInd = noteStatus.Equals("Y", StringComparison.OrdinalIgnoreCase) ? "N" : "Y";
            using (var dataTable = CRCDataAccess.GetStationNotesReport(stationId, keyword, lastUpdatedFromDate, lastUpdatedToDate, deletedInd))
            {
                return InfJqGridData(dataTable, gridSettings);
            }
        }

        #endregion

        #region Grid Data Report

        [Authorize(Roles = CRCUserRoles.Administrator)]
        public ActionResult GridData()
        {
            var viewModel = new GridDataViewModel();
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult GridData(GridDataViewModel model)
        {
            string fileName = "GridDataReport";
            DataTable dataTable = CRCDataAccess.GetGridDataReport(model.StationType, model.StationEnabled, model.RepeaterStatus, model.ProgramType, model.Month, model.Years);
            //dataTable = GridReportFormat(dataTable);
            var grid = new GridView();

            grid.DataSource = dataTable;
            grid.DataBind();

            switch (model.Format)
            {
                case "PDF":
                    ConvertToPDF(grid, fileName);
                    break;
                case "Excel":
                    ConvertToXLSX(dataTable, fileName, false, -1);
                    //ConvertToExcel(grid, fileName);
                    break;
                case "CSV":
                    ConvertToCSV(dataTable, fileName, false);
                    break;
                case "Txt":
                    CustomGridDumpTxt(dataTable, fileName, false);
                    break;


            }

            return null;
            //return Json(true, JsonRequestBehavior.AllowGet);
            //return View(model);
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1822:MarkMembersAsStatic"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1804:RemoveUnusedLocals", MessageId = "col"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1804:RemoveUnusedLocals", MessageId = "row")]
        public DataTable GridReportFormat(DataTable dt)
        {
            foreach (DataColumn co in dt.Columns)
                co.ReadOnly = false;
            int r = 0;
            int c = 0;
            foreach (DataRow row in dt.Rows)
            {
                foreach (DataColumn col in dt.Columns)
                {
                    dt.Rows[r][c] = dt.Rows[r][c].ToString().Replace('[', ' ');
                    c++;
                }
                c = 0;
            }

            return dt;

        }

        #endregion

        #region Program Line Up Report

        public ActionResult ProgramLineUp()
        {
            var viewModel = new ProgramLineUpViewModel();
            return View(viewModel);
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1804:RemoveUnusedLocals", MessageId = "monthSpan"), HttpPost]
        public ActionResult ProgramLineUp(ProgramLineUpViewModel viewModel /*long programId, string season, int year, string band, string stationEnabledInd, long? memberStatusId, string format*/)
        {
            string monthSpan = "";
            switch (viewModel.Season)
            {
                case "Winter":
                    monthSpan = "1, 2, 3";
                    break;
                case "Spring":
                    monthSpan = "4, 5, 6";
                    break;
                case "Summer":
                    monthSpan = "7, 8, 9";
                    break;
                case "Fall":
                    monthSpan = "10, 11, 12";
                    break;
            }

            string fileName = "ProgramLineUpReport";

            DataTable dataTable = CRCDataAccess.GetProgramLineUpReport(Int64.Parse(viewModel.ProgramID), viewModel.Season, viewModel.Year, viewModel.BandsString, viewModel.StationEnabled, viewModel.MemberStatusId.HasValue ? viewModel.MemberStatusId.Value : default(long?));

            string endMonth = "3";
            if (viewModel.Season == "4, 5, 6")
                endMonth = "6";
            else if (viewModel.Season == "7, 8, 9")
                endMonth = "9";
            else if (viewModel.Season == "10, 11, 12")
                endMonth = "12";

            dataTable = FormatProgramLineUpReport(dataTable, endMonth);
            var grid = new GridView();

            grid.DataSource = dataTable;
            grid.DataBind();

            switch (viewModel.Format)
            {
                case "PDF":
                    ConvertToPDF(grid, fileName);
                    break;
                case "Excel":
                    //ConvertToExcel(grid, fileName);
                    ConvertToXLSX(dataTable, fileName, false, -1);
                    break;
                case "CSV":
                    ConvertToCSV(dataTable, fileName, false);
                    break;
            }
            //return Json(true, JsonRequestBehavior.AllowGet);
            return null;
        }

        #endregion

        #region Format Calculation Report

        public ActionResult FormatCalculation()
        {
            var model = new FormatCalculationViewModel();

            return View(model);
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Maintainability", "CA1502:AvoidExcessiveComplexity"), HttpPost]
        public ActionResult FormatCalculation(FormatCalculationViewModel model)
        {
            string sHours = model.StartHours;
            string eHours = model.EndingHours;

            if (model.Duration == "Custom" && String.IsNullOrEmpty(sHours) && String.IsNullOrEmpty(eHours))
            {
                ModelState.AddModelError("Station", "Start Hours and Ending Hours fields are required");
                //return View(model);
            }
            else if (model.Duration == "Custom" && String.IsNullOrEmpty(sHours) && (!String.IsNullOrEmpty(eHours)))
            {
                ModelState.AddModelError("Station", "Start Hours field is required");
                //return View(model);
            }
            else if (model.Duration == "Custom" && (!String.IsNullOrEmpty(sHours)) && String.IsNullOrEmpty(eHours))
            {
                ModelState.AddModelError("Station", "End Hour field is required");
                //return View(model);
            }
            else
            {
                ModelState["Station"].Errors.Clear();
            }


            if (model.Duration == "Custom" && (model.DaySun != true && model.DayMon != true && model.DayTue != true && model.DayWed != true && model.DayThu != true && model.DayFri != true && model.DaySat != true))
            {
                ModelState.AddModelError("", "Selection of at least one day is required.");
            }
            // double sh;
            //double eh;
            if ((!String.IsNullOrEmpty(sHours)) && (!String.IsNullOrEmpty(eHours)))
            {
                TimeSpan duration = DateTime.Parse(eHours).Subtract(DateTime.Parse(sHours));
                double d = duration.TotalMinutes;

                if (model.Duration == "Custom" && d <= 0 && (!sHours.Equals("00:00:00", StringComparison.OrdinalIgnoreCase) && !eHours.Equals("00:00:00", StringComparison.OrdinalIgnoreCase)))
                {
                    ModelState.AddModelError("Station", "Start Hour must be earlier than End Hour.");
                    //  return View(model);
                }
            }
            if (model.Station == "One")
            {
                if (String.IsNullOrEmpty(model.StationsList))
                {
                    ModelState.AddModelError("", "Station selection is required.");
                }
            }

            if (ModelState.IsValid)
            {
                string RSunDay = "Y", RMonDay = "Y", RTuesDay = "Y", RWednesDay = "Y", RThursDay = "Y", RFriDay = "Y", RSaturDay = "Y";
                string RStartHours = null, REndHours = null;

                switch (model.Duration)
                {
                    case "18 hours":
                        RStartHours = "6:00:00";
                        REndHours = "23:59:59";
                        break;

                    case "24 hours":
                        RStartHours = "00:00:00";
                        REndHours = "23:59:59";
                        break;

                    case "Custom":
                        RStartHours = model.StartHours;
                        REndHours = model.EndingHours == "00:00:00" ? "23:59:59" : model.EndingHours;
                        RSunDay = model.DaySun ? "Y" : "N";
                        RMonDay = model.DayMon ? "Y" : "N";
                        RTuesDay = model.DayTue ? "Y" : "N";
                        RWednesDay = model.DayWed ? "Y" : "N";
                        RThursDay = model.DayThu ? "Y" : "N";
                        RFriDay = model.DayFri ? "Y" : "N";
                        RSaturDay = model.DaySat ? "Y" : "N";
                        break;
                }

                if (model.MemberStatus == "All")
                {
                    model.MemberStatus = "";
                }

                string fileName = "FormatCalculationReport";

                DataTable dataTable = CRCDataAccess.GetFormatCalculationReport(RStartHours, REndHours, RSunDay, RMonDay, RTuesDay, RWednesDay, RThursDay, RFriDay, RSaturDay, model.Month, model.Year, Convert.ToInt32(model.StationStatus), model.MemberStatus, model.StationsList, model.Band);

                dataTable = FormatCalculationsReportFormat(dataTable);
                var grid = new GridView();

                //if (dataTable != null && dataTable.Rows.Count < 1)
                //{
                //    DataRow emptyRow = dataTable.NewRow();

                //    dataTable.Rows.InsertAt(emptyRow, 0);
                //    dataTable.AcceptChanges();

                //    grid.DataSource = dataTable;
                //    grid.DataBind();
                //    GridViewRow row = new GridViewRow(0, 0, DataControlRowType.Header, DataControlRowState.Normal);
                //    TableHeaderCell cell = new TableHeaderCell();
                //    cell.Text = "There is no record to display.";
                //    cell.ColumnSpan = 15;
                //    cell.HorizontalAlign = HorizontalAlign.Center;
                //    //row.Controls.Add(cell);
                //    row.Cells.AddAt(0, cell);
                //    grid.FooterRow.Parent.Controls.Add(row);
                //}
                //else
                //{
                //    grid.DataSource = dataTable;
                //    grid.DataBind();
                //}

                grid.DataSource = dataTable;
                grid.DataBind();

                switch (model.FormatType)
                {
                    case "PDF":
                        ConvertToPDF(grid, fileName);
                        break;
                    case "Excel":
                        //ConvertToExcel(grid, fileName);
                        ConvertToXLSXFormatCalculations(dataTable, fileName, true, -1);
                        break;
                    case "CSV":
                        //ConvertToCSV(dataTable, fileName, true);
                        ConvertFormatCalculationsToCSV(dataTable, fileName, true);
                        break;
                }
                return null;
                //return Json(true, JsonRequestBehavior.AllowGet);
            }
            else
            {
                return View(model);
            }
        }

        #endregion

        #region Station Users Report

        [Authorize(Roles = CRCUserRoles.Administrator)]
        public ActionResult StationUsers()
        {
            var viewModel = new StationUsersViewModel();
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult StationUsers(StationUsersViewModel viewModel)
        {
            string fileName = "StationUsersReport";
            DataTable dataTable = CRCDataAccess.GetStationUsersReport(viewModel.UserPermission, viewModel.Band, viewModel.RepeaterStatus);

            var grid = new GridView();

            grid.DataSource = dataTable;
            grid.DataBind();

            switch (viewModel.Format)
            {
                case "PDF":
                    ConvertToPDF(grid, fileName);
                    break;
                case "Excel":
                    //ConvertToExcel(grid, fileName);
                    ConvertToXLSX(dataTable, fileName, true, -1);
                    break;
                case "CSV":
                    ConvertToCSV(dataTable, fileName, true);
                    break;
            }

            //return Json(true, JsonRequestBehavior.AllowGet);
            return null;
        }

        #endregion

        #region Participating Station Report

        public ActionResult ParticipatingStation()
        {
            var viewModel = new ParticipatingStationViewModel();
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult ParticipatingStation(ParticipatingStationViewModel viewModel)
        {
            int fromyear = viewModel.CurrentYear;
            int toyear = viewModel.PastYear;
            string frommonth = viewModel.CurrentSeason;
            string tomonth = viewModel.PastSeason;
            int frommon = 0;
            int tomon = 0;

            if (frommonth == "Winter")
            { frommon = 1; }
            else if (frommonth == "Spring")
            { frommon = 2; }
            else if (frommonth == "Summer")
            { frommon = 3; }
            else if (frommonth == "Fall")
            { frommon = 4; }

            if (tomonth == "Winter")
            { tomon = 1; }
            else if (tomonth == "Spring")
            { tomon = 2; }
            else if (tomonth == "Summer")
            { tomon = 3; }
            else if (tomonth == "Fall")
            { tomon = 4; }

            if (fromyear == toyear)
            {
                if (frommon == tomon)
                {
                    ModelState.AddModelError("", "Current Survery and Past Survey should not be same.");
                    return View(viewModel);
                }
                else if (frommon < tomon)
                {
                    ModelState.AddModelError("", "Current Survey Season must be later than Past Survey Season.");
                    return View(viewModel);
                }
            }
            if (fromyear < toyear)
            {

                ModelState.AddModelError("", "Current Survey Season must be later than Past Survey Season.");
                return View(viewModel);
            }

            DataTable dataTable = CRCDataAccess.GetParticipatingStationReport(viewModel.CurrentSeason, viewModel.CurrentYear, viewModel.PastSeason, viewModel.PastYear, viewModel.Band, viewModel.Format);


            var grid = new GridView();

            grid.DataSource = dataTable;
            grid.DataBind();

            StringWriter sw = new StringWriter();
            switch (viewModel.Format)
            {
                case "PDF":

                    LocalReport localReport = new LocalReport();
                    localReport.ReportPath = Server.MapPath("~/Content/Reports/ParticipatingStation.rdl");
                    ReportDataSource reportDataSource = new ReportDataSource("DataSet1", dataTable);

                    localReport.DataSources.Add(reportDataSource);
                    string reportType = "PDF";
                    string mimeType = "application/pdf";
                    string encoding;
                    string fileNameExtension;

                    string deviceInfo =
        "<DeviceInfo>" +
        "  <OutputFormat>PDF</OutputFormat>" +
        "  <PageWidth>11in</PageWidth>" +
        "  <MarginTop>0.5in</MarginTop>" +
        "  <MarginLeft>1in</MarginLeft>" +
        "  <MarginRight>1in</MarginRight>" +
        "  <MarginBottom>0.5in</MarginBottom>" +
        "</DeviceInfo>";

                    Warning[] warnings;
                    string[] streams;
                    byte[] renderedBytes;

                    //Render the report
                    renderedBytes = localReport.Render(
                        reportType,
                        deviceInfo,
                        out mimeType,
                        out encoding,
                        out fileNameExtension,
                        out streams,
                        out warnings);

                    return File(renderedBytes, System.Net.Mime.MediaTypeNames.Application.Pdf, "ParticipatingStation.pdf");

                case "EXCEL":
                    Response.ClearContent();
                    Response.Buffer = true;
                    Response.AddHeader("content-disposition", "attachment; filename=ParticipatingStationReport.xls");
                    Response.ContentType = "application/excel";

                    Response.Charset = "";
                    HtmlTextWriter htw = new HtmlTextWriter(sw);

                    grid.RenderControl(htw);

                    Response.Output.Write(sw.ToString());
                    Response.Flush();
                    Response.End();
                    break;
                case "CSV":
                    Response.Clear();
                    Response.Buffer = true;
                    Response.AddHeader("content-disposition", "attachment;filename=ParticipatingStationReport.csv");
                    Response.Charset = "";
                    Response.ContentType = "application/text";

                    StringBuilder sb = new StringBuilder();
                    //Append column Header
                    for (int k = 0; k < dataTable.Columns.Count; k++)
                    {
                        //add separator
                        sb.Append(dataTable.Columns[k].ToString().Replace(",", ";") + ',');
                    }
                    //append new line
                    sb.Append("\r\n");
                    for (int i = 0; i < dataTable.Rows.Count; i++)
                    {
                        for (int k = 0; k < dataTable.Columns.Count; k++)
                        {
                            //add separator
                            sb.Append(dataTable.Rows[i][k].ToString().Replace(",", ";") + ',');
                        }
                        //append new line
                        sb.Append("\r\n");
                    }
                    Response.Output.Write(sb.ToString());
                    Response.Flush();
                    Response.End();
                    break;
            }

            return Json(true, JsonRequestBehavior.AllowGet);
        }

        #endregion

        #region Program Station Report

        public ActionResult ProgramStation()
        {
            var viewModel = new ProgramStationViewModel();
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult ProgramStation(ProgramStationViewModel viewModel)
        {
            int fromyear = viewModel.CurrentYear;
            int toyear = viewModel.PastYear;
            string frommonth = viewModel.CurrentSeason;
            string tomonth = viewModel.PastSeason;
            int frommon = 0;
            int tomon = 0;

            if (frommonth == "Winter")
            { frommon = 1; }
            else if (frommonth == "Spring")
            { frommon = 2; }
            else if (frommonth == "Summer")
            { frommon = 3; }
            else if (frommonth == "Fall")
            { frommon = 4; }

            if (tomonth == "Winter")
            { tomon = 1; }
            else if (tomonth == "Spring")
            { tomon = 2; }
            else if (tomonth == "Summer")
            { tomon = 3; }
            else if (tomonth == "Fall")
            { tomon = 4; }

            if (fromyear == toyear)
            {
                if (frommon == tomon)
                {
                    ModelState.AddModelError("", "Current Survey and Past Survey should not be same.");
                    return View(viewModel);
                }
                else if (frommon < tomon)
                {
                    ModelState.AddModelError("", "Current Survey Season must be later than Past Survey Season.");
                    return View(viewModel);
                }
            }
            if (fromyear < toyear)
            {

                ModelState.AddModelError("", "Current Survey Season must be later than Past Survey Season.");
                return View(viewModel);
            }

            DataTable dataTable = CRCDataAccess.GetProgramStationReport(viewModel.CurrentSeason, viewModel.CurrentYear, viewModel.PastSeason, viewModel.PastYear, viewModel.Band, viewModel.Format);


            var grid = new GridView();

            grid.DataSource = dataTable;
            grid.DataBind();

            StringWriter sw = new StringWriter();
            switch (viewModel.Format)
            {
                case "PDF":
                    LocalReport localReport = new LocalReport();
                    localReport.ReportPath = Server.MapPath("~/Content/Reports/ProgramStation.rdl");
                    ReportDataSource reportDataSource = new ReportDataSource("DataSet1", dataTable);

                    localReport.DataSources.Add(reportDataSource);
                    string reportType = "PDF";
                    string mimeType = "application/pdf";
                    string encoding;
                    string fileNameExtension;

                    string deviceInfo =
        "<DeviceInfo>" +
        "  <OutputFormat>PDF</OutputFormat>" +
        "  <PageWidth>9.5in</PageWidth>" +
        "  <MarginTop>0.5in</MarginTop>" +
        "  <MarginLeft>1in</MarginLeft>" +
        "  <MarginRight>1in</MarginRight>" +
        "  <MarginBottom>0.5in</MarginBottom>" +
        "</DeviceInfo>";

                    Warning[] warnings;
                    string[] streams;
                    byte[] renderedBytes;

                    //Render the report
                    renderedBytes = localReport.Render(
                        reportType,
                        deviceInfo,
                        out mimeType,
                        out encoding,
                        out fileNameExtension,
                        out streams,
                        out warnings);

                    return File(renderedBytes, System.Net.Mime.MediaTypeNames.Application.Pdf, "ProgramStation.pdf");
                case "EXCEL":
                    Response.ClearContent();
                    Response.Buffer = true;
                    Response.AddHeader("content-disposition", "attachment; filename=ProgramStationReport.xls");
                    Response.ContentType = "application/excel";

                    Response.Charset = "";
                    HtmlTextWriter htw = new HtmlTextWriter(sw);

                    grid.RenderControl(htw);

                    Response.Output.Write(sw.ToString());
                    Response.Flush();
                    Response.End();
                    break;
                case "CSV":
                    Response.Clear();
                    Response.Buffer = true;
                    Response.AddHeader("content-disposition", "attachment;filename=ProgramStationReport.csv");
                    Response.Charset = "";
                    Response.ContentType = "application/text";

                    StringBuilder sb = new StringBuilder();
                    //Append column Header
                    for (int k = 0; k < dataTable.Columns.Count; k++)
                    {
                        //add separator
                        sb.Append(dataTable.Columns[k].ToString().Replace(",", ";") + ',');
                    }
                    //append new line
                    sb.Append("\r\n");
                    for (int i = 0; i < dataTable.Rows.Count; i++)
                    {
                        for (int k = 0; k < dataTable.Columns.Count; k++)
                        {
                            //add separator
                            sb.Append(dataTable.Rows[i][k].ToString().Replace(",", ";") + ',');
                        }
                        //append new line
                        sb.Append("\r\n");
                    }
                    Response.Output.Write(sb.ToString());
                    Response.Flush();
                    Response.End();
                    break;
            }

            return Json(true, JsonRequestBehavior.AllowGet);
        }

        #endregion

        #region Carriage Workbook

        public ActionResult CarriageWorkbook()
        {
            var viewModel = new CarriageWorkbookViewModel();
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult CarriageWorkbook(CarriageWorkbookViewModel viewModel)
        {
            string fileName = "CarriageWorkbookReport";

            DataTable dataTable = CRCDataAccess.GetCarriageWorkbookReport(viewModel.CarriageTypeId, viewModel.Season, viewModel.Years, viewModel.Band, viewModel.StationEnabled, viewModel.MemberStatusId.HasValue ? viewModel.MemberStatusId : default(long?));

            //Console.Write(dataTable.Rows.Count + ' ' + fileName);

            var grid = new GridView();

            grid.DataSource = dataTable;
            grid.DataBind();

            string season = "";
            switch (viewModel.Season)
            {
                case "1, 2, 3":
                    season = "Winter";
                    break;
                case "4, 5, 6":
                    season = "Spring";
                    break;
                case "7, 8, 9":
                    season = "Summer";
                    break;
                case "10, 11, 12":
                    season = "Fall";
                    break;
            }

            string footerDate = season + " " + viewModel.Years;

            switch (viewModel.Format)
            {
                case "PDF":
                    ConvertToPDF(grid, fileName);
                    break;
                case "Excel":
                    //ConvertToExcel(grid, fileName);
                    ConvertToXLSXCarriageWorkbook(fileName, dataTable, footerDate);
                    break;
                case "CSV":
                    ConvertToCSV(dataTable, fileName, true);
                    break;
            }
            //return Json(true, JsonRequestBehavior.AllowGet);
            return null;
            //return View(viewModel);
        }

        #endregion

        #region Carriage List By Station Report

        public ActionResult CarriageListByStation()
        {
            var viewModel = new CarriageListByStationViewModel();
            return View(viewModel);
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Maintainability", "CA1502:AvoidExcessiveComplexity"), HttpPost]
        public ActionResult CarriageListByStation(CarriageListByStationViewModel viewModel)
        {
            int fromyear = viewModel.YearsFrom;
            int toyear = viewModel.YearsTo;
            string frommonth = viewModel.MonthsFrom;
            string tomonth = viewModel.MonthsTo;
            int frommon = 0;
            int tomon = 0;

            if (frommonth == "1")
            { frommon = 1; }
            else if (frommonth == "2")
            { frommon = 2; }
            else if (frommonth == "3")
            { frommon = 3; }
            else if (frommonth == "4")
            { frommon = 4; }
            else if (frommonth == "5")
            { frommon = 5; }
            else if (frommonth == "6")
            { frommon = 6; }
            else if (frommonth == "7")
            { frommon = 7; }
            else if (frommonth == "8")
            { frommon = 8; }
            else if (frommonth == "9")
            { frommon = 9; }
            else if (frommonth == "10")
            { frommon = 10; }
            else if (frommonth == "11")
            { frommon = 11; }
            else if (frommonth == "12")
            { frommon = 12; }

            if (tomonth == "1")
            { tomon = 1; }
            else if (tomonth == "2")
            { tomon = 2; }
            else if (tomonth == "3")
            { tomon = 3; }
            else if (tomonth == "4")
            { tomon = 4; }
            else if (tomonth == "5")
            { tomon = 5; }
            else if (tomonth == "6")
            { tomon = 6; }
            else if (tomonth == "7")
            { tomon = 7; }
            else if (tomonth == "8")
            { tomon = 8; }
            else if (tomonth == "9")
            { tomon = 9; }
            else if (tomonth == "10")
            { tomon = 10; }
            else if (tomonth == "11")
            { tomon = 11; }
            else if (tomonth == "12")
            { tomon = 12; }


            if (fromyear == toyear)
            {
                if (frommon == tomon)
                {
                    ModelState.AddModelError("", "From Survery and To Survey should not be same.");
                    return View(viewModel);
                }
                else if (frommon > tomon)
                {
                    ModelState.AddModelError("", "Survey Month From must be earlier than Survey Month To.");
                    return View(viewModel);
                }
            }
            if (fromyear > toyear)
            {

                ModelState.AddModelError("", "Starting Survey  must be earlier than ending Survey.");
                return View(viewModel);
            }

            DataTable dataTable = CRCDataAccess.GetCarriageListByStationReport(viewModel.type, viewModel.Station, viewModel.Band, viewModel.StationStatus, viewModel.MemberStatus, viewModel.MonthsFrom, viewModel.YearsFrom, viewModel.MonthsTo, viewModel.YearsTo);


            var grid = new GridView();

            grid.DataSource = dataTable;
            grid.DataBind();

            StringWriter sw = new StringWriter();
            switch (viewModel.Format)
            {
                case "PDF":

                    LocalReport localReport = new LocalReport();
                    localReport.ReportPath = Server.MapPath("~/Content/Reports/CarriageListByStation.rdl");
                    ReportDataSource reportDataSource = new ReportDataSource("DataSet1", dataTable);

                    localReport.DataSources.Add(reportDataSource);
                    string reportType = "PDF";
                    string mimeType = "application/pdf";
                    string encoding;
                    string fileNameExtension;

                    string deviceInfo =
        "<DeviceInfo>" +
        "  <OutputFormat>PDF</OutputFormat>" +
        "  <PageWidth>12.7in</PageWidth>" +
        "  <MarginTop>0.5in</MarginTop>" +
        "  <MarginLeft>1in</MarginLeft>" +
        "  <MarginRight>1in</MarginRight>" +
        "  <MarginBottom>0.5in</MarginBottom>" +
        "</DeviceInfo>";

                    Warning[] warnings;
                    string[] streams;
                    byte[] renderedBytes;

                    //Render the report
                    renderedBytes = localReport.Render(
                        reportType,
                        deviceInfo,
                        out mimeType,
                        out encoding,
                        out fileNameExtension,
                        out streams,
                        out warnings);
                    //Response.AddHeader("content-disposition", "attachment; filename=CarriageListByStation.pdf");
                    return File(renderedBytes, System.Net.Mime.MediaTypeNames.Application.Pdf, "CarriageListByStation.pdf");

                // break;
                case "EXCEL":

                    Response.ClearContent();
                    Response.Buffer = true;
                    Response.AddHeader("content-disposition", "attachment; filename=CarriageListByStation.xls");
                    Response.ContentType = "application/excel";

                    Response.Charset = "";
                    HtmlTextWriter htw = new HtmlTextWriter(sw);

                    grid.RenderControl(htw);

                    Response.Output.Write(sw.ToString());
                    Response.Flush();
                    Response.End();
                    break;
                case "CSV":
                    Response.Clear();
                    Response.Buffer = true;
                    Response.AddHeader("content-disposition", "attachment;filename=CarriageListByStation.csv");
                    Response.Charset = "";
                    Response.ContentType = "application/text";

                    StringBuilder sb = new StringBuilder();
                    //Append column Header
                    for (int k = 0; k < dataTable.Columns.Count; k++)
                    {
                        //add separator
                        sb.Append(dataTable.Columns[k].ToString().Replace(",", ";") + ',');
                    }
                    //append new line
                    sb.Append("\r\n");
                    for (int i = 0; i < dataTable.Rows.Count; i++)
                    {
                        for (int k = 0; k < dataTable.Columns.Count; k++)
                        {
                            //add separator
                            sb.Append(dataTable.Rows[i][k].ToString().Replace(",", ";") + ',');
                        }
                        //append new line
                        sb.Append("\r\n");
                    }
                    Response.Output.Write(sb.ToString());
                    Response.Flush();
                    Response.End();
                    break;
            }

            return Json(true, JsonRequestBehavior.AllowGet);
        }

        #endregion

        #region Add/Drop Program Report

        public ActionResult AddDropProgram()
        {
            var model = new AddDropProgramViewModel();
            return View(model);
        }

        [HttpPost]
        public ActionResult AddDropProgram(AddDropProgramViewModel viewModel)
        {
            int fromyear = viewModel.SurveySeasonFromYear;
            int toyear = viewModel.SurveySeasonToYear;
            string frommonth = viewModel.SurveySeasonFromMonth;
            string tomonth = viewModel.SurveySeasonToMonth;
            int frommon = 0;
            int tomon = 0;

            if (frommonth == "Winter")
            { frommon = 1; }
            else if (frommonth == "Spring")
            { frommon = 2; }
            else if (frommonth == "Summer")
            { frommon = 3; }
            else if (frommonth == "Fall")
            { frommon = 4; }

            if (tomonth == "Winter")
            { tomon = 1; }
            else if (tomonth == "Spring")
            { tomon = 2; }
            else if (tomonth == "Summer")
            { tomon = 3; }
            else if (tomonth == "Fall")
            { tomon = 4; }

            if (fromyear == toyear)
            {
                if (frommon == tomon)
                {
                    ModelState.AddModelError("", "From Survery and To Survey should not be same.");
                    return View(viewModel);
                }
                else if (frommon > tomon)
                {
                    ModelState.AddModelError("", "Survey Season From must be earlier than Survey Season To.");
                    return View(viewModel);
                }
            }
            if (fromyear > toyear)
            {

                ModelState.AddModelError("", "Survey Season From must be earlier than Survey Season To.");
                return View(viewModel);
            }
            DataTable dataTable = CRCDataAccess.GetAddDropProgramReport(viewModel.StationType, viewModel.StationStatus, viewModel.RepeaterStatus, viewModel.ProgramName, viewModel.SurveySeasonFromMonth, viewModel.SurveySeasonFromYear, viewModel.SurveySeasonToMonth, viewModel.SurveySeasonToYear, viewModel.Format);


            var grid = new GridView();

            grid.DataSource = dataTable;
            grid.DataBind();

            StringWriter sw = new StringWriter();
            switch (viewModel.Format)
            {
                case "PDF":

                    LocalReport localReport = new LocalReport();
                    localReport.ReportPath = Server.MapPath("~/Content/Reports/AddDropProgram.rdl");
                    ReportDataSource reportDataSource = new ReportDataSource("DataSet1", dataTable);

                    localReport.DataSources.Add(reportDataSource);
                    string reportType = "PDF";
                    string mimeType = "application/pdf";
                    string encoding;
                    string fileNameExtension;

                    string deviceInfo =
        "<DeviceInfo>" +
        "  <OutputFormat>PDF</OutputFormat>" +
        "  <PageWidth>15in</PageWidth>" +
                        //"  <MarginTop>0.5in</MarginTop>" +
                        //"  <MarginLeft>1in</MarginLeft>" +
                        //"  <MarginRight>1in</MarginRight>" +
                        //"  <MarginBottom>0.5in</MarginBottom>" +
        "</DeviceInfo>";

                    Warning[] warnings;
                    string[] streams;
                    byte[] renderedBytes;

                    //Render the report
                    renderedBytes = localReport.Render(
                        reportType,
                        deviceInfo,
                        out mimeType,
                        out encoding,
                        out fileNameExtension,
                        out streams,
                        out warnings);

                    return File(renderedBytes, System.Net.Mime.MediaTypeNames.Application.Pdf, "AddDropProgramReport.pdf");

                case "Excel":
                    Response.ClearContent();
                    Response.Buffer = true;
                    Response.AddHeader("content-disposition", "attachment; filename=AddDropProgramReport.xls");
                    Response.ContentType = "application/excel";

                    Response.Charset = "";
                    HtmlTextWriter htw = new HtmlTextWriter(sw);

                    grid.RenderControl(htw);

                    Response.Output.Write(sw.ToString());
                    Response.Flush();
                    Response.End();
                    break;
                case "CSV":
                    Response.Clear();
                    Response.Buffer = true;
                    Response.AddHeader("content-disposition", "attachment;filename=AddDropProgramReport.csv");
                    Response.Charset = "";
                    Response.ContentType = "application/text";

                    StringBuilder sb = new StringBuilder();
                    //Append column Header
                    for (int k = 0; k < dataTable.Columns.Count; k++)
                    {
                        //add separator
                        sb.Append(dataTable.Columns[k].ToString().Replace(",", ";") + ',');

                    }
                    //append new line
                    sb.Append("\r\n");
                    for (int i = 0; i < dataTable.Rows.Count; i++)
                    {
                        for (int k = 0; k < dataTable.Columns.Count; k++)
                        {
                            //add separator
                            sb.Append(dataTable.Rows[i][k].ToString().Replace(",", ";") + ',');
                        }
                        //append new line
                        sb.Append("\r\n");
                    }
                    Response.Output.Write(sb.ToString());
                    Response.Flush();
                    Response.End();
                    break;
            }

            return Json(true, JsonRequestBehavior.AllowGet);

        }

        #endregion

        #region Private Methods

        private void ConvertToPDF(GridView grid, string fileName)
        {

            StringWriter sw = new StringWriter();
            Response.ContentType = "application/pdf";
            Response.AddHeader("content-disposition", "attachment;filename=" + fileName + ".pdf");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            HtmlTextWriter hw = new HtmlTextWriter(sw);
            grid.RenderControl(hw);

            StringReader sr = new StringReader(sw.ToString());
            Document pdfDoc = new Document(PageSize.A4, 10f, 10f, 10f, 0f);
            HTMLWorker htmlparser = new HTMLWorker(pdfDoc);
            PdfWriter.GetInstance(pdfDoc, Response.OutputStream);

            pdfDoc.Open();
            htmlparser.Parse(sr);

            pdfDoc.Close();
            Response.Write(pdfDoc);
            Response.End();
        }

        private void ConvertToPdfWithHeader(DataTable dataTable, string reportTitle, string fileName, string programName, int totalRecord, int recordsPerPage, string timeDuration)
        {
            Response.ContentType = "application/pdf";
            Response.AddHeader("content-disposition", "attachment;filename=" + fileName + ".pdf");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);

            var totalColumns = dataTable.Columns.Count;
            var totalPages = (dataTable.Rows.Count / recordsPerPage) + 1;

            Font headerFont = FontFactory.GetFont("Arial", 9, iTextSharp.text.Font.NORMAL);
            Font contentFont = FontFactory.GetFont("Arial", 9, iTextSharp.text.Font.NORMAL);
            Font noRecordFont = FontFactory.GetFont("Arial", 15, iTextSharp.text.Font.BOLD);

            Document pdfDoc = new Document(PageSize.A4, 10f, 10f, 80f, 0f);

            // event assignment and calling
            PdfWriter writer = PdfWriter.GetInstance(pdfDoc, Response.OutputStream);

            iTextSharp.text.Image imageHeader = iTextSharp.text.Image.GetInstance(Request.MapPath(
                  "~/content/Images/logo.png"
                ));

            ITextPdfEvents objITextPdfEvents = new ITextPdfEvents()
            {
                ImageHeader = imageHeader,
                ReportTitle = reportTitle,
                ProgramName = programName,
               // TotalRecords = totalRecord,
                TotalPages = totalPages,
                CurrentPage = 1,
                TimeDuration = timeDuration
            };
            writer.PageEvent = objITextPdfEvents;


            PdfPTable reportTable = new PdfPTable(totalColumns);
            int[] columnWidths = new int[totalColumns];

            PdfPCell footerMessage = new PdfPCell();
            footerMessage = new PdfPCell(new Phrase("Total Stations ", headerFont));
            footerMessage.BackgroundColor = new iTextSharp.text.Color(204, 204, 204);

            PdfPCell footerTotal = new PdfPCell();
            footerTotal = new PdfPCell(new Phrase(totalRecord.ToString(), headerFont));
            footerTotal.BackgroundColor = new iTextSharp.text.Color(204, 204, 204);

            switch (fileName)
            {
                case "CarriageListByProgram":

                    columnWidths = new int[] { 20, 6, 25, 8, 20, 7, 7, 29, 12, 12 };
                    footerMessage.Colspan = 7;
                    footerTotal.Colspan = 3;

                    reportTable.WidthPercentage = 100;
                    break;
                case "AllStationsDump":

                    columnWidths = new int[] { 20, 6, 20, 8, 15, 9, 9 };
                    footerMessage.Colspan = 4;
                    footerTotal.Colspan = 3;

                    reportTable.WidthPercentage = 90;
                    break;
                default:
                    break;
            }

            reportTable.SetWidths(columnWidths);

            PdfPCell cell;

            pdfDoc.Open();
            pdfDoc.NewPage();

            if (dataTable.Rows.Count > 0)
            {

                foreach (DataColumn column in dataTable.Columns)
                {
                    cell = new PdfPCell(new Phrase(column.ColumnName, headerFont));
                    cell.BackgroundColor = new iTextSharp.text.Color(204, 204, 204);
                    reportTable.AddCell(cell);
                }

                for (int rowIndex = 0; rowIndex < dataTable.Rows.Count; rowIndex++)
                {
                    objITextPdfEvents.ShowTotalStationFooter = rowIndex == dataTable.Rows.Count - 1 ? true : false;

                    if (rowIndex % recordsPerPage == 0 && rowIndex != 0)
                    {
                        pdfDoc.Add(reportTable);

                        //-- set current page
                        objITextPdfEvents.CurrentPage = rowIndex / recordsPerPage;

                        pdfDoc.NewPage();

                        //clear previous records
                        reportTable.DeleteBodyRows();

                        //add header for new page
                        foreach (DataColumn column in dataTable.Columns)
                        {
                            cell = new PdfPCell(new Phrase(column.ColumnName, headerFont));
                            cell.BackgroundColor = new iTextSharp.text.Color(204, 204, 204);
                            reportTable.AddCell(cell);
                        }
                    }
                    else
                    {
                        for (int colIndex = 0; colIndex < totalColumns; colIndex++)
                        {
                            reportTable.AddCell(new PdfPCell(new Phrase(string.IsNullOrEmpty(dataTable.Rows[rowIndex].Field<string>(colIndex)) ? string.Empty : dataTable.Rows[rowIndex].Field<string>(colIndex), contentFont)));
                        }
                    }
                }

                objITextPdfEvents.CurrentPage = totalPages > 1 ? objITextPdfEvents.CurrentPage + 1 : objITextPdfEvents.CurrentPage;
                pdfDoc.Add(reportTable);

                //add total and remain records

                PdfPTable tblFooterTotalRecords = new PdfPTable(1);
                tblFooterTotalRecords.WidthPercentage = reportTable.WidthPercentage;

                PdfPCell emptyRow = new PdfPCell();
                emptyRow.Border = 0;

                PdfPCell cellFooterTab = new PdfPCell(new Phrase(
                                                 "Total Stations : " + totalRecord,
                                                 new Font(Font.ITALIC, 13, 2)
                                                ));
                cellFooterTab.BackgroundColor = new iTextSharp.text.Color(204, 204, 204);
                cellFooterTab.HorizontalAlignment = Element.ALIGN_CENTER;
                cellFooterTab.VerticalAlignment = Element.ALIGN_CENTER;

                tblFooterTotalRecords.AddCell(emptyRow);
                tblFooterTotalRecords.AddCell(emptyRow);
                tblFooterTotalRecords.AddCell(emptyRow);
                tblFooterTotalRecords.AddCell(cellFooterTab);

                //add total station after records
                pdfDoc.Add(tblFooterTotalRecords);
            }
            else
            {
                Paragraph paraNoRecords = new Paragraph("There are no records to display.", noRecordFont);
                paraNoRecords.Alignment = Element.ALIGN_CENTER;
                pdfDoc.Add(paraNoRecords);
            }
            pdfDoc.Close();
            Response.Write(pdfDoc);
            Response.End();
        }


        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1804:RemoveUnusedLocals", MessageId = "endMonthTime"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1804:RemoveUnusedLocals", MessageId = "endMonthDays"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1804:RemoveUnusedLocals", MessageId = "endMonthStation"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1804:RemoveUnusedLocals", MessageId = "EndMonthIncluded"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1822:MarkMembersAsStatic"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1820:TestForEmptyStringsUsingStringLength"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1804:RemoveUnusedLocals", MessageId = "drn"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1804:RemoveUnusedLocals", MessageId = "currDays"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1804:RemoveUnusedLocals", MessageId = "currTime")]
        public DataTable FormatProgramLineUpReport(DataTable dto, string endMonth)
        {
            DataTable dtn = new DataTable();
            dtn.Columns.Add("Station", typeof(string));
            dtn.Columns.Add("Days", typeof(string));
            //dtn.Columns.Add("o", typeof(string));
            //dtn.Columns.Add("w", typeof(string));
            string currStation = "";
            string currDays = "";
            string currTime = "";
            DataRow drn;
            int cnt = 1;
            int stationProgramCount = 0;
            bool EndMonthIncluded = false;
            string endMonthStation = "";
            string endMonthDays = "";
            string endMonthTime = "";
            int totalStationsProcessedCount = 0;
            string tmpMonth = "";
            string tmpStation = "";
            string tmpDays = "";
            foreach (DataRow dr in dto.Rows)
            {

                if (currStation != "")
                {
                    tmpStation = dr[0].ToString();

                    tmpDays = dr[2].ToString();
                    //new program record
                    if (tmpDays != currDays || dr[3].ToString() != currTime || tmpStation != currStation)
                    {
                        if (cnt >= 2)
                        {
                            drn = dtn.Rows.Add(currStation, multiDayMerge(currDays) + " " + currTime);
                            stationProgramCount++;
                        }
                        cnt = 1;

                    }
                    else
                    {
                        cnt++;
                    }

                    if (tmpStation != currStation)
                    {
                        //if we still haven't added any multi-month for the station, but there is one at the end of the month
                        if (EndMonthIncluded == true && stationProgramCount == 0)
                        {
                            drn = dtn.Rows.Add(endMonthStation, multiDayMerge(endMonthDays) + " " + endMonthTime);
                            //totalStationsProcessedCount++;
                        }

                        //always reset if new station
                        EndMonthIncluded = false;
                        stationProgramCount = 0;
                        totalStationsProcessedCount++;
                    }


                    tmpMonth = dr[1].ToString();
                    if (tmpMonth == endMonth)
                    {
                        endMonthStation = dr[0].ToString();
                        endMonthDays = dr[2].ToString();
                        endMonthTime = dr[3].ToString();
                        EndMonthIncluded = true;
                    }
                }
                currStation = dr[0].ToString();
                currDays = dr[2].ToString();
                currTime = dr[3].ToString();



            }

            //Catch last station Day/timespand row. If multipple months add, or if none found then add edge case when program in last month
            if (cnt >= 2)
            {
                drn = dtn.Rows.Add(currStation, multiDayMerge(currDays) + " " + currTime);
                stationProgramCount++;
            }
            if (EndMonthIncluded == true && stationProgramCount == 0)
            {
                drn = dtn.Rows.Add(endMonthStation, multiDayMerge(endMonthDays) + " " + endMonthTime);
                //totalStationsProcessedCount++;
            }
            return dtn;
        }



        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Maintainability", "CA1502:AvoidExcessiveComplexity"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1804:RemoveUnusedLocals", MessageId = "wksC"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", MessageId = "sheetName"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1820:TestForEmptyStringsUsingStringLength")]
        public static MemoryStream DataTableToExcelXlsxCarriageWorkbook(DataTable table, string sheetName, string footerDate)
        {
            MemoryStream Result = new MemoryStream();
            OfficeOpenXml.ExcelPackage pack = new OfficeOpenXml.ExcelPackage();
            OfficeOpenXml.ExcelWorksheet ws = null;


            OfficeOpenXml.Style.Border br;

            //ws.Cells.Style.Border = OfficeOpenXml.Style.ExcelBorderStyle.Thin;
            int col = 1;
            int row = 1;
            int scnt = 0;
            Hashtable h = new Hashtable();
            string currprogram = "";
            foreach (DataRow rw in table.Rows)
            {
                if (rw[0].ToString() != currprogram)
                {

                    if (ws != null)
                    {
                        ws.Cells.AutoFitColumns();
                        ws.View.ShowGridLines = false;
                        ws.Cells[row, 1].Value = "Total Stations:  " + h.Count.ToString();
                        ws.Cells["A" + row.ToString() + ":J" + row.ToString()].Merge = true;
                        ws.Cells["A" + row.ToString() + ":J" + row.ToString()].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                        ws.Cells["A" + row.ToString() + ":J" + row.ToString()].Style.Font.SetFromFont(new System.Drawing.Font("Calibri", 11, System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Italic));
                        //ws.Cells[row, 10].Value = h.Count;
                        br = ws.Cells["A" + row.ToString() + ":J" + row.ToString()].Style.Border;
                        br.Left.Style = br.Right.Style = br.Bottom.Style = br.Top.Style = OfficeOpenXml.Style.ExcelBorderStyle.Thin;
                        ws.Cells["A" + row.ToString() + ":J" + row.ToString()].Style.Font.Bold = true;
                        ws.Cells["A" + row.ToString() + ":J" + row.ToString()].Style.Fill.PatternType = OfficeOpenXml.Style.ExcelFillStyle.Solid;
                        ws.Cells["A" + row.ToString() + ":J" + row.ToString()].Style.Fill.BackgroundColor.SetColor(System.Drawing.Color.LightGray);
                        ws.PrinterSettings.FitToPage = true;
                        ws.PrinterSettings.FitToWidth = 1;
                        ws.PrinterSettings.FitToHeight = 0;
                       // ws.PrinterSettings.RepeatRows = ws.Cells["1:7"];
                        ws.HeaderFooter.OddFooter.CenteredText = "NPR Carriage Report Center, " + footerDate + ", Page " + OfficeOpenXml.ExcelHeaderFooter.PageNumber + " of " + OfficeOpenXml.ExcelHeaderFooter.NumberOfPages;

                    }
                    row = 1;
                    scnt = 0;
                    h = new Hashtable();
                    currprogram = rw[0].ToString();
                    ws = pack.Workbook.Worksheets.Add(currprogram);

                    ws.Cells[2, 1].Value = " CARRIAGE LIST";
                    ws.Cells[2, 1].Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 20, System.Drawing.FontStyle.Bold));
                    ws.Cells["A2:C2"].Merge = true;
                    ws.Row(4).Height = 5;
                    ws.Row(6).Height = 5;
                    ws.Cells[5, 1].Value = currprogram;
                    ws.Cells["A5:J5"].Merge = true;
                    //ws.Cells["A6:J6"].Style.Font.Bold = true;
                    //ws.Cells["A6:J6"].Style.Font.Italic = true;
                    //ws.Cells["A6:J6"].Style.Font.Size = 14;
                    //ws.Cells["A6:J6"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    //ws.Cells["A6:J6"].Style.Font.Name = "Times New Roman";
                    ws.Cells["A5:J5"].Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 14, System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Italic));
                    ws.Cells["A5:J5"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    var prodImg = ws.Drawings.AddPicture(currprogram, new FileInfo(System.Web.HttpContext.Current.Server.MapPath("~/Content/Images/logo.png")));
                    prodImg.SetPosition(10, 450);
                    prodImg.SetSize(145, 30);




                }
                if (row == 1)
                {
                    row = 7;
                    //currprogram = rw[1].ToString();


                    foreach (DataColumn cl in table.Columns)
                    {
                        if (col > 1)
                        {


                            ws.Cells[row, col - 1].Value = cl.ColumnName;
                            ws.Cells[row, col - 1].Style.Font.Bold = true;
                            ws.Cells[row, col - 1].Style.Fill.PatternType = OfficeOpenXml.Style.ExcelFillStyle.Solid;

                            ws.Cells[row, col - 1].Style.Fill.BackgroundColor.SetColor(System.Drawing.Color.LightGray);
                            ws.Cells[row, col - 1].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Left;
                            br = ws.Cells[row, col - 1].Style.Border;
                            br.Left.Style = br.Right.Style = br.Bottom.Style = br.Top.Style = OfficeOpenXml.Style.ExcelBorderStyle.Thin;

                        }
                        col++;
                    }
                    row++;
                    col = 1;
                }

                double number;
                foreach (DataColumn cl in table.Columns)
                {
                    if (col == 2)
                    {
                        if (!h.ContainsKey(rw[cl.ColumnName].ToString()))
                            h.Add(rw[cl.ColumnName].ToString(), rw[cl.ColumnName].ToString());

                    }
                    if (col > 1)
                    {
                        if (rw[cl.ColumnName] != DBNull.Value)
                        {
                            //ws.Cells[row, col].Value = rw[cl.ColumnName].ToString();
                            if (Double.TryParse(rw[cl.ColumnName].ToString(), out number))
                            {
                                ws.Cells[row, col - 1].Value = number;
                                //if (col == 14 || col == 15 || col == 19 || col == 21 || col == 22 || col == 23)
                                //    ws.Cells[row, col].Style.Numberformat.Format = "0.00";
                            }
                            else
                            {

                                if (cl.ColumnName == "Day(s)")
                                    ws.Cells[row, col - 1].Value = multiDayMerge(rw[cl.ColumnName].ToString());
                                else
                                    ws.Cells[row, col - 1].Value = rw[cl.ColumnName].ToString();
                            }
                            //if (rw[cl.ColumnName].ToString().IndexOf("%") != -1)
                            //{
                            //    ws.Cells[row, col].Style.Numberformat.Format = "0%";
                            //    ws.Cells[row, col].Value = Double.Parse(rw[cl.ColumnName].ToString().TrimEnd('%')) / 100;
                            //}
                        }
                        br = ws.Cells[row, col - 1].Style.Border;
                        br.Left.Style = br.Right.Style = br.Bottom.Style = br.Top.Style = OfficeOpenXml.Style.ExcelBorderStyle.Thin;
                        ws.Cells[row, col - 1].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Left;
                    }

                    col++;
                }
                scnt++;
                row++;
                col = 1;

            }
            
            string sheetname;

            if (ws != null)
            {
                sheetname = ws.Name;
                ws.Cells.AutoFitColumns();
                ws.View.ShowGridLines = false;
                ws.Cells[row, 1].Value = "Total Stations: " + h.Count.ToString();
                //ws.Cells[row, 10].Value = h.Count;
                ws.Cells["A" + row.ToString() + ":J" + row.ToString()].Merge = true;
                ws.Cells["A" + row.ToString() + ":J" + row.ToString()].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                ws.Cells["A" + row.ToString() + ":J" + row.ToString()].Style.Font.SetFromFont(new System.Drawing.Font("Calibri", 11, System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Italic));

                br = ws.Cells["A" + row.ToString() + ":J" + row.ToString()].Style.Border;
                br.Left.Style = br.Right.Style = br.Bottom.Style = br.Top.Style = OfficeOpenXml.Style.ExcelBorderStyle.Thin;
                ws.Cells["A" + row.ToString() + ":J" + row.ToString()].Style.Font.Bold = true;
                ws.Cells["A" + row.ToString() + ":J" + row.ToString()].Style.Fill.PatternType = OfficeOpenXml.Style.ExcelFillStyle.Solid;
                ws.Cells["A" + row.ToString() + ":J" + row.ToString()].Style.Fill.BackgroundColor.SetColor(System.Drawing.Color.LightGray);
                ws.PrinterSettings.FitToPage = true;
                ws.PrinterSettings.FitToWidth = 1;
                ws.PrinterSettings.FitToHeight = 0;
                //ws.PrinterSettings.RepeatRows = ws.Cells["1:7"];
                ws.HeaderFooter.OddFooter.CenteredText = "NPR Carriage Report Center, " + footerDate + " , Page " + OfficeOpenXml.ExcelHeaderFooter.PageNumber + " of " + OfficeOpenXml.ExcelHeaderFooter.NumberOfPages;

            }



            int wksC = pack.Workbook.Worksheets.Count;
            for (int i = 1; i <= wksC; i++)
            {
                sheetname = pack.Workbook.Worksheets[i].Name;
                if (sheetname != null && sheetname.Contains("'") ==false)
                {
                    //sheetname = pack.Workbook.Worksheets[i].Name;
                    pack.Workbook.Worksheets[i].PrinterSettings.RepeatRows = pack.Workbook.Worksheets[i].Cells["1:7"];
                }
            }


            if (wksC ==0 )
            {
                ws = pack.Workbook.Worksheets.Add("Sheet1");
                foreach (DataColumn cl in table.Columns)
                {
                    if (col > 1)
                    {


                        ws.Cells[row, col - 1].Value = cl.ColumnName;
                        ws.Cells[row, col - 1].Style.Font.Bold = true;
                        ws.Cells[row, col - 1].Style.Fill.PatternType = OfficeOpenXml.Style.ExcelFillStyle.Solid;

                        ws.Cells[row, col - 1].Style.Fill.BackgroundColor.SetColor(System.Drawing.Color.LightGray);
                        ws.Cells[row, col - 1].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Left;
                        br = ws.Cells[row, col - 1].Style.Border;
                        br.Left.Style = br.Right.Style = br.Bottom.Style = br.Top.Style = OfficeOpenXml.Style.ExcelBorderStyle.Thin;

                    }
                    col++;
                    ws.Cells[2, 1].Value = "No Data";
                    ws.Cells.AutoFitColumns();
                    ws.View.ShowGridLines = false;
                }
               
            }

            pack.SaveAs(Result);
            return Result;
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1811:AvoidUncalledPrivateCode")]
        private void ConvertToXLSXCarriageWorkbook(string fileName, DataTable dt, string footerDate)
        {
            MemoryStream ms = DataTableToExcelXlsxCarriageWorkbook(dt, "Sheet1", footerDate);
            ms.WriteTo(Response.OutputStream);
            //MemoryStream ms2 = DataTableToExcelXlsx(dt, "Sheet2");
            //ms2.WriteTo(Response.OutputStream);


            Response.AddHeader("Content-Disposition", "attachment;filename=" + fileName + ".xlsx");
            Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            Response.StatusCode = 200;
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
                            else
                            {
                                ws.Cells[row, col].Value = multiDayMerge(rw[cl.ColumnName].ToString());
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


        [SuppressMessage("Microsoft.Performance", "CA1804:RemoveUnusedLocals", MessageId = "h")]
        public void ConvertToXLSXFormatCalculationsRawData(DataTable table, string fileName, bool header, int multiDayColumn)
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

                                    if (col == 7 || col == 8 || col == 9 || col == 10 || col == 11 || col == 12 || col == 13 || col == 14 || col == 15 || col == 16)
                                    {
                                        //if (number > big1)
                                        //{
                                        //    big2 = big1;
                                        //    big2CatName = big1CatName;

                                        //    big1 = number;
                                        //    big1CatName = cl.ColumnName;
                                        //}
                                        //else if (number > big2)
                                        //{
                                        //    big2 = number;
                                        //    big2CatName = cl.ColumnName;
                                        //}
                                        //sTotal = sTotal + (number / 100);
                                        ws.Cells[row, col].Value = number;
                                        //ws.Cells[row, col].Style.Numberformat.Format = "0.0%";
                                    }
                                    //else if (col == 16)
                                    //{
                                    //    ws.Cells[row, col].Value = sTotal;
                                    //    ws.Cells[row, col].Style.Numberformat.Format = "0.00%";
                                    //}
                                    //else if (col == 17)
                                    //{
                                    //    if (number > 0)
                                    //    {
                                    //        if (big1CatName == "News")
                                    //            ws.Cells[row, col].Value = "News";
                                    //        else
                                    //            ws.Cells[row, col].Value = "News" + big1CatName;
                                    //    }
                                    //    else
                                    //    {
                                    //        if(big2>15)
                                    //            ws.Cells[row, col].Value = big1CatName + "-" + big2CatName;
                                    //        else
                                    //            ws.Cells[row, col].Value = big1CatName;
                                    //    }

                                    //}
                                    else
                                        ws.Cells[row, col].Value = number;
                                }

                                else
                                    ws.Cells[row, col].Value = rw[cl.ColumnName].ToString();
                                //if (rw[cl.ColumnName].ToString().IndexOf("%") != -1)
                                //{
                                //    ws.Cells[row, col].Style.Numberformat.Format = "0%";
                                //    ws.Cells[row, col].Value = Double.Parse(rw[cl.ColumnName].ToString().TrimEnd('%')) / 100;
                                //}
                            }
                            else
                            {
                                ws.Cells[row, col].Value = multiDayMerge(rw[cl.ColumnName].ToString());
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
                ws.PrinterSettings.RepeatRows = ws.Cells["1:1"];
            }

            pack.SaveAs(Result);
            Result.WriteTo(Response.OutputStream);

            Response.AddHeader("Content-Disposition", "attachment;filename=" + fileName + ".xlsx");
            Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            Response.StatusCode = 200;
        }


        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Maintainability", "CA1502:AvoidExcessiveComplexity"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1804:RemoveUnusedLocals", MessageId = "h"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", MessageId = "sheetName"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1820:TestForEmptyStringsUsingStringLength")]
        public void ConvertToXLSXFormatCalculations(DataTable table, string fileName, bool header, int multiDayColumn)
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

                                    if (col == 7 || col == 8 || col == 9 || col == 10 || col == 11 || col == 12 || col == 13 || col == 14 || col == 15 || col == 16)
                                    {
                                        //if (number > big1)
                                        //{
                                        //    big2 = big1;
                                        //    big2CatName = big1CatName;

                                        //    big1 = number;
                                        //    big1CatName = cl.ColumnName;
                                        //}
                                        //else if (number > big2)
                                        //{
                                        //    big2 = number;
                                        //    big2CatName = cl.ColumnName;
                                        //}
                                        //sTotal = sTotal + (number / 100);
                                        ws.Cells[row, col].Value = number / 100;
                                        ws.Cells[row, col].Style.Numberformat.Format = "0.0%";
                                    }
                                    //else if (col == 16)
                                    //{
                                    //    ws.Cells[row, col].Value = sTotal;
                                    //    ws.Cells[row, col].Style.Numberformat.Format = "0.00%";
                                    //}
                                    //else if (col == 17)
                                    //{
                                    //    if (number > 0)
                                    //    {
                                    //        if (big1CatName == "News")
                                    //            ws.Cells[row, col].Value = "News";
                                    //        else
                                    //            ws.Cells[row, col].Value = "News" + big1CatName;
                                    //    }
                                    //    else
                                    //    {
                                    //        if(big2>15)
                                    //            ws.Cells[row, col].Value = big1CatName + "-" + big2CatName;
                                    //        else
                                    //            ws.Cells[row, col].Value = big1CatName;
                                    //    }

                                    //}
                                    else
                                        ws.Cells[row, col].Value = number;
                                }

                                else
                                    ws.Cells[row, col].Value = rw[cl.ColumnName].ToString();
                                //if (rw[cl.ColumnName].ToString().IndexOf("%") != -1)
                                //{
                                //    ws.Cells[row, col].Style.Numberformat.Format = "0%";
                                //    ws.Cells[row, col].Value = Double.Parse(rw[cl.ColumnName].ToString().TrimEnd('%')) / 100;
                                //}
                            }
                            else
                            {
                                ws.Cells[row, col].Value = multiDayMerge(rw[cl.ColumnName].ToString());
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
                ws.PrinterSettings.RepeatRows = ws.Cells["1:1"];
            }

            pack.SaveAs(Result);
            Result.WriteTo(Response.OutputStream);

            Response.AddHeader("Content-Disposition", "attachment;filename=" + fileName + ".xlsx");
            Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            Response.StatusCode = 200;
        }


        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1804:RemoveUnusedLocals", MessageId = "rw"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1822:MarkMembersAsStatic")]
        public DataTable FormatCarriageListByProgramReport(DataTable table)
        {
            int row = 0;

            foreach (DataColumn c in table.Columns)
                c.ReadOnly = false;


            foreach (DataRow rw in table.Rows)
            {
                table.Rows[row][7] = multiDayMerge(table.Rows[row][7].ToString());
                row++;
            }
            return table;
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1804:RemoveUnusedLocals", MessageId = "big3CatName"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1806:DoNotIgnoreMethodResults", MessageId = "System.Double.TryParse(System.String,System.Double@)"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Maintainability", "CA1502:AvoidExcessiveComplexity"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1822:MarkMembersAsStatic")]
        public DataTable FormatCalculationsReportFormat(DataTable table)
        {


            int col = 1;
            int row = 1;

            foreach (DataColumn c in table.Columns)
                c.ReadOnly = false;

            Dictionary<string, string> h = new Dictionary<string, string>();

            h.Add("CLS", "Classical");
            h.Add("ECL", "Eclectic");
            h.Add("ENT", "Entertainment");
            h.Add("FLK", "Folk Music");
            h.Add("JZZ", "Jazz");
            h.Add("NWS", "News");
            h.Add("OFF", "Off-air");
            h.Add("POP", "Pop");
            h.Add("TRG", "Targeted");
            h.Add("WLD", "World");




            double sTotal;
            double big1 = 0;
            string big1CatName = "";
            double big2 = 0;
            string big2CatName = "";
            double big3 = 0;
            string big3CatName = "";
            double tval = 0;

            foreach (DataRow rw in table.Rows)
            {

                double number;

                sTotal = 0;
                big1 = 0;
                big1CatName = "";
                big2 = 0;
                big2CatName = "";
                big3 = 0;
                big3CatName = "";
                double newsPct = 0;
                Double.TryParse(rw["Total"].ToString(), out number);
                tval = number;
                number = 0;
                foreach (DataColumn cl in table.Columns)
                {


                    if (Double.TryParse(rw[cl.ColumnName].ToString(), out number))
                    {
                        //if (number == 0)
                        //    table.Rows[row - 1][col - 1] = DBNull;
                        if (col == 7 || col == 8 || col == 9 || col == 10 || col == 11 || col == 12 || col == 13 || col == 14 || col == 15)
                        {
                            if (number > big1 && (tval == 0 || (cl.ColumnName != "NWS" || number >= 70)))
                            {
                                big3 = big2;
                                big3CatName = big2CatName;

                                big2 = big1;
                                big2CatName = big1CatName;

                                big1 = number;
                                big1CatName = cl.ColumnName;
                            }
                            else if (number > big2 && (tval == 0 || (cl.ColumnName != "NWS" || number >= 70)))
                            {

                                big3 = big2;
                                big3CatName = big2CatName;

                                big2 = number;
                                big2CatName = cl.ColumnName;
                            }
                            else if (number > big3 && (tval == 0 || (cl.ColumnName != "NWS" || number >= 70)))
                            {
                                big3 = number;
                                big3CatName = cl.ColumnName;
                            }
                            sTotal = sTotal + (number);

                        }
                        else if (col == 16)
                        {
                            //tval = number;
                            table.Rows[row - 1][col - 1] = sTotal;

                        }


                    }
                    else if (col == 17)
                    {
                        Double.TryParse(rw["NWS"].ToString(), out newsPct);
                        if (tval > 0)
                        {
                            if (newsPct >= 70)
                            {
                                table.Rows[row - 1][col - 1] = "News";
                            }
                            else
                            {
                                //Frist check if there are 3 that meet the criteria
                                if (newsPct - big3 > 5)
                                {
                                    //if there are two that meet the criteria ---***note to filter out News so as not to repeat 
                                    if (newsPct - big2 <= 5)
                                    {
                                        if (h[big1CatName] == "News")
                                            table.Rows[row - 1][col - 1] = "News" + "-" + h[big2CatName];
                                        else if (h[big2CatName] == "News")
                                            table.Rows[row - 1][col - 1] = "News" + "-" + h[big1CatName];
                                        else
                                            table.Rows[row - 1][col - 1] = "News" + "-" + h[big1CatName] + "-" + h[big2CatName];

                                    }
                                    //see if there's at least one --***note to filter out News so as not to repeat 
                                    else if (newsPct - big1 <= 5)
                                    {
                                        if (h[big1CatName] == "News")
                                            table.Rows[row - 1][col - 1] = "News";
                                        else
                                            table.Rows[row - 1][col - 1] = "News" + "-" + h[big1CatName];
                                    }
                                    //if none meet the within 5% rule, then see if any are over 30% --***note to filter out News so as not to repeat 
                                    else if (big1 >= 30)
                                    {
                                        if (h[big1CatName] == "News")
                                            table.Rows[row - 1][col - 1] = "News";
                                        else
                                            table.Rows[row - 1][col - 1] = "News" + "-" + h[big1CatName];
                                    }
                                    //if no significant category (within 5% of News or greater than 30%) then News Mix
                                    else
                                    {
                                        table.Rows[row - 1][col - 1] = "News-Mix";
                                    }
                                }
                                else
                                {
                                    //there are 3 that match 5% threshold   
                                    table.Rows[row - 1][col - 1] = "News-Mix";
                                }
                            }
                        }
                        else
                        {
                            if (big1 >= 70)
                            {
                                table.Rows[row - 1][col - 1] = h[big1CatName];
                            }
                            else if ((big1 + big2 + big3) >= 60 && big1 >= 15 && big2 >= 15 && big3 >= 15)
                            {
                                table.Rows[row - 1][col - 1] = h[big1CatName] + "-" + h[big2CatName] + "-" + h[big3CatName];
                            }
                            else if ((big1 + big2) >= 60 && big1 >= 15 && big2 >= 15)
                            {
                                table.Rows[row - 1][col - 1] = h[big1CatName] + "-" + h[big2CatName];
                            }
                            else
                            {
                                table.Rows[row - 1][col - 1] = "Eclectic Mix";
                            }

                        }

                    }
                    col++;
                }
                row++;
                col = 1;
            }
            return table;

        }





        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1804:RemoveUnusedLocals", MessageId = "h"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", MessageId = "sheetName"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1820:TestForEmptyStringsUsingStringLength")]
        public void ConvertToXLSXCarriageByProgram(DataTable table, string fileName, bool header, int multiDayColumn, string programname, string timeDuration)
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

            string currprogram = programname;
            //if (table.Rows.Count > 0)
            //{
            //    currprogram = table.Rows[0][10].ToString();
            //}
            ws.Cells[2, 1].Value = " CARRIAGE LIST";
            ws.Cells[2, 1].Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 20, System.Drawing.FontStyle.Bold));
            ws.Cells["A2:C2"].Merge = true;
            ws.Row(4).Height = 5;
            ws.Row(6).Height = 5;
            ws.Cells[5, 1].Value = currprogram;
            ws.Cells["A5:J5"].Merge = true;
            //ws.Cells["A6:J6"].Style.Font.Bold = true;
            //ws.Cells["A6:J6"].Style.Font.Italic = true;
            //ws.Cells["A6:J6"].Style.Font.Size = 14;
            //ws.Cells["A6:J6"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
            //ws.Cells["A6:J6"].Style.Font.Name = "Times New Roman";
            ws.Cells["A5:J5"].Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 14, System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Italic));
            ws.Cells["A5:J5"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
            var prodImg = ws.Drawings.AddPicture(currprogram, new FileInfo(System.Web.HttpContext.Current.Server.MapPath("~/Content/Images/logo.png")));
            prodImg.SetPosition(10, 450);
            prodImg.SetSize(145, 30);


            row = 8;

            if (header == true)
            {

                foreach (DataColumn cl in table.Columns)
                {
                    if (col > 0 && col < 11)
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

                    if (col > 0 && col < 11)
                    {
                        if (col == 1)
                        {
                            if (!h.ContainsKey(rw[cl.ColumnName].ToString()))
                                h.Add(rw[cl.ColumnName].ToString(), rw[cl.ColumnName].ToString());

                        }
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
                            else
                            {
                                //ws.Cells[row, col].Value = multiDayMerge(rw[cl.ColumnName].ToString());
                                ws.Cells[row, col].Value = rw[cl.ColumnName].ToString();
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


            if (ws != null)
            {
                ws.Cells.AutoFitColumns();
                ws.View.ShowGridLines = false;
                ws.Cells[row, 1].Value = "Total Stations  " + h.Count.ToString();
                //ws.Cells[row, 9].Value = h.Count;
                ws.Cells["A" + row.ToString() + ":J" + row.ToString()].Merge = true;
                ws.Cells["A" + row.ToString() + ":J" + row.ToString()].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                br = ws.Cells["A" + row.ToString() + ":J" + row.ToString()].Style.Border;
                br.Left.Style = br.Right.Style = br.Bottom.Style = br.Top.Style = OfficeOpenXml.Style.ExcelBorderStyle.Thin;
                ws.Cells["A" + row.ToString() + ":J" + row.ToString()].Style.Font.Bold = true;
                ws.Cells["A" + row.ToString() + ":J" + row.ToString()].Style.Fill.PatternType = OfficeOpenXml.Style.ExcelFillStyle.Solid;
                ws.Cells["A" + row.ToString() + ":J" + row.ToString()].Style.Fill.BackgroundColor.SetColor(System.Drawing.Color.LightGray);
                ws.PrinterSettings.FitToPage = true;
                ws.PrinterSettings.FitToWidth = 1;
                ws.PrinterSettings.FitToHeight = 0;
                ws.PrinterSettings.RepeatRows = ws.Cells["1:8"];
                ws.HeaderFooter.OddFooter.CenteredText = "Source : NPR Carriage Report Center, " + timeDuration + " , Page " + OfficeOpenXml.ExcelHeaderFooter.PageNumber + " of " + OfficeOpenXml.ExcelHeaderFooter.NumberOfPages;

            }


            pack.SaveAs(Result);
            Result.WriteTo(Response.OutputStream);

            Response.AddHeader("Content-Disposition", "attachment;filename=" + fileName + ".xlsx");
            Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            Response.StatusCode = 200;
        }


		[System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1804:RemoveUnusedLocals", MessageId = "h"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", MessageId = "sheetName"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1820:TestForEmptyStringsUsingStringLength")]
        public void ConvertToXLSXLeadInLeadOut(DataTable table, string fileName, bool header, int multiDayColumn, string programname, string timeDuration)
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

            string currprogram = programname;
            //if (table.Rows.Count > 0)
            //{
            //    currprogram = table.Rows[0][10].ToString();
            //}
            ws.Cells[2, 1].Value = " Lead In / Lead Out";
            ws.Cells[2, 1].Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 20, System.Drawing.FontStyle.Bold));
            ws.Cells["A2:D2"].Merge = true;
            ws.Row(4).Height = 5;
            ws.Row(6).Height = 5;
            ws.Cells[5, 1].Value = currprogram;
            ws.Cells["A5:J5"].Merge = true;
            //ws.Cells["A6:J6"].Style.Font.Bold = true;
            //ws.Cells["A6:J6"].Style.Font.Italic = true;
            //ws.Cells["A6:J6"].Style.Font.Size = 14;
            //ws.Cells["A6:J6"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
            //ws.Cells["A6:J6"].Style.Font.Name = "Times New Roman";
            ws.Cells["A5:J5"].Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 14, System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Italic));
            ws.Cells["A5:J5"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
            var prodImg = ws.Drawings.AddPicture(currprogram, new FileInfo(System.Web.HttpContext.Current.Server.MapPath("~/Content/Images/logo.png")));
            prodImg.SetPosition(10, 450);
            prodImg.SetSize(145, 30);


            row = 8;

            if (header == true)
            {

                foreach (DataColumn cl in table.Columns)
                {
                    if (col > 0 && col < 11)
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

                    if (col > 0 && col < 11)
                    {
                        if (col == 1)
                        {
                            if (!h.ContainsKey(rw[cl.ColumnName].ToString()))
                                h.Add(rw[cl.ColumnName].ToString(), rw[cl.ColumnName].ToString());

                        }
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
                            else
                            {
                                //ws.Cells[row, col].Value = multiDayMerge(rw[cl.ColumnName].ToString());
                                ws.Cells[row, col].Value = rw[cl.ColumnName].ToString();
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


            if (ws != null)
            {
                ws.Cells.AutoFitColumns();
                ws.View.ShowGridLines = false;
                ws.Cells[row, 1].Value = "Total Stations  " + h.Count.ToString();
                //ws.Cells[row, 9].Value = h.Count;
                ws.Cells["A" + row.ToString() + ":J" + row.ToString()].Merge = true;
                ws.Cells["A" + row.ToString() + ":J" + row.ToString()].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                br = ws.Cells["A" + row.ToString() + ":J" + row.ToString()].Style.Border;
                br.Left.Style = br.Right.Style = br.Bottom.Style = br.Top.Style = OfficeOpenXml.Style.ExcelBorderStyle.Thin;
                ws.Cells["A" + row.ToString() + ":J" + row.ToString()].Style.Font.Bold = true;
                ws.Cells["A" + row.ToString() + ":J" + row.ToString()].Style.Fill.PatternType = OfficeOpenXml.Style.ExcelFillStyle.Solid;
                ws.Cells["A" + row.ToString() + ":J" + row.ToString()].Style.Fill.BackgroundColor.SetColor(System.Drawing.Color.LightGray);
                ws.PrinterSettings.FitToPage = true;
                ws.PrinterSettings.FitToWidth = 1;
                ws.PrinterSettings.FitToHeight = 0;
                ws.PrinterSettings.RepeatRows = ws.Cells["1:8"];
                ws.HeaderFooter.OddFooter.CenteredText = "Source : NPR Carriage Report Center, " + timeDuration + " , Page " + OfficeOpenXml.ExcelHeaderFooter.PageNumber + " of " + OfficeOpenXml.ExcelHeaderFooter.NumberOfPages;

            }


            pack.SaveAs(Result);
            Result.WriteTo(Response.OutputStream);

            Response.AddHeader("Content-Disposition", "attachment;filename=" + fileName + ".xlsx");
            Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            Response.StatusCode = 200;
        }


        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1822:MarkMembersAsStatic")]
        public DataTable multiDayMergeTable(DataTable dt, int col)
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                dt.Rows[i][col] = multiDayMerge(dt.Rows[i][col].ToString());
            }
            return dt;
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1804:RemoveUnusedLocals", MessageId = "prevCurrDay"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1804:RemoveUnusedLocals", MessageId = "cnt"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1804:RemoveUnusedLocals", MessageId = "currDay"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", MessageId = "days"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1822:MarkMembersAsStatic")]
        public static string multiDayMerge(string days)
        {
            string[] daysSplit = days.Trim().Split(' ');
            int cnt = 1;
            string currDay = daysSplit[0];
            string daysCombine = daysSplit[0];
            bool consectutiveDay = false;
            string prevCurrDay = "";
            string ds;
            bool firstAlreadyAdded = false;
            for (int i = 1; i < daysSplit.Length; i++)
            {
                ds = daysSplit[i];
                consectutiveDay = false;
                //if (ds == "Mon" && currDay == "Sun")
                //    consectutiveDay = true;
                if (ds == "Tue" && currDay == "Mon")
                    consectutiveDay = true;
                if (ds == "Wed" && currDay == "Tue")
                    consectutiveDay = true;
                if (ds == "Thu" && currDay == "Wed")
                    consectutiveDay = true;
                if (ds == "Fri" && currDay == "Thu")
                    consectutiveDay = true;
                if (ds == "Sat" && currDay == "Fri")
                    consectutiveDay = true;
                if (ds == "Sun" && currDay == "Sat")
                    consectutiveDay = true;

                if (consectutiveDay == true)
                {
                    //daysCombine = daysCombine + ds;
                    //daysCombine = daysCombine + "-";
                    cnt++;
                }
                if (consectutiveDay == false || i == daysSplit.Length - 1)
                {
                    if (cnt >= 3)
                    {
                        if (consectutiveDay == false)
                        {
                            daysCombine = daysCombine + "-" + currDay + " " + ds + " ";
                        }
                        else
                        {
                            daysCombine = daysCombine + "-" + ds + " ";
                        }
                    }
                    else
                    {
                        if (i >= 2)
                            if (i == daysSplit.Length - 1 && firstAlreadyAdded)
                                daysCombine = daysCombine + " " + ds + " ";
                            else
                                daysCombine = daysCombine + " " + currDay + " " + ds + " ";
                        else
                        {
                            daysCombine = daysCombine + " " + ds + " ";
                            firstAlreadyAdded = true;
                        }
                    }
                    prevCurrDay = "";
                    cnt = 1;
                }
                prevCurrDay = currDay;
                currDay = ds;

            }

            //daysCombine = daysCombine + daysSplit[daysSplit.Length - 1];
            return (daysCombine);
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1811:AvoidUncalledPrivateCode")]
        private void ConvertToExcel(GridView grid, string fileName)
        {
            StringWriter sw = new StringWriter();

            Response.ClearContent();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment; filename=" + fileName + ".xls");
            Response.ContentType = "application/excel";

            Response.Charset = "";
            HtmlTextWriter htw = new HtmlTextWriter(sw);

            grid.RenderControl(htw);

            Response.Output.Write(sw.ToString());
            Response.Flush();
            Response.End();
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1820:TestForEmptyStringsUsingStringLength")]
        private void ConvertToCSV(DataTable dataTable, string fileName, bool showHeader)
        {
            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment;filename=" + fileName + ".csv");
            Response.Charset = "";
            Response.ContentType = "application/text";

            StringBuilder sb = new StringBuilder();

            if (showHeader)
            {
                for (int k = 0; k < dataTable.Columns.Count; k++)
                {
                    //add separator
                    if(!(dataTable.Columns[k].ColumnName==""))
                    {
                        sb.Append(dataTable.Columns[k].ColumnName + ',');
                    }
                }
                //append new line
                sb.Append("\r\n");
            }

            for (int i = 0; i < dataTable.Rows.Count; i++)
            {
                for (int k = 0; k < dataTable.Columns.Count; k++)
                {
                    //add separator
                    if(!(dataTable.Rows[i][k].ToString()==""))
                    {
                        sb.Append(dataTable.Rows[i][k].ToString().Replace(",", ";") + ',');
                    }
                }
                //append new line
                sb.Append("\r\n");
            }
            Response.Output.Write(sb.ToString());
            Response.Flush();
            Response.End();
        }


        private void ConvertFormatCalculationsToCSV(DataTable dataTable, string fileName, bool showHeader)
        {
            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment;filename=" + fileName + ".csv");
            Response.Charset = "";
            Response.ContentType = "application/text";

            StringBuilder sb = new StringBuilder();

            if (showHeader)
            {
                for (int k = 0; k < dataTable.Columns.Count; k++)
                {
                    //add separator
                    sb.Append(dataTable.Columns[k].ColumnName + ',');
                }
                //append new line
                sb.Append("\r\n");
            }

            for (int i = 0; i < dataTable.Rows.Count; i++)
            {
                for (int k = 0; k < dataTable.Columns.Count; k++)
                {
                    //add separator
                    if (k >= 6 && k <= 14 && !string.IsNullOrEmpty(dataTable.Rows[i][k].ToString()))
                        sb.Append(dataTable.Rows[i][k].ToString().Replace(",", ";") + "%,");
                    else
                        sb.Append(dataTable.Rows[i][k].ToString().Replace(",", ";") + ',');
                }
                //append new line
                sb.Append("\r\n");
            }
            Response.Output.Write(sb.ToString());
            Response.Flush();
            Response.End();
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1820:TestForEmptyStringsUsingStringLength")]
        private void CustomGridDumpTxt(DataTable dataTable, string fileName, bool showHeader)
        {
            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment;filename=" + fileName + ".txt");
            Response.Charset = "";
            Response.ContentType = "application/text";

            StringBuilder sb = new StringBuilder();
            string tmp = "";
            if (showHeader)
            {
                for (int k = 0; k < dataTable.Columns.Count; k++)
                {
                    //add separator
                    if (!(dataTable.Columns[k].ColumnName == ""))
                    {
                        sb.Append(dataTable.Columns[k].ColumnName + ',');
                    }
                }
                //append new line
                sb.Append("\r\n");
            }

            for (int i = 0; i < dataTable.Rows.Count; i++)
            {
                for (int k = 0; k < dataTable.Columns.Count; k++)
                {

                    //add separator
                    tmp = dataTable.Rows[i][k].ToString();
                    if (tmp.IndexOf('=') > -1)
                        tmp = tmp.Substring(1);
                    if (!(tmp == ""))
                    {
                        sb.Append(tmp.Replace(",", ";") + ',');
                    }
                }
                //append new line
                sb.Remove(sb.Length - 1, 1);
                sb.Append("\r\n");
            }
            Response.Output.Write(sb.ToString());
            Response.Flush();
            Response.End();
        }

        #endregion

		#region LeadInLeadOut Report

		[Authorize(Roles = CRCUserRoles.Administrator)]
		public ActionResult LeadInLeadOut()
		{
			var viewModel = new LeadInLeadOutViewModel();
			return View(viewModel);
		}

		[System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1804:RemoveUnusedLocals", MessageId = "time"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1804:RemoveUnusedLocals", MessageId = "day"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1804:RemoveUnusedLocals", MessageId = "tomon"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1804:RemoveUnusedLocals", MessageId = "frommon"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1804:RemoveUnusedLocals", MessageId = "toyear"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1804:RemoveUnusedLocals", MessageId = "fromyear"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1804:RemoveUnusedLocals", MessageId = "StationCount"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1804:RemoveUnusedLocals", MessageId = "tomonth"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1804:RemoveUnusedLocals", MessageId = "frommonth"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1804:RemoveUnusedLocals", MessageId = "table"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1804:RemoveUnusedLocals", MessageId = "RTable"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Maintainability", "CA1502:AvoidExcessiveComplexity"), HttpPost]
        public ActionResult LeadInLeadOut(LeadInLeadOutViewModel model)
        {
            int fromyear = model.YearsFrom;
            int toyear = model.YearsTo;
            string frommonth = model.MonthsFrom;
            string tomonth = model.MonthsTo;
            int frommon = 0;
            int tomon = 0;
            frommon = Int32.Parse(frommonth);
            tomon = Int32.Parse(tomonth);
			string day = model.Day;
			string StartTime = model.StartTime;
            string EndTime = model.EndTime;
			//if (EndTime == "Midnight") { EndTime = "23:59:59"; };
		 

            string fileName = "LeadInLeadOut";
		

            //DataSet dataSet = CRCDataAccess.GetCarriageListByProgramReport(model.type, model.ProgramEnabled, model.ProgramID, model.MonthsFrom, model.YearsFrom, model.MonthsTo, model.YearsTo, model.ReportFormat, model.Band, model.StationEnabled, model.MemberStatus, model.StationId, model.City, model.StateId);
			DataSet dataSet = CRCDataAccess.GetLeadInLeadOutReport(model.type, model.ProgramEnabled, model.ProgramID, model.MonthsFrom, model.YearsFrom, model.MonthsTo, model.YearsTo, model.ReportFormat, model.Band, model.StationEnabled, model.MemberStatus, model.StationId, model.City, model.StateId, day, StartTime, EndTime);

            if (dataSet != null) 
            {
                string programName = string.Empty;
                int StationCount = 0;
                DataTable table = dataSet.Tables[0];
                //table = FormatCarriageListByProgramReport(table);
                //DataTable tblProgramName = dataSet.Tables[1];
                //DataTable tblStationCount = dataSet.Tables[2];

				//if (tblProgramName != null && tblProgramName.Rows.Count > 0)
				//{
				//	programName = tblProgramName.Rows[0].Field<string>(0);
				//}

				//if (tblStationCount != null && tblStationCount.Rows.Count > 0)
				//{
				//	StationCount = tblStationCount.Rows[0].Field<int>(0);
				//}

                string monthFrom = new DateTime(model.YearsFrom, int.Parse(model.MonthsFrom), 1)
                                           .ToString("MMM", System.Globalization.CultureInfo.InvariantCulture);
                string monthTo = new DateTime(model.YearsTo, int.Parse(model.MonthsTo), 1)
                                    .ToString("MMM", System.Globalization.CultureInfo.InvariantCulture);

                var timeDuration = monthFrom + "-" + model.YearsFrom + " to " + monthTo + "-" + model.YearsTo + ",";


                switch (model.ReportFormat)
                {
                    case "PDF":

                        ConvertToPdfWithHeader(table, "CARRIAGE LIST", fileName, programName, StationCount, 50, timeDuration);

                        break;
                    case "Excel":
						ConvertToXLSXFormatCalculations(table, fileName, true, -1);
                        //ConvertToXLSXLeadInLeadOut(table, fileName, true, 8, programName, timeDuration);
                        break;
                    case "CSV":
                        ConvertToCSV(table, fileName, true);
                        break;
                }
            }

            //return Json(true, JsonRequestBehavior.AllowGet);
            return null;
            //return View(model);

        }

		#endregion

		#region Raw Data

        public ActionResult RawData()
        {
            var model = new RawDataViewModel();

            return View(model);
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Maintainability", "CA1502:AvoidExcessiveComplexity"), HttpPost]
        public ActionResult RawData(RawDataViewModel model)
        {
            string sHours = model.StartHours;
            string eHours = model.EndingHours;

            if (model.Duration == "Custom" && String.IsNullOrEmpty(sHours) && String.IsNullOrEmpty(eHours))
            {
                ModelState.AddModelError("Station", "Start Hours and Ending Hours fields are required");
                //return View(model);
            }
            else if (model.Duration == "Custom" && String.IsNullOrEmpty(sHours) && (!String.IsNullOrEmpty(eHours)))
            {
                ModelState.AddModelError("Station", "Start Hours field is required");
                //return View(model);
            }
            else if (model.Duration == "Custom" && (!String.IsNullOrEmpty(sHours)) && String.IsNullOrEmpty(eHours))
            {
                ModelState.AddModelError("Station", "End Hour field is required");
                //return View(model);
            }
            else
            {
                ModelState["Station"].Errors.Clear();
            }


            if (model.Duration == "Custom" && (model.DaySun != true && model.DayMon != true && model.DayTue != true && model.DayWed != true && model.DayThu != true && model.DayFri != true && model.DaySat != true))
            {
                ModelState.AddModelError("", "Selection of at least one day is required.");
            }
            // double sh;
            //double eh;
            if ((!String.IsNullOrEmpty(sHours)) && (!String.IsNullOrEmpty(eHours)))
            {
                TimeSpan duration = DateTime.Parse(eHours).Subtract(DateTime.Parse(sHours));
                double d = duration.TotalMinutes;

                if (model.Duration == "Custom" && d <= 0 && (!sHours.Equals("00:00:00", StringComparison.OrdinalIgnoreCase) && !eHours.Equals("00:00:00", StringComparison.OrdinalIgnoreCase)))
                {
                    ModelState.AddModelError("Station", "Start Hour must be earlier than End Hour.");
                    //  return View(model);
                }
            }
            if (model.Station == "One")
            {
                if (String.IsNullOrEmpty(model.StationsList))
                {
                    ModelState.AddModelError("", "Station selection is required.");
                }
            }

            if (ModelState.IsValid)
            {
                string RSunDay = "Y", RMonDay = "Y", RTuesDay = "Y", RWednesDay = "Y", RThursDay = "Y", RFriDay = "Y", RSaturDay = "Y";
                string RStartHours = null, REndHours = null;

                switch (model.Duration)
                {
                    case "18 hours":
                        RStartHours = "6:00:00";
                        REndHours = "23:59:59";
                        break;

                    case "24 hours":
                        RStartHours = "00:00:00";
                        REndHours = "23:59:59";
                        break;

                    case "Custom":
                        RStartHours = model.StartHours;
                        REndHours = model.EndingHours == "00:00:00" ? "23:59:59" : model.EndingHours;
                        RSunDay = model.DaySun ? "Y" : "N";
                        RMonDay = model.DayMon ? "Y" : "N";
                        RTuesDay = model.DayTue ? "Y" : "N";
                        RWednesDay = model.DayWed ? "Y" : "N";
                        RThursDay = model.DayThu ? "Y" : "N";
                        RFriDay = model.DayFri ? "Y" : "N";
                        RSaturDay = model.DaySat ? "Y" : "N";
                        break;
                }

                if (model.MemberStatus == "All")
                {
                    model.MemberStatus = "";
                }

                string fileName = "RawDataReport";

                DataTable dataTable = CRCDataAccess.GetRawDataReport(RStartHours, REndHours, RSunDay, RMonDay, RTuesDay, RWednesDay, RThursDay, RFriDay, RSaturDay, model.Month, model.Year, Convert.ToInt32(model.StationStatus), model.MemberStatus, model.StationsList, model.Band);
				//ConvertToXLSX(dataTable, fileName, true, -1);
                //dataTable = FormatCalculationsReportFormat(dataTable);
				var grid = new GridView();

				if (dataTable != null && dataTable.Rows.Count < 1)
				{
				    DataRow emptyRow = dataTable.NewRow();

				    dataTable.Rows.InsertAt(emptyRow, 0);
				    dataTable.AcceptChanges();

				    grid.DataSource = dataTable;
				    grid.DataBind();
				    GridViewRow row = new GridViewRow(0, 0, DataControlRowType.Header, DataControlRowState.Normal);
				    TableHeaderCell cell = new TableHeaderCell();
				    cell.Text = "There is no record to display.";
				    cell.ColumnSpan = 15;
				    cell.HorizontalAlign = HorizontalAlign.Center;
				    //row.Controls.Add(cell);
				    row.Cells.AddAt(0, cell);
				    grid.FooterRow.Parent.Controls.Add(row);
				}
				else
				{
				    grid.DataSource = dataTable;
				    grid.DataBind();
				}

				grid.DataSource = dataTable;
				grid.DataBind();

				switch (model.FormatType)
				{
					case "PDF":
						ConvertToPDF(grid, fileName);
						break;
					case "Excel":
						//ConvertToExcel(grid, fileName);
						ConvertToXLSXFormatCalculationsRawData(dataTable, fileName, true, -1);
						break;
					case "CSV":
						//ConvertToCSV(dataTable, fileName, true);
						ConvertFormatCalculationsToCSV(dataTable, fileName, true);
						break;
					default:
						//ConvertToXLSX(dataTable, fileName, true, -1);
						//ConvertToExcel(grid, fileName);
						ConvertToXLSXFormatCalculationsRawData(dataTable, fileName, true, -1);
					break;
                }
                return null;
                //return Json(true, JsonRequestBehavior.AllowGet);
            }
            else
            {
                return View(model);
            }
        }

        #endregion

    }
}
