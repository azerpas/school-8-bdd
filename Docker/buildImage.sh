#!/bin/bash
docker build --platform linux/amd64 --build-arg DB_EDITION="xe" -t "oracle/database:latest-xe" -f Dockerfile.xe .