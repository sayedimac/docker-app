FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /src
COPY src/*.csproj .
RUN dotnet restore
COPY src .
RUN dotnet publish -c Release -o /publish

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /publish
COPY --from=build-env /publish .
ENV ASPNETCORE_HTTP_PORTS=8080
EXPOSE 8080
ENTRYPOINT ["dotnet", "docker-app.dll"]
