# DO280-apps

oc new-project cake-php

### เรัยกใช้ Tempalte ที่ถูกสร้างไว้ก่อน
Template ก็จะเหมือนกับ Helm เช่นกันเพียงแต่จะ proprietary กับ Openshift ซึ่งจริงๆทำเองก็ง่ายมาก

oc get template -n openshift

oc  new-app --template=openshift/cakephp-mysql-example -p DATABASE_USER=linxianer12 -p DATABASE_PASSWORD=cyberpunk2077 

### ทดลองแสดงเฉพาะค่า paramter จาก Template
###### SOURCE_REPOSITORY_REF สำคัญมากการใส่ Branch เพราะไม่อย่านั้นเกิด Default Branch เปลี่ยนเราก็จะผิดไปด้วย
ปัจจุบัน Default Branch ไม่ใช้ Master แต่เป็น Main แทน
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
แล้วจะให้ใช้ Webhook Trigger Build ซึ่งปัจจุบัน Github นั้นใช้ Branch ชื่อ Main แทน Master แล้วนะดังนั้นเราต้องระบุตัว BuildConfig refs ของ Git ด้วยไม่งั้นจะ Build แล้วไม่ยอม Trigger 

```
oc  new-app cakephp-mysql-example -p DATABASE_USER=linxianer12 -p DATABASE_PASSWORD=cyberpunk2077 -p SOURCE_REPOSITORY_URL=https://github.com/wdrdres3qew5ts21/openshift-practice-note -p CONTEXT_DIR=cakephp-ex  -p  SOURCE_REPOSITORY_REF=main

```
###### ตัวอย่าง BuildConfig
```
spec:
  failedBuildsHistoryLimit: 5
  nodeSelector: null
  output:
    to:
      kind: ImageStreamTag
      name: cakephp-mysql-example:latest
  postCommit:
    script: ./vendor/bin/phpunit
  resources: {}
  runPolicy: Serial
  source:
    contextDir: cakephp-ex
    git:
      ref: main
      uri: https://github.com/wdrdres3qew5ts21/openshift-practice-note
    type: Git

```
##### เซ็ทได้ทั้งแผงเลย
อ้างถึง configmap จากอีกที่แล้ว Inject ลงไปเอาไว้ใช้ตอนสอบได้นะอย่างเทพเลย !
```
oc set env dc/cakephp-mysql-example --from cm/webserver

      - env:
        - name: DATABASE_SERVICE_NAME
          value: mysql
        - name: DATABASE_ENGINE
          value: mysql
        - name: DATABASE_NAME
          value: default
        - name: DATABASE_USER
          valueFrom:
            secretKeyRef:
              key: database-user
              name: cakephp-mysql-example
        - name: DATABASE_PASSWORD
          valueFrom:
            secretKeyRef:
              key: database-password
              name: cakephp-mysql-example
        - name: CAKEPHP_SECRET_TOKEN
          valueFrom:
            secretKeyRef:
              key: cakephp-secret-token
              name: cakephp-mysql-example
        - name: CAKEPHP_SECURITY_SALT
          valueFrom:
            secretKeyRef:
              key: cakephp-security-salt
              name: cakephp-mysql-example
        - name: OPCACHE_REVALIDATE_FREQ
          value: "2"
        - name: PORT
          valueFrom:
            configMapKeyRef:
              key: PORT
              name: webserver
        - name: URL
          valueFrom:
            configMapKeyRef:
              key: URL
              name: webserver
```
ทดลองสร้าง Secret แบบ Reference ง่ายๆดูดีกว่าซิ้
```
[linxianer12@localhost openshift-practice-note]$ oc set env deployment custom-web --from cm/webserver --from secret/webserver --dry-run=true -oyaml 
W0115 13:34:46.644482   10460 helpers.go:567] --dry-run=true is deprecated (boolean value) and can be replaced with --dry-run=client.
apiVersion: apps/v1
kind: Deployment
metadata:
  annotations:
    deployment.kubernetes.io/revision: "1"
  creationTimestamp: "2021-01-15T06:33:40Z"
  generation: 1
  labels:
    app: custom-web
  name: custom-web
  namespace: cake-mono-repo
  resourceVersion: "493009021"
  selfLink: /apis/apps/v1/namespaces/cake-mono-repo/deployments/custom-web
  uid: a06e1441-3a5a-4287-bd60-1715321e158d
spec:
  progressDeadlineSeconds: 600
  replicas: 1
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      app: custom-web
  strategy:
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
    type: RollingUpdate
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: custom-web
    spec:
      containers:
      - env:
        - name: DATABASE_PASSWORD
          valueFrom:
            secretKeyRef:
              key: DATABASE_PASSWORD
              name: webserver
        - name: FB_KEY
          valueFrom:
            secretKeyRef:
              key: FB_KEY
              name: webserver
        image: quay.io/linxianer12/apache:1.0.15
        imagePullPolicy: IfNotPresent
        name: apache
        resources: {}
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
      dnsPolicy: ClusterFirst
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext: {}
      terminationGracePeriodSeconds: 30
status:
  conditions:
  - lastTransitionTime: "2021-01-15T06:33:40Z"
    lastUpdateTime: "2021-01-15T06:33:40Z"
    message: Deployment does not have minimum availability.
    reason: MinimumReplicasUnavailable
    status: "False"
    type: Available
  - lastTransitionTime: "2021-01-15T06:33:40Z"
    lastUpdateTime: "2021-01-15T06:33:40Z"
    message: ReplicaSet "custom-web-7b85767775" is progressing.
    reason: ReplicaSetUpdated
    status: "True"
    type: Progressing
  observedGeneration: 1
  replicas: 1
  unavailableReplicas: 1
  updatedReplicas: 1
[linxianer12@localhost openshift-practice-note]$ oc set env deployment custom-web --from cm/webserver 
deployment.apps/custom-web updated
[linxianer12@localhost openshift-practice-note]$ oc set env deployment custom-web --from secet/webserver


[linxianer12@localhost openshift-practice-note]$ oc set env deployment custom-web --from secret/webserver
deployment.apps/custom-web updated
[linxianer12@localhost openshift-practice-note]$ oc get deployment custom-web
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
custom-web   0/1     1            0           117s
[linxianer12@localhost openshift-practice-note]$ oc get deployment custom-web -oyaml
apiVersion: apps/v1
kind: Deployment
metadata:
  annotations:
    deployment.kubernetes.io/revision: "3"
  creationTimestamp: "2021-01-15T06:33:40Z"
  generation: 3
  labels:
    app: custom-web
  name: custom-web
  namespace: cake-mono-repo
  resourceVersion: "493012026"
  selfLink: /apis/apps/v1/namespaces/cake-mono-repo/deployments/custom-web
  uid: a06e1441-3a5a-4287-bd60-1715321e158d
spec:
  progressDeadlineSeconds: 600
  replicas: 1
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      app: custom-web
  strategy:
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
    type: RollingUpdate
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: custom-web
    spec:
      containers:
      - env:
        - name: PORT
          valueFrom:
            configMapKeyRef:
              key: PORT
              name: webserver
        - name: URL
          valueFrom:
            configMapKeyRef:
              key: URL
              name: webserver
        - name: DATABASE_PASSWORD
          valueFrom:
            secretKeyRef:
              key: DATABASE_PASSWORD
              name: webserver
        - name: FB_KEY
          valueFrom:
            secretKeyRef:
              key: FB_KEY
              name: webserver
        image: quay.io/linxianer12/apache:1.0.15
        imagePullPolicy: IfNotPresent
        name: apache
        resources: {}
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
      dnsPolicy: ClusterFirst
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext: {}
      terminationGracePeriodSeconds: 30
status:
  conditions:
  - lastTransitionTime: "2021-01-15T06:33:40Z"
    lastUpdateTime: "2021-01-15T06:33:40Z"
    message: Deployment does not have minimum availability.
    reason: MinimumReplicasUnavailable
    status: "False"
    type: Available
  - lastTransitionTime: "2021-01-15T06:33:40Z"
    lastUpdateTime: "2021-01-15T06:35:30Z"
    message: ReplicaSet "custom-web-68c49977f4" is progressing.
    reason: ReplicaSetUpdated
    status: "True"
    type: Progressing
  observedGeneration: 3
  replicas: 2
  unavailableReplicas: 2
  updatedReplicas: 1
```

