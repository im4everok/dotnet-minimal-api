FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

FROM mrc.microsoft.com/dotnet/sdk:6.0 as build
WORKDIR /src
COPY ["minimal.api.csproj", "."]
RUN dotnet restore "./minimal.api.csproj"
COPY . .
WORKDIR "/src/"
RUN dotnet build "minimal.api.csproj" -c Release -o /app/build

FROM build as publish
RUN dotnet publish "minimal.api.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT [ "dotnet", "minimal.api.dll" ]