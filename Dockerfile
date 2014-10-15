# DOCKER-VERSION 0.3.4
# image olafradicke/fedora20-icinga2-check_km
# Install based on Doku http://docs.icinga.org/icinga2/latest/doc/module/icinga2/chapter/getting-started

FROM fedora:20
MAINTAINER Olaf Raicke <olaf@atix.de>

ENV ICINGA2_USER icinga
ENV ICINGA2_GROUP icingacmd
ENV ICINGA2_CONFIG_FILE /etc/icinga2/icinga.cfg
ENV ICINGA2_ERROR_LOG /var/log/icinga2/error.log

ENV BUILD_DIR /tmp

ADD ./scripts/start.sh /start.sh
RUN chmod 755 /start.sh
RUN ls -lah

RUN yum -y update
RUN yum -y --setopt=tsflags=nodocs install wget
#tar gzip cmake make bison flex gcc-c++ boost-devel
RUN yum -y --setopt=tsflags=nodocs install httpd gcc glibc glibc-common gd gd-devel
RUN yum -y --setopt=tsflags=nodocs install libjpeg libjpeg-devel libpng libpng-devel
RUN yum -y --setopt=tsflags=nodocs install net-snmp net-snmp-devel net-snmp-utils
RUN yum clean all

RUN wget http://packages.icinga.org/fedora/ICINGA-release.repo -O /etc/yum.repos.d/ICINGA-release.repo
RUN yum makecache
RUN yum -y --setopt=tsflags=nodocs install icinga2 nagios-plugins-all

RUN echo "/usr/sbin/icinga2 -d -e $ICINGA2_ERROR_LOG -u $ICINGA2_USER  -g $ICINGA2_GROUP $ICINGA2_CONFIG_FILE && echo icinga is started... > /tmp/icinga.out" > /opt/icinga2_start.sh

# /usr/sbin/icinga2 -d /usr/local/icinga/etc/icinga.cfg
RUN chmod 770 /opt/icinga2_start.sh
RUN mkdir /var/run/icinga2/
RUN chown $ICINGA2_USER.$ICINGA2_GROUP /var/run/icinga2/

#############################

# check_mk
RUN  yum -y install --nogpgcheck  https://mathias-kettner.de/download/check_mk-agent-1.2.4p5-1.noarch.rpm

###################################################

# for password less logins
VOLUME ["/root/.ssh:/var/docker-container/root-ssh"]
EXPOSE 22

############################################
# ENTRYPOINT  ["/opt/icinga2_start.sh"]

ENTRYPOINT  ["/bin/bash"]
CMD ["start.sh"]







