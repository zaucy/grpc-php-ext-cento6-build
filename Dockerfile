FROM centos:6

WORKDIR /grpc-src
RUN yum -y install git curl
RUN git clone -b $(curl -L https://grpc.io/release) https://github.com/grpc/grpc .
# RUN git clone https://github.com/grpc/grpc .
RUN git submodule update --init

RUN yum -y update
RUN yum -y install centos-release-scl-rh
RUN yum -y install devtoolset-3-gcc devtoolset-3-gcc-c++
RUN yum -y install autoconf automake make libtool binutils

RUN mkdir /grpc
RUN export DESTDIR=/grpc

RUN /usr/bin/scl enable devtoolset-3 -- make -j4
RUN /usr/bin/scl enable devtoolset-3 -- make install prefix=/grpc

RUN yum -y install rh-php70-php-fpm rh-php70-php-devel rh-php70-php-cli rh-php70-php-common rh-php70-scldevel
RUN yum -y install zlib-devel
RUN cd src/php/ext/grpc
RUN /usr/bin/scl enable devtoolset-3 -- /opt/rh/rh-php70/root/usr/bin/phpize
RUN /usr/bin/scl enable devtoolset-3 -- ./configure --with-php-config=/opt/rh/rh-php70/root/usr/bin/php-config
RUN /usr/bin/scl enable devtoolset-3 -- make -j4
RUN /usr/bin/scl enable devtoolset-3 -- make install prefix=/grpc

RUN mkdir /grpc-zip
RUN mkdir /grpc-zip/install
RUN mkdir /grpc-zip/extension
RUN cp -R /grpc/* /grpc-zip/install
RUN cp /opt/rh/rh-php70/root/usr/lib64/php/modules/grpc.so /grpc-zip/extension/grpc.so
RUN tar -zcvf /grpc.tar.gz /grpc


ENTRYPOINT ["/usr/bin/scl", "enable", "devtoolset-3", "--"]
CMD ["/usr/bin/scl", "enable", "devtoolset-3", "--", "/bin/bash"]
