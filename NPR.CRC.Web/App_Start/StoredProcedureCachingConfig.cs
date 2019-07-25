using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using InfoConcepts.Library.DataAccess;

namespace NPR.CRC.Web
{
    public static class StoredProcedureCachingConfig
    {
        public static void RegisterStoredProceduresToCache()
        {
            // define here the list of stored procedures whose results should be cached, and for how long
            InfSqlHelper.StoredProceduresToCache["dbo.PSP_CRCUserByEmail_Get"] = TimeSpan.FromSeconds(60);
           // InfSqlHelper.StoredProceduresToCache["dbo.PSP_StationsForUserId_Get"] = TimeSpan.FromSeconds(60);
            InfSqlHelper.StoredProceduresToCache["dbo.PSP_CRCManager_Get"] = TimeSpan.FromSeconds(60);
            
            // stored procedures called by the InfoConcepts library
            InfSqlHelper.StoredProceduresToCache["dbo.PSP_InfTextContentAll_Get"] = TimeSpan.FromSeconds(60);
            InfSqlHelper.StoredProceduresToCache["dbo.PSP_InfTextContentByName_Get"] = TimeSpan.FromSeconds(60);
            InfSqlHelper.StoredProceduresToCache["dbo.PSP_InfLookupList_Get"] = TimeSpan.FromSeconds(60);
            InfSqlHelper.StoredProceduresToCache["dbo.PSP_InfLookupById_Get"] = TimeSpan.FromSeconds(60);
            InfSqlHelper.StoredProceduresToCache["dbo.PSP_InfReverseLookup_Get"] = TimeSpan.FromSeconds(60);

            InfSqlHelper.SafeStoredProcedures.Add("dbo.PSP_Program_Save");
        }
    }
}