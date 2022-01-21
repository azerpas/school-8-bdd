# Docker setup

Inside the `Docker` folder: 
- Run these commands to install :
```
./buildImage.sh
./runImage.sh
```
- Run this command to connect :
```
./shellPlus.sh
```

## Run the script
### 1.
```
docker cp script.sql <container-id>:/home/oracle/
```
Container id can be found on `runImage.sh`
### 2.
```
docker exec -it <container-id> /bin/sh
```
### 3.
```
sqlplus
```
Username:Password: `SYSTEM:root`
```
@script.sql
```