#### Set Volume โดยโยน Secret เข้าไป
การทำก็ง่ายมากเพียงแค่ใส่ flag --add ลงไปในนั้นไม่ก็ --remove
oc set volume deployment todoapp --mount-path=/var/www/html --add --name=firebase-volume --secret-name=firebase-secret
```
    spec:
      containers:
      - image: quay.io/linxianer12/todoapp:1.0.12
        imagePullPolicy: IfNotPresent
        name: todoapp
        resources: {}
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
        volumeMounts:
        - mountPath: /var/www/html
          name: firebase-volume
      dnsPolicy: ClusterFirst
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext: {}
      terminationGracePeriodSeconds: 30
      volumes:
      - name: firebase-volume
        secret:
          defaultMode: 420
          secretName: firebase-secret

```
#####  สร้าง project nodejs ส่งค่า ENV
oc new-app https://github.com/wdrdres3qew5ts21/openshift-practice-note   --context-dir=DO288-Developer/app-config/  --as-deployment-config --name  backend-api -e APP_MSG="DevOps is culture to Accerelate Organize !"

oc create secret generic myapp.sec  --from-env-file=myapp.sec --dry-run -oyaml | oc apply -f -


##### สร้างแอพ Java 
ถ้าปลายทางที่ Dockerfiel อยุ่แล้วระบบจะทำการ Detect ใช้ Dockerfile ในการ Build แต่ถ้าเกิดเรามีแต่เราอยากใช้ S2I เราสามารถทำได้โดยการบังคับ Strategy ลงไปนั่นเอง
oc new-app https://github.com/wdrdres3qew5ts21/openshift-practice-note   --context-dir=DO288-Developer/hello-java/app-src  --as-deployment-config --name  hello-java --strategy=source

