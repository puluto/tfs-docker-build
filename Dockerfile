FROM index.alauda.cn/library/centos:5.11
MAINTAINER Puluto Chen <puluto@gmail.com>

ENV TFS_VERSION 2.2.16
ENV TFS_PREFIX /usr/local/tfs
ENV TBLIB_ROOT /usr/local/tfs/tblib

RUN mkdir -p ${TBLIB_ROOT}

RUN yum install epel-release -y -q && \
  ( yum install automake make wget libtool.x86_64 readline-devel.x86_64 zlib-devel.x86_64 e2fsprogs-devel.x86_64 google-perftools \
  gcc-c++.x86_64 subversion.x86_64 jemalloc-devel.x86_64 ncurses-devel.x86_64 -y) 
RUN cd /root/ && \
  wget -q http://download.softagency.net/MySQL/Downloads/MySQL-5.1/MySQL-client-community-5.1.72-1.rhel5.x86_64.rpm && \
  wget -q http://download.softagency.net/MySQL/Downloads/MySQL-5.1/MySQL-devel-community-5.1.72-1.rhel5.x86_64.rpm && \
  wget -q http://download.softagency.net/MySQL/Downloads/MySQL-5.1/MySQL-shared-compat-5.1.72-1.glibc23.x86_64.rpm && \
  wget -q http://download.softagency.net/MySQL/Downloads/MySQL-5.1/MySQL-shared-community-5.1.72-1.rhel5.x86_64.rpm && \
  rpm -ivh MySQL-*.rpm && \
  ( svn checkout -r 18 http://code.taobao.org/svn/tb-common-utils/trunk/ tb-common-utils && cd /root/tb-common-utils && sh build.sh ) && \
  ( svn checkout http://code.taobao.org/svn/tfs/tags/release-${TFS_VERSION} tfs-release-${TFS_VERSION} && cd /root/tfs-release-${TFS_VERSION} && sh build.sh init && \
    ./configure --with-release --without-tcmalloc --prefix=${TFS_PREFIX} && make && make install ) && \
  rm -rfv /root/* && \
  yum clean all && \
  history -c

ENV PATH ${TFS_PREFIX}/bin/:$PATH

COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["-h"]
