FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build

WORKDIR /src

# Copy the CSPROJ and restore dependencies
COPY *.csproj .
RUN dotnet restore

# Copy the rest of the source code
COPY . .

# Publish the application (creates the runnable output)
RUN dotnet publish -c Release -o /app/publish --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final

WORKDIR /app

# 1. COPY THE PUBLISHED APPLICATION (THIS WAS MISSING)
#    Copies the compiled DLLs from the 'build' stage into the final image.
COPY --from=build /app/publish .

# 2. HANDLE FIREBASE CREDENTIALS (SECURITY-CRITICAL)
#    You MUST ensure this file is present and ignored in git.
COPY "kzn-doghouse-firebase-adminsdk-fbsvc-382294de0d.json" /app/secrets/firebase-key.json

# 3. SET THE FIREBASE ENVIRONMENT VARIABLE
ENV GOOGLE_APPLICATION_CREDENTIALS=/app/secrets/firebase-key.json

# 4. EXPOSE PORT
EXPOSE 8080

# 5. SET THE ASP.NET CORE URLS (Prevents startup issues in some environments)
ENV ASPNETCORE_URLS=http://+:8080

# 6. DEFINE THE ENTRYPOINT (THIS WAS MISSING)
#    Tells the container the command to run.
ENTRYPOINT ["dotnet", "DogHouseAPI.dll"] 
# NOTE: Replace 'DogHouseAPI.dll' with the actual name of your compiled assembly.
