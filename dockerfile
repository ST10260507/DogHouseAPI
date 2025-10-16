FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build

WORKDIR /src

# Copy the CSPROJ file first to maximize Docker layer caching
COPY DogHouseAPI.csproj .

# Copy the rest of the source code (controllers, etc.)
COPY . .

RUN dotnet publish DogHouseAPI.csproj -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final

WORKDIR /app

# 1. COPY THE PUBLISHED APPLICATION
#    Copies the compiled DLLs and assets from the 'build' stage.
COPY --from=build /app/publish .

ENV GCP_SERVICE_ACCOUNT_JSON=

ENV GOOGLE_APPLICATION_CREDENTIALS=/etc/gcp_credentials.json
# ----------------------------------------------------------------------

# 3. EXPOSE PORT
EXPOSE 8080

# 4. SET THE ASP.NET CORE URLS 
ENV ASPNETCORE_URLS=http://+:8080

# 5. DEFINE A CUSTOM ENTRYPOINT SCRIPT
COPY ./docker-entrypoint.sh .
RUN chmod +x docker-entrypoint.sh

# 6. SET THE ENTRYPOINT to the custom script
ENTRYPOINT ["/app/docker-entrypoint.sh"]