# DO280-apps

oc new-project cake-php

### เรัยกใช้ Tempalte ที่ถูกสร้างไว้ก่อน
Template ก็จะเหมือนกับ Helm เช่นกันเพียงแต่จะ proprietary กับ Openshift ซึ่งจริงๆทำเองก็ง่ายมาก

oc get template -n openshift

oc  new-app --template=openshift/cakephp-mysql-example -p DATABASE_USER=linxianer12 -p DATABASE_PASSWORD=cyberpunk2077 