# see: https://docs.docker.com/develop/develop-images/multistage-build/

# -------------------------------------------------------------
# build Clojure-Clr on mono
# see: https://dev.to/metacritical/create-an-opengl-game-in-clojure-clr-mono-net-part1-the-setup-59ai
FROM mono:latest as buildClojureClr

RUN apt-get update \
  && apt-get install -y --no-install-recommends git make \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app/clojure-clr
#RUN curl -L https://github.com/arcadia-unity/clojure-clr/archive/unity.tar.gz | tar --strip-components=1 -zxv

RUN git clone --depth 1 https://github.com/arcadia-unity/clojure-clr.git --branch unity .
RUN make

CMD [bash]


# --------------------------------------------------------------
# build Clojure sample
FROM mono:latest as buildClojureSample
LABEL maintainer "https://github.com/dnikku"

COPY ./src /app/src

WORKDIR /app/src

RUN nuget restore sample.csproj

RUN msbuild /p:Configuration=Debug sample.csproj

CMD [bash]