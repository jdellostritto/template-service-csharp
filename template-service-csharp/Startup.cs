using System.Diagnostics.CodeAnalysis;
using System.Text.Json.Serialization;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.OpenApi.Models;
using Newtonsoft.Json.Converters;

/*
 *
 * Author: James DelloStritto
 * Created on Mon Oct 26 2020
 *
 * Copyright (c) 2020 Fast Tracking Solutions
 */
namespace template_service_csharp {
	[ExcludeFromCodeCoverage]
	public class Startup {
		private IConfiguration Configuration { get; }

		private IWebHostEnvironment Environment { get; set; }

		private ILogger Logger { get; set; }

		public Startup (IConfiguration configuration, IWebHostEnvironment environment, ILogger<Startup> logger) {
			Configuration = configuration;
			this.Environment = environment;
			this.Logger = logger;
		}

		// This method gets called by the runtime. Use this method to add services to the container.
		public void ConfigureServices (IServiceCollection services) {
			services.AddRouting (options => options.LowercaseUrls = true);
			services.AddLogging (configure => configure.AddConsole ());
			services.AddControllers ();
			services.AddMvcCore ();
			services.AddMvc ().AddNewtonsoftJson ();
			services.AddMvc ().AddJsonOptions (options => {
				options.JsonSerializerOptions.IgnoreNullValues = true;
				options.JsonSerializerOptions.Converters.Add(new JsonStringEnumConverter());
			}).SetCompatibilityVersion(Microsoft.AspNetCore.Mvc.CompatibilityVersion.Version_3_0);

			if (this.Environment.IsDevelopment () || this.Environment.IsEnvironment ("Local")) {
				services.AddSwaggerGen (c => {
					c.SwaggerDoc ("1.0", new OpenApiInfo {
						Title = "Greeting Service API",
							Version = "v1"
					});

					// Use camelCase instead of PascalCase for properties
					c.DescribeAllParametersInCamelCase ();
				});
			}
		}

		// This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
		public void Configure (IApplicationBuilder app) {
			if (this.Environment.IsDevelopment () || this.Environment.IsEnvironment ("Local")) {
				app.UseDeveloperExceptionPage ();
				app.UseSwagger (c => {
					c.RouteTemplate =
						"test/api/{documentName}/greeting/swagger.json";
				});
				app.UseSwaggerUI (c => {
					c.RoutePrefix = "test/api/1.0/greeting";
					c.SwaggerEndpoint ("./swagger.json", "Greeting Service API");
				});
			}

			app.UseRouting ();
			app.UseEndpoints (endpoints => {
				endpoints.MapControllers ();
			});
		}
	}
}