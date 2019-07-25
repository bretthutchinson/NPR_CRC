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

namespace NPR.CRC.Web.NPRSupportFile
{
    public static class NPRReport
    {

        public static DataTable GetReportTable(DataTable dataTable)
        {

            DataTable RTable = new DataTable();
            //DataTable table=new DataTable();		
            RTable.Columns.Add("Station", typeof(String));
            RTable.Columns.Add("Abbreviation", typeof(String));
            RTable.Columns.Add("City", typeof(String));
            RTable.Columns.Add("Member", typeof(String));
            RTable.Columns.Add("Metro", typeof(String));
            RTable.Columns.Add("DMA", typeof(String));
            RTable.Columns.Add("Cls", typeof(String));
            RTable.Columns.Add("ELC", typeof(String));
            RTable.Columns.Add("JZZ", typeof(String));
            RTable.Columns.Add("NWS", typeof(String));
            RTable.Columns.Add("POP", typeof(String));
            /* table.Columns.Add("TRG", typeof(String));
             table.Columns.Add("WLD", typeof(String));
             table.Columns.Add("Total", typeof(String));
             table.Columns.Add("ExtendedFormat", typeof(String));*/

            //    DataTable dataTable = CRCDataAccess.GetFormatCalculationReport(RStartHours, REndHours, RSunDay, RMonDay, RTuesDay, RWednesDay, RThursDay, RFriDay, RSaturDay, model.Month, model.Year, Convert.ToInt32(model.StationStatus), model.MemberStatus, Convert.ToInt32(model.StationsList));

            int temp1 = 0;

            DataSet ds = new DataSet();
            ds.Tables.Add(dataTable);

            int row = ds.Tables[0].Rows.Count;
            int col = ds.Tables[0].Columns.Count;

            for (int x = 0; x < row; x++)
            {
                DataRow r = RTable.NewRow();
                RTable.Rows.Add(r);
                int temp2 = x;
                for (int y = 0; y < RTable.Columns.Count; y++)
                {
                    if (y > col - 1)
                    {
                        if (temp2++ < row - 1)
                        {

                            string dataSetValue = ds.Tables[0].Rows[temp2][0].ToString();
                            string RValue = RTable.Rows[temp1][0].ToString();

                            if (dataSetValue == RValue)
                            {
                                x++;
                                string value = ds.Tables[0].Rows[x][7] + " %";
                                RTable.Rows[temp1][y] = value;
                            }
                        }
                    }
                    else
                    {
                        if (y > 5)
                        {
                            string dataSetValue = ds.Tables[0].Rows[x][y].ToString() + "%";
                            RTable.Rows[temp1][y] = dataSetValue;
                        }
                        else
                        {
                            RTable.Rows[temp1][y] = ds.Tables[0].Rows[x][y];
                        }
                    }

                }

                temp1++;
            }

            return RTable;

        }

        public static void ChangeIntoKeyPair(DataTable table)
        {

            DataSet ds = new DataSet();

            ds.Tables.Add(table);

            int row = ds.Tables[0].Rows.Count;
            int col = ds.Tables[0].Columns.Count;


            Dictionary<string, int> Station = new Dictionary<string, int>();
            string key;
            int sum_value = 0;
            for (int x = 0; x < row; x++)
            {
                key = "";
                sum_value = 0;
                for (int y = 0; y < col; y++)
                {

                    if (y < col - 1)
                    {
                        key += ds.Tables[0].Rows[x][y].ToString() + "_";
                    }
                    else
                    {
                        sum_value = Convert.ToInt32(ds.Tables[0].Rows[x][y]);

                    }

                }

                Station.Add(key, sum_value);
            }
        }
        public static DataTable Change_DataTable(DataTable table)
        {

            DataTable RTable = new DataTable();

            RTable.Columns.Add("Program Name", typeof(String));
            RTable.Columns.Add("Program Source", typeof(String));
            RTable.Columns.Add("Program Format Type", typeof(String));
            RTable.Columns.Add("Major Format", typeof(String));
            RTable.Columns.Add("Broadcast Time Day(s)", typeof(String));
            RTable.Columns.Add("Start", typeof(String));
            RTable.Columns.Add("End", typeof(String));

            DataSet ds = new DataSet();
            ds.Tables.Add(table);

            int row = ds.Tables[0].Rows.Count;
            int col = ds.Tables[0].Columns.Count;


            

            String Days = "";

            int tempRow = 0;
            int tempCol = 0;

            for (int x = 0; x < row; x++)
            {
                DataRow r = RTable.NewRow();

                RTable.Rows.Add(r);
                tempCol = 0;
                Days = "";


                for (int y = 0; y < col; y++)
                {

                    if (y > 3 && y <= 10)
                    {
                        int[] dayArray = new int[7];
                        int dayArrayIndex = 0;
                        
                        while (y <= 10)
                        {
                            char dayInd =Convert.ToChar(ds.Tables[0].Rows[x][y]);
                            if (dayInd == 'Y')
                            {
                                dayArray[dayArrayIndex] = 1;
                            }
                            else
                            {
                                dayArray[dayArrayIndex] = 0;
                            }

                            dayArrayIndex++;
                            y++;
                        }

                        Days = ChangeDaysFormatSequence(dayArray);
                        RTable.Rows[tempRow][tempCol++] = Days;
                        y--;
                    }
                    else
                    {
                        RTable.Rows[tempRow][tempCol++] = ds.Tables[0].Rows[x][y];

                    }
                }

                tempRow++;
            }

            return RTable;

        }

