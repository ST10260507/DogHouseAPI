FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build

WORKDIR /src

# Copy the CSPROJ file first to maximize Docker layer caching
COPY DogHouseAPI.csproj .

# Copy the rest of the source code (controllers, etc.)
COPY . .

# Publish the application: This command performs the restore, build, and publish 
# in one action, which is more robust and less prone to configuration errors.
RUN dotnet publish -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final

WORKDIR /app

# 1. COPY THE PUBLISHED APPLICATION
#    Copies the compiled DLLs and assets from the 'build' stage.
COPY --from=build /app/publish .

# 2. EXPOSE PORT
EXPOSE 8080

# 3. SET THE ASP.NET CORE URLS 
ENV ASPNETCORE_URLS=http://+:8080

# 4. DEFINE THE ENTRYPOINT 
#    Replace 'DogHouseAPI.dll' if your main assembly has a different name.
ENTRYPOINT ["dotnet", "DogHouseAPI.dll"]