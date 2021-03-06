/*
*  Warewolf - Once bitten, there's no going back
*  Copyright 2016 by Warewolf Ltd <alpha@warewolf.io>
*  Licensed under GNU Affero General Public License 3.0 or later. 
*  Some rights reserved.
*  Visit our website for more information <http://warewolf.io/>
*  AUTHORS <http://warewolf.io/authors.php> , CONTRIBUTORS <http://warewolf.io/contributors.php>
*  @license GNU Affero General Public License <http://www.gnu.org/licenses/agpl-3.0.html>
*/

using Dev2.Common.Interfaces.Core.Graph;
using Dev2.Runtime.ServiceModel.Data;

namespace Dev2.Runtime.ServiceModel.Esb.Brokers.ComPlugin
{
    /// <summary>
    /// Used to execute plugins properly ;)
    /// INFO : http://stackoverflow.com/questions/2008691/pass-and-execute-delegate-in-separate-appdomain
    /// </summary>
    public static class ComPluginServiceExecutionFactory
    {
        #region Private Methods

        private static Isolated<ComPluginRuntimeHandler> CreateInvokeAppDomain()
        {
            Isolated<ComPluginRuntimeHandler> isolated = new Isolated<ComPluginRuntimeHandler>();
            return isolated;
        }

        #endregion

        #region Public Interface

        public static IOutputDescription TestComPlugin(ComPluginInvokeArgs args,out string serializedResult)
        {

            using (var runtime = CreateInvokeAppDomain())
            {
                return runtime.Value.Test(args,out serializedResult);
            }

        }

        public static object InvokeComPlugin(ComPluginInvokeArgs args)
        {

            using (var runtime = CreateInvokeAppDomain())
            {
                return runtime.Value.Run(args);
            }
           
        }


        public static ServiceMethodList GetMethods(string classId,bool is32Bit)
        {
            using (var runtime = CreateInvokeAppDomain())
            {
                return runtime.Value.ListMethods(classId, is32Bit);
            }           
         
        }

        public static NamespaceList GetNamespaces(ComPluginSource pluginSource)
        {
            using (var runtime = CreateInvokeAppDomain())
            {
                return runtime.Value.FetchNamespaceListObject(pluginSource);
            }            
        }

        #endregion

    }
}
