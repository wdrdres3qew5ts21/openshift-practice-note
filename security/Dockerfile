from registry.redhat.io/ubi8:8.3

maintainer Naomi Lin wdrdres3qew5ts21@gmail.com

workdir /app

env PORT=80\
    MYNAME=linxianer12\
    MOTTO=TechForGood \
    QUOTE=SpeedExecuteTogether

run yum install -y nginx &&  yum clean all 

expose ${PORT}

copy portfolio /usr/share/nginx/html

cmd ["nginx", "-g","daemon off;"]


