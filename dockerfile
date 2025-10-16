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

# Expose the port (ASP.NET Core typically runs on port 8080 inside Docker)
EXPOSE 8080