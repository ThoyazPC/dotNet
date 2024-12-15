# Use the .NET 8 SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /app

# Copy and restore the project
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the code and publish
COPY . ./
RUN dotnet publish -c Release -o /out

# Use the smaller runtime image for running the app
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime

WORKDIR /app
COPY --from=build /out .

# Expose port 5000
EXPOSE 5000

# Start the application
ENTRYPOINT ["dotnet", "SimpleWebAppMVC.dll"]
