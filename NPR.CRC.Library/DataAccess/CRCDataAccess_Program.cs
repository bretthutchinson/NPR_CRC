#region Using
using System;
using System.Data;
using System.Data.SqlClient;
using InfoConcepts.Library.DataAccess;
#endregion

namespace NPR.CRC.Library.DataAccess
{
    public static partial class CRCDataAccess
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1024:UsePropertiesWhereAppropriate")]
        public static DataTable GetPrograms()
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure("dbo.PSP_Programs_Get");
            }
        }

        public static DataRow GetProgram(long programId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataRowProcedure(
                    "dbo.PSP_Program_Get",
                    new SqlParameter("@ProgramId", programId));
            }
        }

        public static long SaveProgram(long? programId, string programName, long? programSourceId, long? programFormatTypeId, string programCode, long? carriageTypeId, DateTime? disabledDate, long? disabledUserId, long lastUpdatedUserId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteScalarProcedure<long>(
                    "dbo.PSP_Program_Save",
                    new SqlParameter("@ProgramId", programId),
                    new SqlParameter("@ProgramName", programName),
                    new SqlParameter("@ProgramSourceId", programSourceId),
                    new SqlParameter("@ProgramFormatTypeId", programFormatTypeId),
                    new SqlParameter("@ProgramCode", programCode),
                    new SqlParameter("@CarriageTypeId", carriageTypeId),
                    new SqlParameter("@DisabledDate", disabledDate),
                    new SqlParameter("@DisabledUserId", disabledUserId),
                    new SqlParameter("@LastUpdatedUserId", lastUpdatedUserId));
            }
        }

        public static DataTable GetProgramsByName(string programName, bool startsWithInd)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_ProgramsByName_Get",
                    new SqlParameter("@ProgramName", programName),
                    new SqlParameter("@StartsWithInd", startsWithInd));
            }
        }

        public static DataTable SearchPrograms(long? programId, long? programSourceId, long? programFormatTypeId, long? majorFormatId, string enabled)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_ProgramsSearch_Get",
                    new SqlParameter("@ProgramId", programId),
                    new SqlParameter("@ProgramSourceId", programSourceId),
                    new SqlParameter("@ProgramFormatTypeId", programFormatTypeId),
                    new SqlParameter("@MajorFormatId", majorFormatId),
                    new SqlParameter("@Enabled", enabled));
            }
        }

        public static DataTable GetProgramLineUpReport(long? programId, string monthSpan, int year, string bandSpan, string deletedInd, long? memberStatusId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_ProgramLineUpReport_Get",
                    new SqlParameter("@ProgramId", programId),
                    new SqlParameter("@MonthSpan", monthSpan),
                    new SqlParameter("@Year", year),
                    new SqlParameter("@BandSpan", bandSpan),
                    new SqlParameter("@DeletedInd", deletedInd),
                    new SqlParameter("@MemberStatusId", memberStatusId),
                    new SqlParameter("@DebugInd", 'N'));
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1024:UsePropertiesWhereAppropriate")]
        public static DataTable GetPrograRegularMulticast()
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure("PSP_ProgramRegularMulticast_Get");
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1024:UsePropertiesWhereAppropriate")]
        public static DataTable GetNPRNewscastProgram()
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure("PSP_ProgramMulticast_Get");
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1024:UsePropertiesWhereAppropriate")]
        public static DataTable GetRegularProgram()
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure("PSP_ProgramRegular_Get");
            }
        }

        //public static DataTable GetCarriageListByProgramReport(string programType,string band,string stationEnabled,string memberStatusName, string stationID, string memberStatus, string fromMonth, int fromYear, string toMonth, int toYear)
        //GetCarriageListByProgramReport(model.type,  model.StationEnabled, model.ProgramID, model.MonthsFrom, model.YearsFrom, model.MonthsTo, model.YearsTo);
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", MessageId = "Band"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", MessageId = "City"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", MessageId = "ReportFormat"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", MessageId = "StationEnabled"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", MessageId = "StationId"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", MessageId = "StateId"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", MessageId = "MemberStatus"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", MessageId = "ProgramID")]
        public static DataSet GetCarriageListByProgramReport(string programType, string ProgramEnabled, string ProgramID, string fromMonth, int fromYear, string toMonth, int toYear, string ReportFormat, string Band, string StationEnabled, string MemberStatus, string StationId, string City, string StateId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataSetProcedure("dbo.PSP_CarriageListByProgramReport_GET",
                    //new SqlParameter("@ProgramType", programType),
                    //new SqlParameter("@StationEnabled", ProgramEnabled),
                    //new SqlParameter("@FromMonth", fromMonth),
                    //new SqlParameter("@FromYear", fromYear),
                    //new SqlParameter("@ToMonth", toMonth),
                    //new SqlParameter("@ToYear", toYear),
                    //new SqlParameter("@BandSpan", ""),
                    //new SqlParameter("@MemberStatusName", ""),
                    //new SqlParameter("@Station", ""),
                    //new SqlParameter("@MemStatus", "")

                     new SqlParameter("@programType", programType),
                     new SqlParameter("@ProgramEnabled", ProgramEnabled),
                     new SqlParameter("@ProgramID", ProgramID),
                     new SqlParameter("@fromMonth", fromMonth),
                     new SqlParameter("@fromYear", fromYear),
                     new SqlParameter("@toMonth", toMonth),
                     new SqlParameter("@toYear", toYear),
                     new SqlParameter("@ReportFormat", ReportFormat),


                     new SqlParameter("@Band", Band),
                     new SqlParameter("@StationEnabled", StationEnabled),
                     new SqlParameter("@MemberStatusId", MemberStatus),
                     new SqlParameter("@StationId", StationId),
                     new SqlParameter("@City", City),
                     new SqlParameter("@StateId", StateId)

                    );
            }
        }




		[System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", MessageId = "day"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", MessageId = "time"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", MessageId = "Band"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", MessageId = "City"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", MessageId = "ReportFormat"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", MessageId = "StationEnabled"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", MessageId = "StationId"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", MessageId = "StateId"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", MessageId = "MemberStatus"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", MessageId = "ProgramID")]
		public static DataSet GetLeadInLeadOutReport(string programType, string ProgramEnabled, string ProgramID, string fromMonth, int fromYear, string toMonth, int toYear, string ReportFormat, string Band, string StationEnabled, string MemberStatus, string StationId, string City, string StateId,string day, string StartTime, string EndTime)
		{
			using (var sqlHelper = new InfSqlHelper())
			{
				return sqlHelper.ExecuteDataSetProcedure("dbo.PSP_LeadInLeadOutReport_GET",
					

					 new SqlParameter("@programType", programType),
					 new SqlParameter("@ProgramEnabled", ProgramEnabled),
					 new SqlParameter("@ProgramID", ProgramID),
					 new SqlParameter("@fromMonth", fromMonth),
					 new SqlParameter("@fromYear", fromYear),
					 new SqlParameter("@toMonth", toMonth),
					 new SqlParameter("@toYear", toYear),
					 new SqlParameter("@ReportFormat", ReportFormat),


					 new SqlParameter("@Band", Band),
					 new SqlParameter("@StationEnabled", StationEnabled),
					 new SqlParameter("@MemberStatusId", MemberStatus),
					 new SqlParameter("@StationId", StationId),
					 new SqlParameter("@City", City),
					 new SqlParameter("@StateId", StateId),

					 new SqlParameter("@Day", day),
					 new SqlParameter("@StartTime", StartTime),
					 new SqlParameter("@EndTime", EndTime)
					);
			}
		}

		[System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", MessageId = "Band"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", MessageId = "City"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", MessageId = "ReportFormat"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", MessageId = "StationEnabled"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", MessageId = "StationId"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", MessageId = "StateId"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", MessageId = "MemberStatus"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", MessageId = "ProgramID")]
        public static DataTable GetRawDataReport(string StartTime, string EndTime, string SundayInd, string MondayInd, string TuesdayInd, string WednesdayInd, string ThursdayInd, string FridayInd, string SaturdayInd, int Month, int Year, int RepeaterStatus, string MemberStatus, string StationId,string Band)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_RawFormatDataReport_Get",
                    new SqlParameter("@StartTime", StartTime),
                    new SqlParameter("@EndTime", EndTime),
                    new SqlParameter("@SundayInd", SundayInd),
                    new SqlParameter("@MondayInd", MondayInd),
                    new SqlParameter("@TuesdayInd", TuesdayInd),
                    new SqlParameter("@WednesdayInd", WednesdayInd),
                    new SqlParameter("@ThursdayInd", ThursdayInd),
                    new SqlParameter("@FridayInd", FridayInd),
                    new SqlParameter("@SaturdayInd", SaturdayInd),
                    new SqlParameter("@Month", Month),
                    new SqlParameter("@Year", Year),
                    new SqlParameter("@RepeaterStatusId", RepeaterStatus),
                    new SqlParameter("@MemberStatusId", MemberStatus),
                    new SqlParameter("@StationId", StationId),
                    new SqlParameter("@Band", Band),
                    new SqlParameter("@DebugInd", "N"));
            }
        }


        public static DataTable GetStationDataReport(string stationEnabled, string bandSpan,string repeaterStatus)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_StationDataReport_GET",
                    new SqlParameter("@StationEnabled", stationEnabled),
                    new SqlParameter("@BandSpan", bandSpan),
                    new SqlParameter("@RepeaterStatus", repeaterStatus));
            }
        }
        public static DataTable GetRepeaterStationReport(string stationEnabled, string bandSpan)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_RepeaterStationReport_GET",
                    new SqlParameter("@StationEnabled", stationEnabled),
                    new SqlParameter("@BandSpan", bandSpan));
            }
        }
        public static DataTable Get_CallLetters(long? StationId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_CallLetters_Get",
                    new SqlParameter("@StationId", StationId));
                    
            }
        }
  
      

        public static DataTable GetStationList(string band,string stationEnabled,string memberStatus)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_StationListAsMemberBand_Get",
                    new SqlParameter("@BandSpan", band),
                    new SqlParameter("@StationEnabled", stationEnabled),
                    new SqlParameter("@MemberStatusId", memberStatus));
                   
            }
        }


		public static DataTable GetStationList_LILO(string band,string stationEnabled,string memberStatus)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_StationListAsMemberBand_LILO_Get",
                    new SqlParameter("@BandSpan", band),
                    new SqlParameter("@StationEnabled", stationEnabled),
                    new SqlParameter("@MemberStatusId", memberStatus));
                   
            }
        }

        
        public static DataTable GetFormatCalculationReport(string StartTime, string EndTime, string SundayInd, string MondayInd, string TuesdayInd, string WednesdayInd, string ThursdayInd, string FridayInd, string SaturdayInd, int Month, int Year, int RepeaterStatus, string MemberStatus, string StationId,string Band)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_FormatCalculationReport_Get",
                    new SqlParameter("@StartTime", StartTime),
                    new SqlParameter("@EndTime", EndTime),
                    new SqlParameter("@SundayInd", SundayInd),
                    new SqlParameter("@MondayInd", MondayInd),
                    new SqlParameter("@TuesdayInd", TuesdayInd),
                    new SqlParameter("@WednesdayInd", WednesdayInd),
                    new SqlParameter("@ThursdayInd", ThursdayInd),
                    new SqlParameter("@FridayInd", FridayInd),
                    new SqlParameter("@SaturdayInd", SaturdayInd),
                    new SqlParameter("@Month", Month),
                    new SqlParameter("@Year", Year),
                    new SqlParameter("@RepeaterStatusId", RepeaterStatus),
                    new SqlParameter("@MemberStatusId", MemberStatus),
                    new SqlParameter("@StationId", StationId),
                    new SqlParameter("@Band", Band),
                    new SqlParameter("@DebugInd", "N"));
            }
        }
        public static DataTable GetParticipatingStationReport(string currentSeason, int currentYear, string pastSeason, int pastYear, string band, string format)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_ParticipatingStationReport_Get",
                    new SqlParameter("@CurrentSeason", currentSeason),
                    new SqlParameter("@CurrentYear", currentYear),
                    new SqlParameter("@PastSeason", pastSeason),
                    new SqlParameter("@PastYear", pastYear),
                    new SqlParameter("@Band", band),
                    new SqlParameter("@Format", format)
                   );
            }
        }

        public static DataTable GetProgramStationReport(string currentSeason, int currentYear, string pastSeason, int pastYear, string band, string format)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_ProgramStationReport_Get",
                    new SqlParameter("@CurrentSeason", currentSeason),
                    new SqlParameter("@CurrentYear", currentYear),
                    new SqlParameter("@PastSeason", pastSeason),
                    new SqlParameter("@PastYear", pastYear),
                    new SqlParameter("@Band", band),
                    new SqlParameter("@Format", format)
                   );
            }
        }  
        


        public static DataTable GetCarriageListByStationReport(string progType, string stationID, string bandID, string stationStatus, string memberStatus, string fromMonth, int fromYear, string toMonth, int toYear)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_CarriageListBystationReport_Get",
                    new SqlParameter("@ProgramType", progType),
                    new SqlParameter("@Station", stationID),
                    new SqlParameter("@Band", bandID),
                    new SqlParameter("@StationStatus", stationStatus),
                    new SqlParameter("@MemStatus", memberStatus),
                    new SqlParameter("@FromMonth", fromMonth),
                    new SqlParameter("@FromYear", fromYear),
                    new SqlParameter("@ToMonth", toMonth),
                    new SqlParameter("@ToYear", toYear)
                   );
            }
        }

        public static DataTable GetAddDropProgramReport(string stationType, string stationStatus, string repeaterStatus, string program, string currentSeason, int currentYear, string pastSeason, int pastYear, string format)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_AddDropProgramReport_Get",
                    new SqlParameter("@StationType", stationType),
                    new SqlParameter("@StationStatus", stationStatus),
                    new SqlParameter("@RepeaterStatus", repeaterStatus),
                    new SqlParameter("@Program", program),
                    new SqlParameter("@CurrentSeason", currentSeason),
                    new SqlParameter("@CurrentYear", currentYear),
                    new SqlParameter("@PastSeason", pastSeason),
                    new SqlParameter("@PastYear", pastYear),
                    new SqlParameter("@Format", format)
                   );
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1024:UsePropertiesWhereAppropriate")]
        public static DataTable GetProgramLookup()
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                   "dbo.PSP_ProgramLookup_Get");
            }
        }

		public static DataTable GetProgramLookup_ED(string enabled)
        {
			//using (var sqlHelper = new InfSqlHelper())
			//{
			//	return sqlHelper.ExecuteDataTableProcedure(
			//	   "dbo.PSP_ProgramLookupED_Get",
			//	   new SqlParameter("@EnabledInd", enabled));

			//}

			using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                 //"dbo.PSP_ProgramLookup_Get");
				"dbo.PSP_ProgramLookupED_Get",
				new SqlParameter("@EnabledInd", enabled));

            }
        }


        public static bool ValidateProgramCodeIsUnique(long? programId,string programCode)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                var isUnique = sqlHelper.ExecuteScalarProcedure<string>(
                    "dbo.PSP_ProgramCodeIsUnique_Get",
                    new SqlParameter("@ProgramId", programId),
                    new SqlParameter("@ProgramCode", programCode));

                return isUnique.Equals("Y", StringComparison.OrdinalIgnoreCase);
            }
        }
    }
}
