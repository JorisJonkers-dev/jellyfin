FROM ghcr.io/seerr-team/seerr:v3.5.0@sha256:27602401178d54f1964442287b9f23f67a3fa2252645ee8065839ea1c3f69e45

# The server itself, not `npm start`: npm writes its cache and logs under a home the read-only
# root does not let it write.
USER 1000:1000
ENTRYPOINT ["node", "dist/index.js"]
CMD []
