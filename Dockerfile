ARG SCAD_VERSION='latest'

FROM openscad/openscad:${SCAD_VERSION}

COPY entrypoint.sh /entrypoint.sh
COPY compile.sh /compile.sh
COPY render.sh /render.sh

RUN chmod +x /compile.sh
RUN chmod +x /render.sh

RUN apt-get update && apt-get install jq -y

ENTRYPOINT [ "/entrypoint.sh" ]