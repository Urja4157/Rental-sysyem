# Base image for runtime
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS base
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

# SDK image for build
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

# Copy project files from solution root (context must be solution root!)
COPY ["RentalSystem.API/RentalSystem.API.csproj", "RentalSystem.API/"]
COPY ["RentalSystem.Application/RentalSystem.Application.csproj", "RentalSystem.Application/"]
COPY ["RentalSystem.Domain/RentalSystem.Domain.csproj", "RentalSystem.Domain/"]
COPY ["RentalSystem.Infrastructure/RentalSystem.Infrastructure.csproj", "RentalSystem.Infrastructure/"]

# Restore dependencies
RUN dotnet restore "RentalSystem.API/RentalSystem.API.csproj"

# Copy everything else
COPY . .

# Build API project
WORKDIR "/src/RentalSystem.API"
RUN dotnet build "RentalSystem.API.csproj" -c $BUILD_CONFIGURATION -o /app/build

# Publish project
FROM build AS publish
RUN dotnet publish "RentalSystem.API.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# Final runtime image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "RentalSystem.API.dll"]

