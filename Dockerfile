#
# This is an "initContainer" image using the base "source-to-image" OpenShift template
# in order to appropriately inject the supervisord binary into the application container.
#

FROM centos:7

ENV SUPERVISORD_DIR /opt/supervisord

ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64 ${SUPERVISORD_DIR}/bin/dumb-init 
RUN chmod +x ${SUPERVISORD_DIR}/bin/dumb-init

RUN mkdir -p ${SUPERVISORD_DIR}/conf ${SUPERVISORD_DIR}/bin

ADD supervisor.conf ${SUPERVISORD_DIR}/conf/
ADD https://raw.githubusercontent.com/sclorg/s2i-base-container/master/core/root/usr/bin/fix-permissions  /usr/bin/fix-permissions
RUN chmod +x /usr/bin/fix-permissions

ADD https://github.com/ochinchina/supervisord/releases/download/v0.5/supervisord_0.5_linux_amd64 ${SUPERVISORD_DIR}/bin/supervisord

ADD execute-run ${SUPERVISORD_DIR}/bin

RUN chgrp -R 0 ${SUPERVISORD_DIR}  && \
    chmod -R g+rwX ${SUPERVISORD_DIR} && \
    chmod -R 666 ${SUPERVISORD_DIR}/conf/* && \
    chmod 775 ${SUPERVISORD_DIR}/bin/supervisord
