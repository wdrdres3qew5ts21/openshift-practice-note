FROM docker.io/praqma/network-multitool
RUN echo pusheen::1001:0::/home/pusheen:/usr/bin/zsh >> /etc/passwd && \
    chgrp 0 -R  /etc/nginx/ && \
    chgrp 0 -R /var/cache/nginx/ && \
    chgrp 0 -R /usr/share/nginx/ && \
    chgrp 0 -R /var/run && \
    chmod 770 -R /usr/share/nginx/ && \
    chmod 770 -R /var/cache/nginx/ && \
    chmod 770 -R /usr/share/nginx/ && \
    chmod 770 -R /var/run/ && \
    chmod 770 -R /var/lib/nginx/  && chmod 770 -R /certs/ && \
    chgrp 0 -R /var/lib/nginx/  && chmod 0 -R /certs/ 
    
