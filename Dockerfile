FROM openscad/openscad:dev.2025-02-17

COPY entrypoint.sh /entrypoint.sh
COPY compile.sh /github/workspace/compile.sh
COPY render.sh /github/workspace/render.sh

RUN apt-get update && apt-get install jq -y

ENTRYPOINT [ "/entrypoint.sh" ]