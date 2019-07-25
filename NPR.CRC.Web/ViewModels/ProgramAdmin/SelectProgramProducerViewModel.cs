using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using NPR.CRC.Library.DataAccess;
using InfoConcepts.Library.Extensions;

namespace NPR.CRC.Web.ViewModels.ProgramAdmin
{
    public class SelectProgramProducerViewModel
    {
        public long ProgramId { get; set; }

        [Required]
        [DisplayName("Select a Producer Contact")]
        public long? ProducerId { get; set; }

        public IEnumerable<SelectListItem> ProducerList { get; private set; }

        public SelectProgramProducerViewModel()
        {
            ProducerList = CRCDataAccess.GetProducersList().ToSelectListItems().OrderBy(li => li.Text).AddBlankFirstItem();
        }
    }
}