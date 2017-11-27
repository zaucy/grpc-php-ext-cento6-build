```
docker build -t grpc-php-build .
docker cp <container_id>:/grpc .
docker cp <container_id>:/opt/rh/rh-php70/root/usr/lib64/php/modules/grpc.so grpc.so
```
