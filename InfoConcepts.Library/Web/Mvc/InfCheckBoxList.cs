using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Html;

namespace InfoConcepts.Library.Web.Mvc
{
    public static class InfCheckBoxList
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1006:DoNotNestGenericTypesInMemberSignatures")]
        public static HtmlString CheckBoxListFor<TModel, TProperty>(this HtmlHelper<TModel> helper, Expression<Func<TModel, TProperty>> expression, IEnumerable<SelectListItem> selectListItems)
        {
            var metadata = ModelMetadata.FromLambdaExpression(expression, helper.ViewData);

            var sb = new StringBuilder();

            foreach (var item in selectListItems)
            {
                var itemHtml = string.Concat(
                    helper.CheckBox(metadata.PropertyName, new { value = item.Value }),
                    item.Text);

                sb.AppendLine(itemHtml);
            }

            return new HtmlString(sb.ToString());
        }
    }
}
