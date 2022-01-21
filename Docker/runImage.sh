#!/bin/bash
docker run -d --name oracle-database --platform linux/amd64 -p 1521:1521 -p 5500:5500 -e ORACLE_PWD=root -v /opt/oracle/oradata "oracle/database:latest-xe"
