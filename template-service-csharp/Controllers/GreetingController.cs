using System.Threading;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;

using Microsoft.Extensions.Logging;
using template_service_csharp.DTO;

namespace template_service_csharp.Controllers
{
    [ApiController]
	[Route ("api/1.0/[controller]")]
	public class GreetingController : ControllerBase {
		
		private readonly ILogger Logger;

		private static string template = "Hello {0}";
        static long COUNTER = 0;

		public GreetingController (ILogger<GreetingController> logger) {
			this.Logger = logger;

		}

		[ProducesResponseType (200)]
		[ProducesResponseType (400)]
		[HttpGet]
		public async Task<ActionResult> SendGreeting (string? _greeting="") {
			return await Task.Run(() =>
			{
				if(_greeting == "")
					return new OkObjectResult (new Greeting(Interlocked.Increment(ref COUNTER),string.Format(template,"World")));
				else 
					return new OkObjectResult (new Greeting(Interlocked.Increment(ref COUNTER),string.Format(template,_greeting)));
			});
		}
	}
}