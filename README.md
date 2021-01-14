# DO280-apps

oc new-project cake-php

### เรัยกใช้ Tempalte ที่ถูกสร้างไว้ก่อน
Template ก็จะเหมือนกับ Helm เช่นกันเพียงแต่จะ proprietary กับ Openshift ซึ่งจริงๆทำเองก็ง่ายมาก

oc get template -n openshift

oc  new-app --template=openshift/cakephp-mysql-example -p DATABASE_USER=linxianer12 -p DATABASE_PASSWORD=cyberpunk2077 

### ทดลองแสดงเฉพาะค่า paramter จาก Template
```
[linxianer12@localhost project]$ oc process  --parameters  -n openshift  cakephp-mysql-example
NAME                      DESCRIPTION                                                                                                                     GENERATOR           VALUE
NAME                      The name assigned to all of the frontend objects defined in this template.                                                                          cakephp-mysql-example
NAMESPACE                 The OpenShift Namespace where the ImageStream resides.                                                                                              openshift
PHP_VERSION               Version of PHP image to be used (7.3 or latest).                                                                                                    7.3
MEMORY_LIMIT              Maximum amount of memory the CakePHP container can use.                                                                                             512Mi
MEMORY_MYSQL_LIMIT        Maximum amount of memory the MySQL container can use.                                                                                               512Mi
SOURCE_REPOSITORY_URL     The URL of the repository with your application source code.                                                                                        https://github.com/sclorg/cakephp-ex.git
SOURCE_REPOSITORY_REF     Set this to a branch name, tag or other ref of your repository if you are not using the default branch.                                             
CONTEXT_DIR               Set this to the relative path to your project if it is not in the root of your repository.                                                          
APPLICATION_DOMAIN        The exposed hostname that will route to the CakePHP service, if left blank a value will be defaulted.                                               
GITHUB_WEBHOOK_SECRET     Github trigger secret.  A difficult to guess string encoded as part of the webhook URL.  Not encrypted.                         expression          [a-zA-Z0-9]{40}
DATABASE_SERVICE_NAME                                                                                                                                                         mysql
DATABASE_ENGINE           Database engine: postgresql, mysql or sqlite (default).                                                                                             mysql
DATABASE_NAME                                                                                                                                                                 default
DATABASE_USER                                                                                                                                                                 cakephp
DATABASE_PASSWORD                                                                                                                                         expression          [a-zA-Z0-9]{16}
CAKEPHP_SECRET_TOKEN      Set this to a long random string.                                                                                               expression          [\w]{50}
CAKEPHP_SECURITY_SALT     Security salt for session hash.                                                                                                 expression          [a-zA-Z0-9]{40}
OPCACHE_REVALIDATE_FREQ   How often to check script timestamps for updates, in seconds. 0 will result in OPcache checking for updates on every request.                       2
COMPOSER_MIRROR           The custom Composer mirror URL 
```

### ทดลอง Build จาก Context ข้างใน
แล้วจะให้ใช้ Webhook Trigger Build
```
oc  new-app cakephp-mysql-example -p DATABASE_USER=linxianer12 -p DATABASE_PASSWORD=cyberpunk2077 -p SOURCE_REPOSITORY_URL=https://github.com/wdrdres3qew5ts21/openshift-practice-note -p CONTEXT_DIR=cakephp-ex  -p  SOURCE_REPOSITORY_REF=main

```

