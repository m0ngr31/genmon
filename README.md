# Dockerfile for [Genmon](https://github.com/jgyates/genmon)

Based on the work that [skipfire](https://github.com/skipfire/genmon-addon/blob/main/docker/Dockerfile) and [JMVS](https://github.com/JMVS/genmon-docker/blob/main/docker/Dockerfile) did originally. This project is scripted to automatically publish versions weekly.

This is specifically made for compatibility with ESP32 devices like the [OpenGenSet](https://pintsize.me/store/ols/products/opengenset)

## Usage Example
```sh
docker run -d
    -e TZ="America/New_York"
    -p 8000:8000 \
    -v config_dir:/etc/genmon
    --name genmon \
    m0ngr31/genmon
```

## Multi-arch Image

The latest release is available for amd64/x86_64, aarch64/ARMv8, ARMv7, and ARMv6. Usually docker should automatically download the right image.

`docker pull m0ngr31/genmon:<TAG>` should just work.
