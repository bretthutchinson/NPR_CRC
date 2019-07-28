using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;
using NPR.CRC.Library;
using NPR.CRC.Library.DataAccess;
using NPR.CRC.Web.ViewModels.Home;
using InfoConcepts.Library.Email;
using System.Globalization;
using System.Net.Mail;

namespace NPR.CRC.Web.Controllers
{
    public class HomeController : BaseController
    {
       // string userEmail = "checkMail";
       //GIT_X7
        public ActionResult Index()
        {
            if (User.Identity.IsAuthenticated)
            {
                return RedirectToAction("Index", "Schedules");
            }

            return RedirectToAction("SignIn");
        }

        public ActionResult SignIn()
        {
            var viewModel = new SignInViewModel();

            var drCRCManager = CRCDataAccess.GetCRCManager();
            if (drCRCManager != null)
            {
                viewModel.CRCManagerEmail = drCRCManager["Email"].ToString();
                viewModel.CRCManagerPhone = drCRCManager["Phone"].ToString();
            }

            return View(viewModel);
        }

        [HttpPost]
        public ActionResult SignIn(SignInViewModel viewModel)
        {
            var drUser = CRCDataAccess.GetCRCUserByLogin(viewModel.Email, viewModel.Password);
            
            if (drUser != null)
            {
                
                Session["useremail"] = viewModel.Email;
                var authTicket = new FormsAuthenticationTicket(1, drUser["Email"].ToString(), DateTime.Now, DateTime.Now.AddDays(1), true, string.Empty);
                var encryptedAuthTicket = FormsAuthentication.Encrypt(authTicket);
                var authCookie = new HttpCookie(FormsAuthentication.FormsCookieName, encryptedAuthTicket);
                Response.Cookies.Add(authCookie);

                return RedirectToAction("Index");
            }

            return View(viewModel);
        }

        public ActionResult SignOut()
        {
            return SignOutResult("Index");
        }

        public ActionResult ForgotPassword()
        {
            var viewModel = new ForgotPasswordViewModel();
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult ForgotPassword(ForgotPasswordViewModel viewModel)
        {
            if (ModelState.IsValid)
            {
                var drResetPassword = CRCDataAccess.SaveCRCUserPasswordReset(viewModel.Email, null);
                if (drResetPassword != null)
                {
                    InfEmail.AddToQueue(
                        "Reset Password",
                        new
                        {
                            ResetPasswordLink = string.Format(CultureInfo.InvariantCulture, "{0}?token={1}", Url.Action("ResetPassword", "Home", null, Request.Url.Scheme), drResetPassword["Token"].ToString()),
                            CRCUserFirstName = drResetPassword["CRCUserFirstName"].ToString(),
                            CRCUserLastName = drResetPassword["CRCUserLastName"].ToString(),
                            CRCUserEmail = drResetPassword["CRCUserEmail"].ToString(),
                            CRCManagerFirstName = drResetPassword["CRCManagerFirstName"].ToString(),
                            CRCManagerLastName = drResetPassword["CRCManagerLastName"].ToString(),
                            CRCManagerEmail = drResetPassword["CRCManagerEmail"].ToString(),
                            CRCManagerPhone = drResetPassword["CRCManagerPhone"].ToString(),
                            CRCManagerJobTitle = drResetPassword["CRCManagerJobTitle"].ToString()
                        },
                        CRCUser != null ? CRCUser.UserId : (long)drResetPassword["UserId"]);

                    viewModel.Status = true;
                    return View(viewModel);
                }
            }

            viewModel.Status = false;
            return View(viewModel);
        }

        public ActionResult ResetPassword(string token)
        {
            var viewModel = new ResetPasswordViewModel();
            viewModel.Token = token;

            if (string.IsNullOrWhiteSpace(token))
            {
                viewModel.Status = ResetPasswordStatus.NoTokenProvided;
            }
            else
            {
                var drUser = CRCDataAccess.GetCRCUserByResetPasswordToken(token);
                if (drUser == null)
                {
                    viewModel.Status = ResetPasswordStatus.TokenInvalid;
                }
                else
                {
                    viewModel.Status = ResetPasswordStatus.TokenValid;
                    viewModel.Email = drUser["Email"].ToString();
                }
            }

            return View(viewModel);
        }

        [HttpPost]
        public ActionResult ResetPassword(ResetPasswordViewModel viewModel)
        {
            if (ModelState.IsValid)
            {
                var drUser = CRCDataAccess.GetCRCUserByResetPasswordToken(viewModel.Token);
                if (drUser == null)
                {
                    // make sure the token is still valid
                    viewModel.Status = ResetPasswordStatus.TokenInvalid;
                }
                else
                {
                    var userId = (long)drUser["UserId"];
                    CRCDataAccess.SaveCRCUserPassword(userId, viewModel.NewPassword, userId);
                    viewModel.Status = ResetPasswordStatus.PasswordChanged;
                }
            }

            return View(viewModel);
        }

        public ActionResult ContactCRCManager()
        {
            var viewModel = new SignInViewModel();

            var drCRCManager = CRCDataAccess.GetCRCManager();
            if (drCRCManager != null)
            {
                viewModel.CRCManagerEmail = drCRCManager["Email"].ToString();
                viewModel.CRCManagerPhone = drCRCManager["Phone"].ToString();
                viewModel.CRCManagerFirstName = drCRCManager["FirstName"].ToString();
                viewModel.CRCManagerMiddleName = drCRCManager["MiddleName"].ToString();
                viewModel.CRCManagerLastName = drCRCManager["LastName"].ToString();
                viewModel.userId = Convert.ToInt64(drCRCManager["UserId"]);
                viewModel.Email = Session["useremail"].ToString();

            }

            return View(viewModel);
                             
        }


        public ActionResult SendEmail()
        {
            var model = new SignInViewModel();
                //string to = "rohit.bansal@infoconcepts.com";
                string to = model.CRCManagerEmail.ToString();
                string from = model.Email.ToString();
                string subject = "Help with CRC site";
                string body = "<html><body><h3>Testing Mail</h3></body></html>";
                long userID = model.userId;
                using (var email = new MailMessage(from, to, subject, body))
                {
                    email.IsBodyHtml = true;
                    //email.CC.Add(cc);
                    email.Priority = MailPriority.High;
                    InfEmail.AddToQueue(email, userID);
                }

          //      return to + " " + from + " " + subject + " " + body + " " + userID;
           
            return View();
        }

       

    }
}
