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
        public static DataTable GetStationNotes(long stationId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_StationNotes_Get",
                    new SqlParameter("@StationId", stationId));
            }
        }

        public static DataRow GetStationNote(long stationNoteId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataRowProcedure(
                    "dbo.PSP_StationNote_Get",
                    new SqlParameter("@StationNoteId", stationNoteId));
            }
        }

        public static long SaveStationNote(long? stationNoteId, long stationId, string NoteText, DateTime? disabledDate, long? disabledUserId, long lastUpdatedUserId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteScalarProcedure<long>(
                    "dbo.PSP_StationNote_Save",
                    new SqlParameter("@StationNoteId", stationNoteId),
                    new SqlParameter("@StationId", stationId),
                    new SqlParameter("@NoteText", NoteText),
                    new SqlParameter("@DeletedDate", disabledDate),
                    new SqlParameter("@DeletedUserId", disabledUserId),
                    new SqlParameter("@LastUpdatedUserId", lastUpdatedUserId));
            }
        }

        public static void DeleteStationNote(long stationNoteId, DateTime? deletedDate, long? deletedUserId, DateTime lastUpdatedDate, long lastUpdatedUserId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                sqlHelper.ExecuteNonQueryProcedure(
                    "dbo.PSP_StationNote_Del",
                    new SqlParameter("@StationNoteId", stationNoteId),
                    new SqlParameter("@DeletedDate", deletedDate),
                    new SqlParameter("@DeletedUserId", deletedUserId),
                    new SqlParameter("@LastUpdatedDate", lastUpdatedDate),
                    new SqlParameter("@LastUpdatedUserId", lastUpdatedUserId));
            }
        }

    }
}
