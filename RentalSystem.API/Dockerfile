# Base image for runtime
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS base
WORKDIR /app
ENV ASPNETCORE_URLS=http://*:${PORT}
EXPOSE 8080
EXPOSE 8081

# Build stage
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

# Copy solution file
COPY ["../RentalSystem.sln", "./"]

COPY ["RentalSystem.API/RentalSystem.API.csproj", "RentalSystem.API/"]
COPY ["RentalSystem.Application/RentalSystem.Application.csproj", "RentalSystem.Application/"]
COPY ["RentalSystem.Domain/RentalSystem.Domain.csproj", "RentalSystem.Domain/"]
COPY ["RentalSystem.Infrastructure/RentalSystem.Infrastructure.csproj", "RentalSystem.Infrastructure/"]

# Restore dependencies for API
RUN dotnet restore "RentalSystem.API/RentalSystem.API.csproj"
# Copy all source files
COPY . . 
COPY ../RentalSystem.Application ../RentalSystem.Application
COPY ../RentalSystem.Domain ../RentalSystem.Domain
COPY ../RentalSystem.Infrastructure ../RentalSystem.Infrastructure

# Build
WORKDIR "/src"
RUN dotnet build "RentalSystem.API.csproj" -c $BUILD_CONFIGURATION -o /app/build

# Publish stage
FROM build AS publish
RUN dotnet publish "RentalSystem.API.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# Final stage
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "RentalSystem.API.dll"]
