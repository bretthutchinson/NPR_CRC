using iTextSharp.text;
using iTextSharp.text.pdf;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace NPR.CRC.Web
{
    public class ITextPdfEvents : PdfPageEventHelper
    {
        #region ==========[ Private Variables ]==========
        //PdfContentByte contentByte;
        #endregion

        #region ==========[ Properties ]==========

        public Image ImageHeader { get; set; }
        public string ProgramName { get; set; }
        public string ReportTitle { get; set; }
       // public int TotalRecords { get; set; }
        public int TotalPages { get; set; }
        public int CurrentPage { get; set; }
        public string TimeDuration { get; set; }
        public bool ShowTotalStationFooter { get; set; }

        #endregion

        #region ==========[ Events ]==========

        public override void OnEndPage(iTextSharp.text.pdf.PdfWriter writer, iTextSharp.text.Document document)
        {
            base.OnEndPage(writer, document);
           // contentByte = writer.DirectContent;

            PdfPTable pdfTab = new PdfPTable(6);

            int[] widths = new int[] { 20, 5, 10, 10, 10, 10 };
            pdfTab.SetWidths(widths);
            pdfTab.WidthPercentage = 100;

            //Row 1
            PdfPCell pdfCellTitle = new PdfPCell(new Phrase(
                                             ReportTitle,
                                             new Font(Font.BOLD, 12, 1)
                                            ));
            PdfPCell pdfCellLogo = new PdfPCell(ImageHeader, true);
            PdfPCell pdfCellProgramName = new PdfPCell(new Phrase(ProgramName, new Font(Font.ITALIC, 12, 1)));

            PdfPCell emptyPdfCell1 = new PdfPCell();
            PdfPCell emptyPdfCell2 = new PdfPCell();
            PdfPCell emptyPdfCell3 = new PdfPCell();
            PdfPCell emptyPdfCell4 = new PdfPCell();


            //set the alignment of all cells  
            pdfCellTitle.HorizontalAlignment = Element.ALIGN_LEFT;
            pdfCellLogo.HorizontalAlignment = Element.ALIGN_RIGHT;
            pdfCellProgramName.HorizontalAlignment = Element.ALIGN_CENTER;

            emptyPdfCell1.HorizontalAlignment = Element.ALIGN_CENTER;
            emptyPdfCell2.HorizontalAlignment = Element.ALIGN_CENTER;
            emptyPdfCell3.HorizontalAlignment = Element.ALIGN_CENTER;
            emptyPdfCell4.HorizontalAlignment = Element.ALIGN_CENTER;


            pdfCellLogo.VerticalAlignment = Element.ALIGN_TOP;
            pdfCellProgramName.VerticalAlignment = Element.ALIGN_TOP;

            emptyPdfCell1.VerticalAlignment = Element.ALIGN_BOTTOM;
            emptyPdfCell2.VerticalAlignment = Element.ALIGN_TOP;
            emptyPdfCell3.VerticalAlignment = Element.ALIGN_TOP;
            emptyPdfCell4.VerticalAlignment = Element.ALIGN_TOP;

            //set border of all cells
            pdfCellTitle.Border = 0;
            pdfCellLogo.Border = 0;
            pdfCellProgramName.Border = 0;

            emptyPdfCell1.Border = 0;
            emptyPdfCell2.Border = 0;
            emptyPdfCell3.Border = 0;
            emptyPdfCell4.Border = 0;

            //span column for program name
            pdfCellProgramName.Colspan = 6;

            //add all three cells into PdfTable
            pdfTab.AddCell(pdfCellTitle);

            pdfTab.AddCell(emptyPdfCell1);
            pdfTab.AddCell(emptyPdfCell2);
            pdfTab.AddCell(emptyPdfCell3);
            pdfTab.AddCell(emptyPdfCell4);

            pdfTab.AddCell(pdfCellLogo);
            pdfTab.AddCell(pdfCellProgramName);

            pdfTab.TotalWidth = document.PageSize.Width - 80f;
            pdfTab.WidthPercentage = 70;

            pdfTab.WriteSelectedRows(0, -1, 40, document.PageSize.Height - 30, writer.DirectContent);

            //------------- set pdf footer ---------------//

            PdfPTable footerTab = new PdfPTable(1);
            footerTab.WidthPercentage = 100;

            //PdfPCell cellFooterTab = new PdfPCell(new Phrase(
            //                                 "Total Stations : " + TotalRecords,
            //                                 new Font(Font.ITALIC, 13, 2)
            //                                ));
            //cellFooterTab.BackgroundColor = new iTextSharp.text.Color(204, 204, 204);
            //cellFooterTab.HorizontalAlignment = Element.ALIGN_CENTER;
            //cellFooterTab.VerticalAlignment = Element.ALIGN_CENTER;

            //footerTab.AddCell(cellFooterTab);
            //footerTab.TotalWidth = document.PageSize.Width - 80f;

            //if (ShowTotalStationFooter)
            //{
            //    footerTab.WriteSelectedRows(0, 1, 40, 65, writer.DirectContent);
            //}

            // draw line into button of report
            //contentByte.MoveTo(20, document.PageSize.GetBottom(30));
            //contentByte.LineTo(document.PageSize.Width - 20, document.PageSize.GetBottom(30));
            //contentByte.Stroke();

            // add source info into footer
            PdfPCell cellSourceFooterTab = new PdfPCell(new Phrase(
                                             "Source : NPR Carriage Report Center, " + TimeDuration + " Page " + CurrentPage + " of " + TotalPages,
                                             new Font(Font.ITALIC, 8, 2)
                                            ));

            cellSourceFooterTab.HorizontalAlignment = Element.ALIGN_CENTER;
            cellSourceFooterTab.VerticalAlignment = Element.ALIGN_CENTER;
            cellSourceFooterTab.Border = 0;

            footerTab.AddCell(cellSourceFooterTab);
            footerTab.TotalWidth = document.PageSize.Width - 80f;
            footerTab.WriteSelectedRows(0, -1, 40, 20, writer.DirectContent);
        }

        #endregion
    }
}