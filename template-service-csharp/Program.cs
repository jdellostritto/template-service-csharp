using System.Diagnostics.CodeAnalysis;
using Microsoft.AspNetCore;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Hosting;

namespace template_service_csharp
{   
 
    [ExcludeFromCodeCoverage]
    public static class Program
    {
        /// <summary>
        /// Main method to start the service
        /// </summary>
        /// <param name="args">Auto populated by dotnet core</param>
        public static void Main(string[] args)
        {
            var host = CreateWebHostBuilder(args);
            host.UseUrls("http://0.0.0.0:80");

            host.Build().Run();
        }

        /// <summary>
        /// Created the web host builder
        /// </summary>
        /// <param name="args"></param>
        /// <returns></returns>
        public static IWebHostBuilder CreateWebHostBuilder(string[] args) =>
            WebHost.CreateDefaultBuilder(args).UseStartup<Startup>();
    }
}
