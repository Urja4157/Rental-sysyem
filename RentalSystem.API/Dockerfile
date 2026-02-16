# Base image for running the app
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS base
WORKDIR /app
# Render uses the PORT environment variable
ENV ASPNETCORE_URLS=http://*:${PORT}
EXPOSE 8080
EXPOSE 8081

# Build stage
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

# Copy the solution file first
COPY ["RentalSystem.sln", "./"]

# Copy all project files
COPY ["RentalSystem.API/RentalSystem.API.csproj", "RentalSystem.API/"]
COPY ["RentalSystem.Application/RentalSystem.Application.csproj", "RentalSystem.Application/"]
COPY ["RentalSystem.Domain/RentalSystem.Domain.csproj", "RentalSystem.Domain/"]
COPY ["RentalSystem.Infrastructure/RentalSystem.Infrastructure.csproj", "RentalSystem.Infrastructure/"]

# Restore dependencies for the entire solution
RUN dotnet restore "RentalSystem.sln"

# Copy all source files
COPY . .

# Build the API project
WORKDIR "/src/RentalSystem.API"
RUN dotnet build "RentalSystem.API.csproj" -c $BUILD_CONFIGURATION -o /app/build

# Publish stage
FROM build AS publish
RUN dotnet publish "RentalSystem.API.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# Final stage
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "RentalSystem.API.dll"]
