FROM registry.redhat.io/ubi8:8.3
EXPOSE 9000
RUN yum update -y &&yum install httpd -y && yum clean all  \
    && sed -i "s/Listen 80/Listen 9000/g"  /etc/httpd/conf/httpd.conf \
    && chgrp -R root /var/www/html \
    && chmod 770 -R /var/www/html

ENTRYPOINT ["httpd"]
CMD ["-D","FOREGROUND"]