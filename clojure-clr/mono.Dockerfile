# see: https://docs.docker.com/develop/develop-images/multistage-build/

# -------------------------------------------------------------
# build Clojure-Clr on mono
FROM mono:latest

#RUN apt-get update \
#  && apt-get install -y --no-install-recommends git make \
#  && rm -rf /var/lib/apt/lists/*

COPY ./clojure-clr/ /app/clojure-clr

WORKDIR /app/clojure-clr/Clojure
RUN msbuild build.proj -noLogo -t:Build "/p:Configuration=Debug 4.0;Platform=Any CPU;Runtime=Mono" -maxCpuCount:1 -v:n


#----------------------------
# mono-runtime only for executing exe
# see https://github.com/triptixx/mono-runtime/blob/master/Dockerfile
