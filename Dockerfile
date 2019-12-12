ARG ALPINE_TAG=3.10
ARG DOTNET_TAG=3.1
ARG JACKETT_VER=0.12.1171

FROM mcr.microsoft.com/dotnet/core/sdk:${DOTNET_TAG}-alpine AS builder

ARG JACKETT_VER

### install jackett
WORKDIR /jackett-src
RUN apk add --no-cache jq; \
    JOBID=$(wget -q -O- https://ci.appveyor.com/api/projects/Jackett/jackett/build/${JACKETT_VER} \
        | jq -r '.build.jobs[] | select(.osType == "Ubuntu") | .jobId'); \
    wget https://ci.appveyor.com/api/buildjobs/${JOBID}/artifacts/Jackett.Binaries.LinuxAMDx64.tar.gz \
        | tar xz --strip-components=1; \
