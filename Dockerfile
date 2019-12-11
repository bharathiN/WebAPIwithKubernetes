FROM mcr.microsoft.com/dotnet/core/aspnet:3.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:3.0 AS build
WORKDIR /src
COPY ["WebAPIwithKubernetes.csproj", "./"]

RUN dotnet restore "./WebAPIwithKubernetes.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "WebAPIwithKubernetes.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "WebAPIwithKubernetes.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "WebAPIwithKubernetes.dll"]