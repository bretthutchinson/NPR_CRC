using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace NPR.CRC.Web.ViewModels.UserAdmin
{
    public class AddEditStationLinkViewModel
    {
        public long UserId { get; set; }

        [Required]
        [DisplayName("Select a Station")]
        [DataType("Station")]
        public long? StationId { get; set; }

        [DisplayName("Primary")]
        public bool PrimaryUserInd { get; set; }

        [DisplayName("Grid Write")]
        public bool GridWritePermissionsInd { get; set; }
    }
}