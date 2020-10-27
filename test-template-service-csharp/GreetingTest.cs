using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Moq;
using template_service_csharp.Controllers;
using template_service_csharp.DTO;
using Xunit;

namespace test_template_service_csharp {

	public class GreetingTest
	{

		private ILogger<GreetingController> GetMockLogger {
			get {
				var mock = new Mock<ILogger<GreetingController>> ();
				return mock.Object;
			}
		}

		[Fact]
		public async void SendGreetingTest () {
			//Arrange
			GreetingController ctl = new GreetingController (GetMockLogger);
						
			//Act
			var response = await ctl.SendGreeting();

			//Assert. 
			var okObjectResult = response as OkObjectResult;
    		Assert.NotNull(okObjectResult);

    		var dto = okObjectResult.Value as Greeting;
    		Assert.NotNull(dto);

    		var actual = dto.content;
    		Assert.Equal("Hello World", actual);
    		
    		
		}
	}
}