        public static DataTable getCallLetters_Flagship(DataTable Table)
        {

            DataTable RTable = new DataTable();

            RTable.Columns.Add("Flagship", typeof(String));
            RTable.Columns.Add("Repeater Station", typeof(String));
            RTable.Columns.Add("State", typeof(String));
            RTable.Columns.Add("City", typeof(String));
            RTable.Columns.Add("Freq", typeof(String));
            RTable.Columns.Add("Member Status", typeof(String));
            RTable.Columns.Add("Metro", typeof(String));
            RTable.Columns.Add("DMA", typeof(String));

            DataSet RDataSet = new DataSet();

            RDataSet.Tables.Add(Table);

            int row = RDataSet.Tables[0].Rows.Count;
            int col = RDataSet.Tables[0].Columns.Count;
            string FlagshipStation = "";

            for (int x = 0; x < row; x++)
            {

                DataRow r = RTable.NewRow();
                RTable.Rows.Add(r);
                for (int y = 0; y < col; y++)
                {

                    if (y == 0)
                    {
                        //string temp = (RDataSet.Tables[0].Rows[x][y].ToString());
                        long? StationId =((RDataSet.Tables[0].Rows[x][y]) as long?);
                        if (StationId.HasValue)
                        {

                            DataTable tempDataTable = CRCDataAccess.Get_CallLetters(StationId);
                            DataSet tempDataset = new DataSet();
                            tempDataset.Tables.Add(tempDataTable);
                            FlagshipStation = tempDataset.Tables[0].Rows[0][0].ToString();
                            //FlagshipStation = CRCDataAccess.Get_CallLetters(StationId);
                            RTable.Rows[x][y] = FlagshipStation;
                            FlagshipStation = "";
                        }
                        else
                        {
                            RTable.Rows[x][y] = FlagshipStation;
                        }
                    }
                    else
                    {
                        RTable.Rows[x][y] = RDataSet.Tables[0].Rows[x][y];
                    }
                }
            }

            return RTable;
        }



        public static string ChangeDaysFormatSequence(int[] days)
        {

            String[] daysName = new String[] { "SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT" };
            int seqMin = -1;
            int seqMax = -1;
            bool changed = false;
            String unSeq = days[0] == 1 ? "SUN" : "";
            for (int i = 1; i < days.Length - 1; i++)
            {
                bool prev = days[i - 1] == 1;
                bool current = days[i] == 1;
                bool next = days[i + 1] == 1;
                if ((seqMin != -1 || prev) && !current && next)
                {
                    seqMin = -1;
                    seqMax = -1;
                    changed = true;
                }
                if (!changed)
                {
                    if (seqMin == -1)
                    {
                        seqMin = prev ? i - 1 : current ? i : next ? i + 1 : -1;
                    }
                    seqMax = prev ? i - 1 : seqMax;
                    seqMax = current ? i : seqMax;
                    seqMax = next ? i + 1 : seqMax;
                }
                if (current)
                {
                    unSeq = unSeq + (unSeq.Length == 0 ? daysName[i] : ", " + daysName[i]);
                }
            }
            unSeq = unSeq + (days[6] == 1 ? unSeq.Length == 0 ? "SAT" : ", SAT" : "");
            String result = "";
            if (!changed && seqMin != -1)
            {
                result = seqMin == seqMax ? daysName[seqMin] : daysName[seqMin] + "-" + daysName[seqMax];
            }
            else
            {
                result = unSeq;
            }
            //System.out.println("Result :" + result);

            return result;
        }



