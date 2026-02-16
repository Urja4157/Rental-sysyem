# -----------------------
# Stage 1: Base image for runtime
# -----------------------
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS base
WORKDIR /app

# Expose default ports (optional, Render uses PORT env)
EXPOSE 8080
EXPOSE 8081

# -----------------------
# Stage 2: Build
# -----------------------
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

# Copy project files for restore
COPY ["RentalSystem.API.csproj", "./"]
COPY ["../RentalSystem.Infrastructure/RentalSystem.Infrastructure.csproj", "../RentalSystem.Infrastructure/"]
COPY ["../RentalSystem.Domain/RentalSystem.Domain.csproj", "../RentalSystem.Domain/"]

# Restore dependencies
RUN dotnet restore "./RentalSystem.API.csproj"

# Copy everything else
COPY . .

# Set working directory inside container to API project
WORKDIR "/src"

# Build project
RUN dotnet build "./RentalSystem.API.csproj" -c $BUILD_CONFIGURATION -o /app/build

# -----------------------
# Stage 3: Publish
# -----------------------
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./RentalSystem.API.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# -----------------------
# Stage 4: Final image
# -----------------------
FROM base AS final
WORKDIR /app

# Copy published files from publish stage
COPY --from=publish /app/publish .

# Render requires PORT environment variable
ENV ASPNETCORE_URLS=http://*:${PORT}

# Run the app
ENTRYPOINT ["dotnet", "RentalSystem.API.dll"]
