using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using InfoConcepts.Library.Web.Mvc;
using NPR.CRC.Library.DataAccess;
using InfoConcepts.Library.Extensions;

namespace NPR.CRC.Web.ViewModels.StationAdmin
{
    public class AddEditStationNoteViewModel
    {
        public long? StationNoteId { get; set; }

        public long StationId { get; set; }

        [DisplayName("Station")]
        public string CallLetters { get; set; }

        [Required]
        [DisplayName("Note")]
        public string NoteText { get; set; }

        public AddEditStationNoteViewModel() { }

    }
}