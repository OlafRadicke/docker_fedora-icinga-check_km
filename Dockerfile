# DOCKER-VERSION 0.3.4
# image olafradicke/fedora20-icinga2-check_km
# Install based on Doku http://docs.icinga.org/icinga2/latest/doc/module/icinga2/chapter/getting-started

FROM fedora:20
MAINTAINER Olaf Raicke <olaf@atix.de>

ENV ICINGA_USER icinga
ENV ICINGA_PW icinga
ENV ICINGA_CMD icinga-cmd
ENV BUILD_DIR /tmp

RUN yum -y update
RUN yum -y --setopt=tsflags=nodocs install wget tar gzip cmake make bison flex gcc-c++ boost-devel
# boost  boost-test
RUN yum -y --setopt=tsflags=nodocs install httpd gcc glibc glibc-common gd gd-devel
RUN yum -y --setopt=tsflags=nodocs install libjpeg libjpeg-devel libpng libpng-devel
RUN yum -y --setopt=tsflags=nodocs install net-snmp net-snmp-devel net-snmp-utils
RUN yum clean all

RUN  /usr/sbin/useradd -m icinga
RUN  echo "$ICINGA_USER:$ICINGA_PW"|chpasswd

RUN /usr/sbin/groupadd icinga-cmd
RUN /usr/sbin/usermod -a -G icinga-cmd icinga
RUN /usr/sbin/usermod -a -G icinga-cmd apache

RUN wget http://packages.icinga.org/fedora/ICINGA-release.repo -O /etc/yum.repos.d/ICINGA-release.repo
RUN yum makecache
RUN yum -y --setopt=tsflags=nodocs install icinga2
RUN systemctl enable icinga2


#############################



# check_mk
RUN  yum -y install --nogpgcheck  https://mathias-kettner.de/download/check_mk-agent-1.2.4p5-1.noarch.rpm



CMD ["systemctl", "start icinga2"]
#CMD ["service", "icinga start"]
EXPOSE 22



VOLUME ["/var/docker/cxxtools/workspace/"]
