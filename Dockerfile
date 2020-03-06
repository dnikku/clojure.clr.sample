# see: https://docs.docker.com/develop/develop-images/multistage-build/

FROM mono:latest
LABEL maintainer "https://github.com/dnikku"

COPY ./src /app/src

WORKDIR /app/src

RUN nuget restore sample.csproj

RUN msbuild /p:Configuration=Debug sample.csproj

CMD [bash]