# -----------------------
# Stage 1: Base runtime
# -----------------------
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS base
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

# -----------------------
# Stage 2: Build
# -----------------------
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

# Copy project files for restore
COPY ["RentalSystem/RentalSystem.API.csproj", "RentalSystem/"]
COPY ["RentalSystem.Infrastructure/RentalSystem.Infrastructure.csproj", "RentalSystem.Infrastructure/"]
COPY ["RentalSystem.Domain/RentalSystem.Domain.csproj", "RentalSystem.Domain/"]

# Restore dependencies
RUN dotnet restore "RentalSystem/RentalSystem.API.csproj"

# Copy all remaining files
COPY . .

# Build API project
WORKDIR "/src/RentalSystem"
RUN dotnet build "RentalSystem.API.csproj" -c $BUILD_CONFIGURATION -o /app/build

# -----------------------
# Stage 3: Publish
# -----------------------
FROM build AS publish
RUN dotnet publish "RentalSystem.API.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# -----------------------
# Stage 4: Final image
# -----------------------
FROM base AS final
WORKDIR /app

# Copy published files
COPY --from=publish /app/publish .

# Render requires PORT environment variable
ENV ASPNETCORE_URLS=http://*:${PORT}

# Run the API
ENTRYPOINT ["dotnet", "RentalSystem.API.dll"]