        /*  [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1024:UsePropertiesWhereAppropriate")]
         public static void TestOperation(DataTable table, Dictionary<string, int> Regular_Dictionary, Dictionary<string, int> OffAir_Dictionary)
         {
             Dictionary<int, string> HeaderList = new Dictionary<int, string>();
            
             HeaderList.Add(7, "ELC");
             HeaderList.Add(8, "ENT");
             HeaderList.Add(9, "FLK");
             HeaderList.Add(10, "JZZ");
             HeaderList.Add(11, "NWS");
             HeaderList.Add(12, "POP");
             HeaderList.Add(13, "TRG");
             HeaderList.Add(14, "WLD");
             HeaderList.Add(15, "TOTAL");
             HeaderList.Add(16, "Extended Format");

             DataTable RTable = new DataTable();
             RTable.Columns.Add("Station", typeof(String));
             RTable.Columns.Add("Abbreviation", typeof(String));
             RTable.Columns.Add("City", typeof(String));
             RTable.Columns.Add("Member", typeof(String));
             RTable.Columns.Add("Metro", typeof(String));
             RTable.Columns.Add("DMA", typeof(String));
             RTable.Columns.Add("Cls", typeof(String));
             RTable.Columns.Add("ELC", typeof(String), "0%");
             RTable.Columns.Add("JZZ", typeof(String), "0%");
             RTable.Columns.Add("NWS", typeof(String), "0%");
             RTable.Columns.Add("POP", typeof(String), "0%");
             RTable.Columns.Add("TRG", typeof(String), "0%");
             RTable.Columns.Add("WLD", typeof(String), "0%");
             RTable.Columns.Add("Total", typeof(String), "0%");
             RTable.Columns.Add("ExtendedFormat", typeof(String));
            

             DataSet ds = new DataSet();
             ds.Tables.Add(table);

             int row = ds.Tables[0].Rows.Count;
             int col = ds.Tables[0].Columns.Count;
             string MajorFormatCode = "";
             int TotalMajorFormat = 0;
             string key = "";
             int temp1 = 0;
             double Total_Regular;
             double Total_OffAir;
             for (int x = 0; x < row; x++)
             {
                 key = "";
                 DataRow r = RTable.NewRow();
                 RTable.Rows.Add(r);
                 int temp2 = x;

                 for (int y = 0; y < RTable.Columns.Count; y++)
                 {
                     if (y >= col - 1)
                     {

                         if (y == 7)
                         {
                             if (Regular_Dictionary.ContainsKey(key))
                             {
                                 Total_Regular = Convert.ToDouble(Regular_Dictionary[key]);
                                 if (OffAir_Dictionary.ContainsKey(key))
                                 {
                                     Total_OffAir = Convert.ToDouble(OffAir_Dictionary[key]);
                                 }
                             }

                             MajorFormatCode = ds.Tables[0].Rows[x][7].ToString();
                             if (HeaderList.ContainsValue(MajorFormatCode))
                             {

                                 int MajorFormatIndex = HeaderList.FirstOrDefault(xx => xx.Value != null && xx.Value.Contains(MajorFormatCode)).key;
                                 double Calculation = Convert.ToDouble(TotalMajorFormat / (Total_Regular - Total_OffAir));

                                 string Calculation_Format = Calculation.ToString() + "%";
                                 RTable.Rows[temp1][MajorFormatIndex] = Calculation_Format;

                             }
                         }
                         else
                         {
                             if (temp2++ < row - 1)
                             {
                                 string dataSetValue = ds.Tables[0].Rows[temp2][0].ToString();
                                 string RValue = RTable.Rows[temp1][0].ToString();

                                 if (dataSetValue == RValue && ds.Tables[0].Rows[temp2][1].ToString() == RTable.Rows[temp1][1].ToString() && ds.Tables[0].Rows[temp2][2].ToString() == RTable.Rows[temp1][2].ToString() && ds.Tables[0].Rows[temp2][3].ToString() == RTable.Rows[temp1][3].ToString() && ds.Tables[0].Rows[temp2][4].ToString() == RTable.Rows[temp1][4].ToString() && ds.Tables[0].Rows[temp2][5].ToString() == RTable.Rows[temp1][5].ToString())
                                 {
                                     x++;
                                     // string value = ds.Tables[0].Rows[x][7] + " %";
                                     //RTable.Rows[temp1][y] = value;

                                     if (Regular_Dictionary.ContainsKey(key))
                                     {
                                         Total_Regular = Convert.ToDouble(Regular_Dictionary[key]);
                                         if (OffAir_Dictionary.ContainsKey(key))
                                         {
                                             Total_OffAir = Convert.ToDouble(OffAir_Dictionary[key]);
                                         }
                                     }

                                     MajorFormatCode = ds.Tables[0].Rows[x][7].ToString();
                                     if (HeaderList.ContainsValue(MajorFormatCode))
                                     {
                                         int MajorFormatIndex = HeaderList.FirstOrDefault(xx => xx.Value != null && xx.Value.Contains(MajorFormatCode)).key;
                                         double Calculation = Convert.ToDouble(TotalMajorFormat / (Total_Regular - Total_OffAir));

                                         string Calculation_Format = Calculation.ToString() + "%";
                                         RTable.Rows[temp1][MajorFormatIndex] = Calculation_Format;
                                     }
                                 }
                             }
                         }
                     }
                     else
                     {
                         if (y == 6)
                         {
                             string dataSetValue = ds.Tables[0].Rows[x][y].ToString();
                             RTable.Rows[temp1][y] = dataSetValue + "%";
                             TotalMajorFormat = Convert.ToInt32(dataSetValue);
                         }
                         else
                         {
                             key += ds.Tables[0].Rows[x][y] + "_";
                             RTable.Rows[temp1][y] = ds.Tables[0].Rows[x][y];
                         }
                     }
                 }

                 temp1++;
             }

         }*/


    }
}