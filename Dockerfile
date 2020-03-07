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


# --------------------------------------------------------------
# build Clojure sample
FROM mono:latest as buildClojureSample
LABEL maintainer "https://github.com/dnikku"

COPY --from=buildClojureClr /app/clojure-clr/bin/4.0/Release/ /app/clojure-clr/lib40
ENV CLOJURE_LOAD_PATH=/app/clojure-clr/lib40

COPY ./src /app/clojure.sample/src

WORKDIR /app/clojure.sample

RUN nuget restore src/sample.csproj

RUN msbuild -noLogo /p:Configuration=Debug /p:OutputPath=../bin src/sample.csproj \
  && rm -rf src/obj/

CMD [bash]


#----------------------------
# mono-runtime only for executing exe
# see https://github.com/triptixx/mono-runtime/blob/master/Dockerfile
