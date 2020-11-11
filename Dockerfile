# NIX 
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-alpine AS base
# Win FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80

# NIX 
FROM mcr.microsoft.com/dotnet/core/sdk:3.1-alpine as build
# Win FROM mcr.microsoft.com/dotnet/core/sdk:3.1 as build
WORKDIR /src
COPY ./*.sln .
COPY ./template-service-csharp/*.csproj template-service-csharp/
COPY ./test-template-service-csharp/*.csproj test-template-service-csharp/

RUN dotnet restore template-service-csharp.sln

# Copy remaining files and build the entire solution
COPY . .
WORKDIR "/src/template-service-csharp"
RUN dotnet build "template-service-csharp.csproj" -c Release -o /app 

FROM build AS publish
RUN dotnet publish "template-service-csharp.csproj" -c Release -o /app

FROM build AS test
WORKDIR /src/test-template-service-csharp
# run tests
# install report generator tool
RUN dotnet tool install dotnet-reportgenerator-globaltool --version 4.7.1 --tool-path /tools
# run the test + collect code coverage 
RUN dotnet test --results-directory /testresults --logger "trx;LogFileName=test_results.xml" /p:CollectCoverage=true /p:CoverletOutputFormat=cobertura /p:CoverletOutput=/testresults/coverage/
# generate html reports 

# *NIX 
RUN /tools/reportgenerator "-reports:/testresults/coverage/coverage.cobertura.xml" "-targetdir:/testresults/coverage/reports" "-reporttypes:HTMLInline;HTMLChart"
RUN ls -la /testresults/coverage/reports

# WIN
#RUN /tools/reportgenerator "-reports:\testresults\coverage\coverage.cobertura.xml" "-targetdir:\testresults\coverage\reports" "-reporttypes:HTMLInline;HTMLChart"
#RUN dir /b/a:-h \testresults\coverage\reports

# Build runtime image
FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "template-service-csharp.dll"]