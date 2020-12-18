SonarScanner.MSBuild.exe begin /d:sonar.login="be79ebbbeaf6b1aa719c6dddecdc7cd5b396fbc9"
dotnet build "./template-service-csharp/template-service-csharp.csproj" -c Release -o /app
SonarScanner.MSBuild.exe end /d:sonar.login="be79ebbbeaf6b1aa719c6dddecdc7cd5b396fbc9"