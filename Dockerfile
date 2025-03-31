FROM openscad/openscad:dev.2025-02-17

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]