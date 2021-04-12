FROM registry.access.redhat.com/ubi8:8.0

LABEL version="1.0" \
      description="To Do List application front-end" \
      creationDate="2017-12-25" \
      updatedDate="2019-08-01"

ENV BACKEND_HOST=localhost:8081

RUN yum install -y --disableplugin=subscription-manager --nodocs \
  nginx nginx-mod-http-perl
RUN yum clean all

COPY nginx.conf /etc/nginx/

COPY src/ /usr/share/nginx/html

RUN touch /run/nginx.pid
RUN chgrp -R 0 /var/log/nginx /run/ && \
    ls -alZ /var/log && \
    ls -alZ /run
  
EXPOSE 8080

CMD nginx -g "daemon off;"

