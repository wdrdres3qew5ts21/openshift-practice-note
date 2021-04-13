
# nginx
FROM docker.io/openshift/base-centos7

# TODO: Put the maintainer name in the image metadata
# MAINTAINER Your Name <your@email.com>

# TODO: Rename the builder environment variable to inform users about application you provide them
# ENV BUILDER_VERSION 1.0

# TODO: Set labels used in OpenShift to describe the builder image
LABEL io.k8s.description="Platform for building HTML" \
     io.k8s.display-name="builder HTML" \
     io.openshift.expose-services="8080:http" \
     io.openshift.tags="builder,html,nginx"

# TODO: Install required packages here:
# RUN yum install -y ... && yum clean all -y
RUN yum install epel-release -y && yum install nginx -y && yum clean all
# RUN gem install asdf

COPY nginx.conf /usr/share/nginx/html

RUN touch /run/nginx.pid
RUN chgrp -R 0 /var/log/nginx /run/ && \
    chmod -R 770 /var/log/nginx /run/ && \
    ls -alZ /var/log && \
    ls -alZ /run
  
EXPOSE 8080

# TODO (optional): Copy the builder files into /opt/app-root
# COPY ./<builder_folder>/ /opt/app-root/

# TODO: Copy the S2I scripts to /usr/libexec/s2i, since openshift/base-centos7 image
# sets io.openshift.s2i.scripts-url label that way, or update that label
COPY ./s2i/bin/ /usr/libexec/s2i

# TODO: Drop the root user and make the content of /opt/app-root owned by user 1001
# RUN chown -R 1001:1001 /opt/app-root

# This default user is created in the openshift/base-centos7 image
USER 1001

# TODO: Set the default port for applications built using this image
# EXPOSE 8080

# TODO: Set the default CMD for the image
# CMD ["/usr/libexec/s2i/usage"]
