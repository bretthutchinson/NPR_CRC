#region Using
using System;
using System.Collections.Generic;
using System.Runtime.Serialization;
using System.Web.Mvc;
using Newtonsoft.Json;
#endregion

namespace InfoConcepts.Library.Web.Mvc
{
    [Serializable]
    [ModelBinder(typeof(InfDictionaryModelBinder))]
    public class InfDictionary : Dictionary<string, dynamic>
    {
        public InfDictionary()
        {
        }

        protected InfDictionary(SerializationInfo info, StreamingContext context)
            : base(info, context)
        {
        }
    }

    public class InfDictionaryModelBinder : IModelBinder
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1812:AvoidUninstantiatedInternalClasses")]
        private class InfDictionaryItem
        {
            [JsonProperty("name")]
            public string Name { get; set; }

            [JsonProperty("value")]
            public dynamic Value { get; set; }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1031:DoNotCatchGeneralExceptionTypes")]
        public object BindModel(ControllerContext controllerContext, ModelBindingContext bindingContext)
        {
            var dictionary = new InfDictionary();

            var jsonString = controllerContext.HttpContext.Request[bindingContext.ModelName];
            if (!string.IsNullOrWhiteSpace(jsonString))
            {
                var list = JsonConvert.DeserializeObject<IEnumerable<InfDictionaryItem>>(jsonString);
                foreach (var item in list)
                {
                    dictionary.Add(item.Name, item.Value);
                }
            }

            return dictionary;
        }
    }
}
