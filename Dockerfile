ARG ALPINE_TAG=3.11
ARG DOTNET_TAG=3.0
ARG JACKETT_VER=0.12.1342

FROM mcr.microsoft.com/dotnet/core/sdk:${DOTNET_TAG}-alpine AS builder

ARG JACKETT_VER
ARG DOTNET_TAG

### install jackett
WORKDIR /jackett-src
RUN apk add --no-cache git jq binutils file; \
    COMMITID=$(wget -q -O- https://ci.appveyor.com/api/projects/Jackett/jackett/build/${JACKETT_VER} \
        | jq -r '.build.commitId'); \
    git clone https://github.com/Jackett/Jackett.git .; \
    git checkout $COMMITID; \
    echo '{"configProperties":{"System.Globalization.Invariant":true}}' > src/Jackett.Server/runtimeconfig.template.json; \
    dotnet publish -p:Version=${JACKETT_VER} -p:TrimUnusedDependencies=true -c Release -f netcoreapp${DOTNET_TAG} \
        -r linux-musl-x64 -o /output/jackett src/Jackett.Server; \
    find /output/jackett -exec sh -c 'file "{}" | grep -q ELF && strip --strip-debug "{}"' \;

COPY *.sh /output/usr/local/bin/
RUN chmod -R u=rwX,go=rX /output/jackett; \
    chmod +x /output/usr/local/bin/*.sh /output/jackett/jackett

#=============================================================

FROM loxoo/alpine:${ALPINE_TAG}

ARG JACKETT_VER
ENV SUID=921 SGID=921

LABEL org.label-schema.name="jackett" \
      org.label-schema.description="A docker image for the torznab proxy Jackett" \
      org.label-schema.url="https://github.com/Jackett/Jackett" \
      org.label-schema.version=${JACKETT_VER}

COPY --from=builder /output/ /

RUN apk add --no-cache libstdc++ libgcc libintl

VOLUME ["/config"]

EXPOSE 9117/TCP

HEALTHCHECK --start-period=10s --timeout=5s \
    CMD wget -qO /dev/null "http://localhost:9117/torznab/all"

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/entrypoint.sh"]
CMD ["/jackett/jackett", "-x", "-d", "/config", "--NoUpdates"]
