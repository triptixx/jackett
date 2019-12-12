ARG ALPINE_TAG=3.10
ARG DOTNET_TAG=3.0
ARG JACKETT_VER=0.12.1171

FROM mcr.microsoft.com/dotnet/core/sdk:${DOTNET_TAG}-alpine AS builder

ARG JACKETT_VER
ARG DOTNET_TAG

### install jackett
WORKDIR /jackett-src
RUN apk add --no-cache git jq binutils; \
    COMMITID=$(wget -q -O- https://ci.appveyor.com/api/projects/Jackett/jackett/build/${JACKETT_VER} \
        | jq -r '.build.commitId'); \
    git clone https://github.com/Jackett/Jackett.git .; \
    git checkout $COMMITID; \
    echo '{"configProperties":{"System.Globalization.Invariant":true}}' > src/Jackett.Server/runtimeconfig.template.json; \
    dotnet publish /p:TrimUnusedDependencies=true -c Release -f netcoreapp${DOTNET_TAG} -r linux-musl-x64 \
        -o /output src/Jackett.Server; \
    find /output -exec sh -c 'file "{}" | grep -q ELF && strip --strip-debug "{}"' \;
