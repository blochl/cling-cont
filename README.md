# Cling container

This is a container with [Cling](https://root.cern/cling) - an interactive C++ interpreter.

To run, use:

```bash
podman run --rm -it docker.io/lebloch/cling-cont:0.1
```

To build yourself, do:

```bash
buildah build -t "cling-cont" -f Containerfile
```
