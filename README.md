# Openshift Developer Guide
![](https://miro.medium.com/max/7200/1*Z62rvB0bm_gfKkQRNEuxVg.png)

### [Blog Medium: ทำความเข้าใจ Container Security ใน Openshift และ Kubernetes ผ่าน Linux Capabilities และ SELinux](https://wdrdres3qew5ts21.medium.com/%E0%B8%97%E0%B8%B3%E0%B8%84%E0%B8%A7%E0%B8%B2%E0%B8%A1%E0%B9%80%E0%B8%82%E0%B9%89%E0%B8%B2%E0%B9%83%E0%B8%88-container-security-%E0%B9%83%E0%B8%99-openshift-%E0%B9%81%E0%B8%A5%E0%B8%B0-kubernetes-%E0%B8%9C%E0%B9%88%E0%B8%B2%E0%B8%99-linux-capabilities-%E0%B9%81%E0%B8%A5%E0%B8%B0-selinux-ce6e5d622469)

เมื่อพูดถึง Red Hat Linux หลายๆคนก็จะนึกถึง Linux OS ที่มีความเสถียรและนิยมใช้การใน Production ระยะยาวที่ต้องการ Support ใน Enterprise ต่างๆซึ่ง Openshift เองนั้นก็เป็น Kubernetes Distribution หนึ่งที่ Red Hat เข้าไป Contribute มานานแล้วตั้งแต่ Kubernetes เกิดขึ้นมาใหม่ๆ แน่นอนว่าเสน่ห์ในเรื่องของ Security อันเป็นเอกลักษณ์ของ Red Hat ก็ตามมาด้วยอย่างเรื่องของ SELinux แต่จะมาโฟกัสให้กับ โลกที่เป็น Container แต่กระนั้นเองบางคนอาจจะสงสัยว่าเอ๊ Container มันไปมีเรื่องของ Security อะไรแบบนี้ด้วยหรือเนี่ยแล้วมันเกี่ยวอะไรกับ SELinux กันนะซึ่งสำหรับตัวผมเองที่ลองศึกษามาบ้างก็พบว่าจริงๆแล้ว Feature Security ของ Container ที่ Deploy ใน Kubernetes นั้นมีเป็นปกติแต่เดิมอยู่แล้ว  เพียงแต่ว่าเราอาจจะไมไ่ด้ไปสนใจมันสักเท่าไหร่นัก แต่ถ้าเกิดเราลองใช้ Container บางตัวเช่น Busybox แล้วไป Deploy ใน Openshift หรือ Kubernetes บาง Cluster ที่อาจจะมี Envrionment ที่เซ็ทอัพ Security Context เอาไว้เราอาจจะพบว่าเราไม่สามารถ Ping ออกจาก Container นั้นได้เป็นเพราะไม่ได้ให้สิทธิ Linux Capabilities ซึ่งจากภาพข้างล่างนั้นเป็นตัวอย่างของ Pod ที่ได้สิทธิในการที่ Container ใน Pod นั้นสามารถตั้งค่า Network ต่างๆเช่น Routing, Firewall และก็สามารถเปลี่ยนเวลาได้นั่นเอง ซึ่งภาพนี้ก็มาจาก Document โดยตรงเองของ Kubernetes ในหัวข้อของ
[Security Context Container - Linux Capabilities](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-capabilities-for-a-container)
![](image/security/1.pod%20capability.png)

ซึ่งสำหรับในมุมของ Developer ใหม่ๆอย่างผมเองโดยปกติก็อาจจะไม่ได้ค่อยมาเซ็ทค่าเหล่านี้บ่อยๆนักแต่เมื่อเราได้ลองมา Deploy Container ใน Kubernetes สภาพแวดล้อมที่ให้ความสำคัญกับเรื่องเหล่านี้ก็ทำให้ผมเห็นภาพมากขึ้นว่าเรื่องของ Security ถึงเราจะตามไป Container ก็ยังตามมา
ซึ่งสำหรับใครที่ยังนึกภาพไม่ออกเดี่ยวเราจะเริ่มจากการใช้ Podman ในการสร้าง Container ก่อนซึ่งที่ใช้ Podman ก็เพราะว่าตัว Podman นั้น Implement ตามมาตราฐานของ format Open Container Initiative ตั้งแต่แรกรวมไปถึงการที่ Container Network Interface (CNI) เองเองก็ Implement จาก Standard กลางซึ่งจะมีความคล้ายกับ Network ใน Kubernetes ซึ่งจะต้องลงทั้ง CNI แล้วก็ Container Runtime Interface (CRI)
ทำให้ในบางจุดเช่นการดู Network Bridge Interface นั้นสามารถเข้าไปดูได้ตรงๆเห็นภาพผ่านคำสั่งอย่าง ip netns ก็เลยเลือก Podman ซึ่งสามารถแสดงให้เห็นถึงเรื่องพวกนี้ได้ง่ายๆหน่ะครับ กับด้วยคุณสมบัติการทำ Linux Capabilities เองก็อยู่ในตัว Podman เรียบร้อยแล้ว
ซึ่งชื่อของมันก็เลยเรียกว่า Podman เพราะเป็นการจำลองเอาคุณสมบัติของ Pod ใน Kubernetes มาใช้ให้เห็นภาพมากขึ้นกว่า Container ตรงๆอย่าง Docker นั่นเอง (แต่น้องปลาวาฬไมไ่ด้ผิดอะไรนะ แง 5555) 
ซึ่งพื้นฐานของ Podman กับความเป็นมาของ Container จริงๆก็สามารถลองไปอ่านของ Blog คุณพี่ suseman ได้เลยครับผม (SUSE กับ Red Hat ก็พันธมิตรกันได้นะ รู้เขารู้เรา 55555)

(MicroOS Container: Podman ทางเลือกใหม่สำหรับผู้ใช้ Docker)[https://www.suseman.biz/podman-docker/]

podman run -d   --cap-drop=net_admin  --cap-drop=net_raw   docker.io/praqma/network-multitool

podman run docker.io/praqma/network-multitool

หลังจากที่เราเห็น Linux Capabilities ไปแล้วต่อไปเราจะลองมาดูในส่วนของ SELinux กันบ้างว่ามีผลอย่างไรกันบ้าง



โดยเราจะลองมาดูกันว่าให้ความสำคัญกับเรื่องของ Security เป็นพิเศษเมื่อเทียบกับ Kubernetes Distribution โดยทั่วๆ

### Inspect Container
docker:// ใช้เรียกบน HTTP ส่วน containers-storage: ใช้กับ podman ส่วน docker-daemon: ใช้กับ image ที่มีอยู่ในครเื่องเราของ docker 
ดูคำสั่งเพิ่มเติมได้จาก man skopeo
```
[linxianer12@localhost Certified-Rancher-Operator-Thai]$ skopeo inspect containers-storage:quay.io/linxianer12/apache:1.0.1                                                       
{                                                                                                                                                                                 
    "Name": "quay.io/linxianer12/apache",                                                                                                                                         
    "Digest": "sha256:73c33bda154d41e9fdb5469f4e48d66f515f1318e15634f51dbc68a828f0e757",                                                                                          
    "RepoTags": [],                                                                                                                                                               
    "Created": "2021-01-11T15:31:29.161828018Z",                                                                                                                                  
    "DockerVersion": "",                                                                                                                                                          
    "Labels": {                                                                                                                                                                   
        "architecture": "x86_64",                                                                                                                                                 
        "authoritative-source-url": "registry.access.redhat.com",                                                                                                                 
        "build-date": "2020-03-10T10:38:13.657446",                                                                                                                               
        "com.redhat.build-host": "cpt-1004.osbs.prod.upshift.rdu2.redhat.com",                                                                                                    
        "com.redhat.component": "ubi7-container",                                                                                                                                 
        "com.redhat.license_terms": "https://www.redhat.com/en/about/red-hat-end-user-license-agreements#UBI",                                                                    
        "description": "The Universal Base Image is designed and engineered to be the base layer for all of your containerized applications, middleware and utilities. This base i
mage is freely redistributable, but Red Hat only supports Red Hat technologies through subscriptions for Red Hat products. This image is maintained by Red Hat and updated regular
ly.",                                                                                                                                                                             
        "distribution-scope": "public",
        "io.buildah.version": "1.18.0",
        "io.k8s.description": "The Universal Base Image is designed and engineered to be the base layer for all of your containerized applications, middleware and utilities. This base image is freely redistributable, but Red Hat only supports Red Hat technologies through subscriptions for Red Hat products. This image is maintained by Red Hat and updated regularly.",
        "io.k8s.display-name": "Red Hat Universal Base Image 7",

```


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
ถ้าปลายทางที่ Dockerfiel อยุ่แล้วระบบจะทำการ Detect ใช้ Dockerfile ในการ Build แต่ถ้าเกิดเรามีแต่เราอยากใช้ S2I เราสามารถทำได้โดยการบังคับ Strategy ลงไปนั่นเอง โดยเราจะเริ่มลงองแบบ Build ดิบๆกาอนโดยชี้ไปที่ Source Code เลยเพื่อทำ S2I และจากนั้นจะลองมาแก้ปัญหา Docker ไม่สามารถ Excuted ไฟล์ได้กัน
oc new-app https://github.com/wdrdres3qew5ts21/openshift-practice-note   --context-dir=DO288-Developer/hello-java/app-src  --as-deployment-config --name  hello-java --strategy=source

oc new-app https://github.com/wdrdres3qew5ts21/openshift-practice-note   --context-dir=DO288-Developer/hello-java  --as-deployment-config --name  hello-java-docker --strategy=source

#### ทดลองสร้าง JAVA EE War
```
oc new-app https://github.com/wdrdres3qew5ts21/openshift-practice-note   --context-dir=DO288-Developer/micro-java/  --as-deployment-config --name  micro-java
```

จะพบว่า Java EE มันใช้ War pack แล้วไม่มีตัว build 
```
I0119 15:34:34.401465   22249 imagestreamlookup.go:329] No tags found on image, returning nil
error: unable to locate any images in image streams, image stream images with a 'supports' annotation, local docker images with name "jee"

The 'oc new-app' command will match arguments to the following types:

  1. Images tagged into image streams in the current project or the 'openshift' project
     - if you don't specify a tag, we'll add ':latest'
  2. Images in the Docker Hub, on remote registries, or on the local Docker engine
  3. Templates in the current project or the 'openshift' project
  4. Git repository URLs or local paths that point to Git repositories

--allow-missing-images can be used to point to an image that does not exist yet.

See 'oc new-app -h' for examples.

```
วิธีการแก้ไขก้คือจริงๆแล้ว Java EE มันก้ใช้ Maven ปกติ build ได้เหมือนกันนะเหมืนที่เรารันโปรแกรมในเครื่องเราโดยใช้คำสั่ง mvn thorntail:run ปุ๊ปเราจะได้ .war  มาซึ่งเพราะการเป้น .war ถ้าเราไป build บน openshift มันเลย detect เป็น java EE และถ้าไป inspect ใน ImageStream จะพบว่า buider ไม่มี jee ดั่งที่ error แสดงแสดงผลเลย วิธีการแก้ก็คือเราจะทำการสร้าง tag ใหม่ให้ฟิลลิ่งเหมือน podman tag image นั่นแหละที่เราทำการ tag ชื่อ image ให้โดย image ที่ tag ก็จะอยู่ใน namespace ที่เราเลือกไว้

```
[linxianer12@localhost openshift-practice-note]$ oc tag openshift/openjdk-11-rhel8:1.1 jee:latest
Tag jee:latest set to openshift/openjdk-11-rhel8@sha256:5c1bb0a3e2b5ce9018e990dfef68fd040e8584975d05eee109ee4f3daf0366e1.
[linxianer12@localhost openshift-practice-note]$ oc describe is jee
Name:			jee
Namespace:		developer
Created:		20 minutes ago
Labels:			<none>
Annotations:		openshift.io/image.dockerRepositoryCheck=2021-01-19T09:07:42Z
Image Repository:	default-route-openshift-image-registry.apps.shared-na4.na4.openshift.opentlc.com/developer/jee
Image Lookup:		local=false
Unique Images:		2
Tags:			3

latest
  tagged from openshift/openjdk-11-rhel8@sha256:5c1bb0a3e2b5ce9018e990dfef68fd040e8584975d05eee109ee4f3daf0366e1

  * registry.redhat.io/openjdk/openjdk-11-rhel8@sha256:5c1bb0a3e2b5ce9018e990dfef68fd040e8584975d05eee109ee4f3daf0366e1
      3 seconds ago

1.1
  tagged from openshift/openjdk-11-rhel8@sha256:5c1bb0a3e2b5ce9018e990dfef68fd040e8584975d05eee109ee4f3daf0366e1

  * registry.redhat.io/openjdk/openjdk-11-rhel8@sha256:5c1bb0a3e2b5ce9018e990dfef68fd040e8584975d05eee109ee4f3daf0366e1
      2 minutes ago

1.0
  tagged from openshift/openjdk-11-rhel8@sha256:be1710f21cdb76f0ae5b11668f2132fc2699ae77eae536f6ea2aab7be4a37d01

  * registry.redhat.io/openjdk/openjdk-11-rhel8@sha256:be1710f21cdb76f0ae5b11668f2132fc2699ae77eae536f6ea2aab7be4a37d01
      3 minutes ago

```
หลังจากที่มี iamgestream JEE แล้วเราก็จะสามารถให้โปรแกรมเราสามารถ build ได้แล้วนั่นเอง :)
```
[linxianer12@localhost openshift-practice-note]$ oc get istag 
NAME                 IMAGE REFERENCE                                                                                                                                  UPDATED
backend-api:latest   image-registry.openshift-image-registry.svc:5000/developer/backend-api@sha256:a8a7646b0feb1a97a31b4d6c07a9be3fdda6121fd452072dd60bfbbb7fc5db83   45 minutes ago
debug:latest         quay.io/redhattraining/hello-world-nginx@sha256:7f99ece5f39bf8d5d76a43cd9104a8d0a39f7135821b94bc1ebdc39cdc6dd63b                                 24 hours ago
jee:latest           registry.redhat.io/openjdk/openjdk-11-rhel8@sha256:5c1bb0a3e2b5ce9018e990dfef68fd040e8584975d05eee109ee4f3daf0366e1                              About a minute ago
jee:1.0              registry.redhat.io/openjdk/openjdk-11-rhel8@sha256:be1710f21cdb76f0ae5b11668f2132fc2699ae77eae536f6ea2aab7be4a37d01                              4 minutes ago
jee:1.1              registry.redhat.io/openjdk/openjdk-11-rhel8@sha256:5c1bb0a3e2b5ce9018e990dfef68fd040e8584975d05eee109ee4f3daf0366e1                              3 minutes ago
registry:latest      docker.io/registry@sha256:a0dd61073ad21122e5f1517682800272ef29df52041aaea7ee29e92a5d22aa28                                                       28 hours ago
todoapp:1.0.12       image-registry.openshift-image-registry.svc:5000/developer/todoapp@sha256:e3fed634d042775d0e414c51cabd05d03cb497a04e0e34e5b3eb767f6584725c       25 hours ago

```

###### ทดลองกลับไปสร้าง JEE ใหม่ใน namespace ที่เราใช้งานอยู่
จะพบว่าเราสามารถ build image ได้แล้วจากการที่ตัว detect เจอเป็น java ee
```
oc new-app https://github.com/wdrdres3qew5ts21/openshift-practice-note   --context-dir=DO288-Developer/micro-java/  --as-deployment-config --name  micro-java


[linxianer12@localhost openshift-practice-note]$ oc new-app https://github.com/wdrdres3qew5ts21/openshift-practice-note   --context-dir=DO288-Developer/micro-java/  --as-deployment-config --name  micro-java
--> Found image 8bd2b21 (13 months old) in image stream "developer/jee" under tag "latest" for "jee"

    Java Applications 
    ----------------- 
    Platform for building and running plain Java applications (fat-jar and flat classpath)

    Tags: builder, java

    * The source repository appears to match: jee
    * A source build using source code from https://github.com/wdrdres3qew5ts21/openshift-practice-note will be created
      * The resulting image will be pushed to image stream tag "micro-java:latest"
      * Use 'oc start-build' to trigger a new build
    * This image will be deployed in deployment config "micro-java"
    * Ports 8080/tcp, 8443/tcp, 8778/tcp will be load balanced by service "micro-java"
      * Other containers can access this service through the hostname "micro-java"

--> Creating resources ...
    error: imagestreamtag.image.openshift.io "micro-java:latest" already exists
    error: buildconfigs.build.openshift.io "micro-java" already exists
    deploymentconfig.apps.openshift.io "micro-java" created
    error: services "micro-java" already exists
--> Failed

```
ปัญหาที่เหมือนจะแก้ได้แล้วเพราะพบว่า describe imagestream แล้วไม่ติด authon แต่ดันไปติดตอนกำลังจะ build จริงๆแทน
```
oc [linxianer12@localhost openshift-practice-note]$ oc get pod
NAME                       READY   STATUS      RESTARTS   AGE
backend-api-1-build        0/1     Completed   0          62m
backend-api-1-deploy       0/1     Completed   0          61m
backend-api-1-xfg6x        1/1     Running     0          61m
debug-664b74d884-vw247     1/1     Running     0          18h
micro-java-1-build         0/1     Error       0          17m
mysql-1-deploy             0/1     Completed   0          153m
mysql-1-rlmc2              1/1     Running     0          153m
registry-5b5795b4d-2nlxd   1/1     Running     0          18h
todoapp-7d8bb7bfbf-pxqxg   1/1     Running     0          18h
[linxianer12@localhost openshift-practice-note]$ oc logs -f micro-java-1-build
Caching blobs under "/var/cache/blobs".
Warning: Pull failed, retrying in 5s ...
Warning: Pull failed, retrying in 5s ...
Warning: Pull failed, retrying in 5s ...
error: build error: After retrying 2 times, Pull image still failed due to error: unable to retrieve auth token: invalid username/password: unauthorized: Please login to the Red Hat Registry using your Customer Portal credentials. Further instructions can be found here: https://access.redhat.com/RegistryAuthentication

```
เราเลยต้องแก้ด้วยการที่ point reference address ไปหา ImageStream ใน NameSapce openhift ที่มี Credentials จริงๆแทนนั่นเอง !

oc process -f mysql-template.yaml -p MYSQL_USER=linxianer12 -p DATABASE_SERVICE_NAME=lnwza-svc -o yaml > filled-template.yaml คือการประมวลผลค่าแล้ว inject ค่าลงไปใน Place Hodler มันเลยเรียกว่า Process Template นั่นเองซึ่งเราสามารถเอาไปทำ Tempalte ต่างๆได้


##### Persistent Volume 
การที่เราใช้ PV จะทำให้เราสามารถแชร์ข้อมูล Data ของ Stateful Application ได้ตัวอย่างเช่นถ้าเราลองแก้ pod nginx ให้แสดงผลกันต่างออกไปจากเดิมเมื่อเราใช้การ Replicas แล้วสิ่งที่ตามมาก้คือจะมี Pod ที่ Config ไม่เหมือนกันต่างจากเดิมกันออกไปซึ่งถ้าเราอยากให้ข้อมูลใน 
Volume Share แล้วเหมือนกันก็จะต้องเลือกเป็น PV แล้วไปทำการแชร์ Volume กันแนั่นเอง  แต่ก็จะมีเรื่องการ RWO หรือ RWX ด้วยนะซึ่ง many จะทำให้หลายๆ node เข้ามาอ่าน Share Volume ด้วยกันได้ (Solution Storage ต้องรองรับดว้ยนะ) ส่วน ถ้าไม่รองรองรับก็ควรให้ Pod อ่าน PV ที่อยู่ในเครื่องเดียวกันไปเลยเพราะว่าเร็วกว่าด้วยนั่นเอง

##### Source to Image S2I custom
หลักการที่ Openshift มันสามารถ Build Source Code ได้นั่นก็เพราะว่ามันใช้คำสั่งที่ซ่อนใน Based Image แล้วไป Exexute การ Build นั่นเองแล้วพอมันไ่มี /usr/libexec/s2i/assemble
ก็ทำให้ error ไปนั่นเอง ! เพราะ automate detect script ไม่มี
```

[linxianer12@localhost micro-java]$ oc logs -f openshift-practice-note-1-build
Caching blobs under "/var/cache/blobs".
Getting image source signatures
Copying blob sha256:a076a628af6f7dcabc536bee373c0d9b48d9f0516788e64080c4e841746e6ce6
Copying blob sha256:eba5b958e0416b8e5d7b2ae81a51f33cfba67f5d9ea139a5ffd099b8956dfdec
Copying blob sha256:943d8acaac04a2b66af03bcc85abe1cd3f50e06d7e193634e04d4e55c4fc7cc8
Copying blob sha256:b9998d19c11696925915d7583990a0b9e239265533655abc5376d117ec9cfe3c
Copying config sha256:9c3b768888cc4b79acd16e7fc3f56939615fa33a59417fd1494f5b8b48d67ec3
Writing manifest to image destination
Storing signatures
Generating dockerfile with builder image docker.io/openjdk@sha256:27ed5651bb4be96bbdc8779c69acd912391950ff79bd6909ccc295c8eec2e52b
STEP 1: FROM docker.io/openjdk@sha256:27ed5651bb4be96bbdc8779c69acd912391950ff79bd6909ccc295c8eec2e52b
STEP 2: LABEL "io.openshift.build.commit.message"="[ADD] วิธีการ Tag Image สำหรับ Build Java EE จาก Image ที่มีอยู่แล้ว"       "io.openshift.build.source-location"="https://github.com/wdrdres3qew5ts21/openshift-practice-note"       "io.openshift.build.source-context-dir"="DO288-Developer/micro-java"       "io.openshift.build.image"="docker.io/openjdk@sha256:27ed5651bb4be96bbdc8779c69acd912391950ff79bd6909ccc295c8eec2e52b"       "io.openshift.build.commit.author"="Naomi Lin <linxianer12@localhost.localdomain>"       "io.openshift.build.commit.date"="Tue Jan 19 16:19:54 2021 +0700"       "io.openshift.build.commit.id"="71a5863b095a7b485f719778190f83caa7374255"       "io.openshift.build.commit.ref"="main"
STEP 3: ENV OPENSHIFT_BUILD_NAME="openshift-practice-note-1"     OPENSHIFT_BUILD_NAMESPACE="developer"     OPENSHIFT_BUILD_SOURCE="https://github.com/wdrdres3qew5ts21/openshift-practice-note"     OPENSHIFT_BUILD_COMMIT="71a5863b095a7b485f719778190f83caa7374255"
STEP 4: USER root
STEP 5: COPY upload/src /tmp/src
STEP 6: RUN chown -R 1001:0 /tmp/src
STEP 7: USER 1001
STEP 8: RUN /usr/libexec/s2i/assemble
/bin/sh: 1: /usr/libexec/s2i/assemble: not found
subprocess exited with status 127
subprocess exited with status 127
error: build error: error building at STEP "RUN /usr/libexec/s2i/assemble": exit status 127

```

oc apply -f todoapp-template.yaml

oc new-app   --template=todoapp-template -l os=RHEL8 -l author=linxianer12 -p CUSTOM_LABEL=lnwza007label

###### ทำการ Deploy Frontend Backend และ DB แล้วประกอบเข้าด้วยกันด้วยการใช้ Template
oc new-app openshift/mysql-persistent -p MYSQL_USER=linxianer12 -p MYSQL_PASSWORD=cyberpunk2077 -p MYSQL_ROOT_PASSWORD=cyberpunk2077 -p MYSQL_DATABASE=telecom

oc new-app https://github.com/wdrdres3qew5ts21/openshift-practice-note   --context-dir=DO288-Developer/todo-backend --name todo-backend -e DATABASE_NAME=telecom -e DATABASE_USER=linxianer12 -e DATABASE_PASSWORD=cyberpunk2077 -e DATABASE_SVC=mysql


ดู env จาก nginx.conf พบว่าน่าจะ injectt ตัวแปรเข้าไปได้

oc new-app https://github.com/wdrdres3qew5ts21/openshift-practice-note   --context-dir=DO288-Developer/todo-frontend --name todo-frontend  -e BACKEND_HOST=todo-backend:8080 --strategy=docker

###### Probe ทดสอบ Health
oc new-app https://github.com/wdrdres3qew5ts21/openshift-practice-note   --context-dir=DO288-Developer/probes/  --as-deployment-config --name  probes


### สร้าง Project ต่อกัน
นำ DB MySQL มาต่อกับ Frontend Backend Quarkus
```
oc get template -n openshift
```
process ใช้ในการแสดง Parameter ของ Template ซึ่งจะไม่สร้างให่แต่จะโชว์ paramter เดิม
```
oc process  -n openshift mysql-ephemeral  --parameters
```
สร้าง password และแถม label ให้
```
oc new-app mysql-ephemeral -p MYSQL_USER=linxianer12 -p MYSQL_PASSWORD=cyberpunk2077 -p MYSQL_ROOT_PASSWORD=cyberpunk2077 -l env=dev -l location=thailand

NAME             READY   STATUS      RESTARTS   AGE   LABELS
mysql-1-deploy   0/1     Completed   0          82s   openshift.io/deployer-pod-for.name=mysql-1
mysql-1-fnfjq    1/1     Running     0          78s   deployment=mysql-1,deploymentconfig=mysql,name=mysql
```

เริ่มสร้าง Application 3 Tier
```
oc create secret generic backend-secret --from-literal="DATABASE_URL=mariadb"   --from-literal="DATABASE_USERNAME=linxianer12" --from-literal="DATABASE_PASSWORD=cyberpunk2077"

# Import Image จากทุก Tag เข้ามาต้องมี --from ด้วยไม่อย่างนั้นจะใช้ไมไ่ด้กับ --all ซึ่งเวลา import มาจะได้ SHA@256 ตรงกับใน Container Registryในทุกๆ Version
# สิ่งที่น่าสนใจคือถ้าเราใช้ import-image การใช้ sha256 แล้วเกิดมีการอัพเดททัพกับ version เดิมเช่น 1.1.0 แล้วล่ะก็ !!!! sha ก็จะเปลี่ยนใช้มั้ยล่ะ ?
# และเมื่อเราสั่ง Pull ก็จะหาไม่เจอทันทีเพราะว่า sha ปัจจุบันชี้ไปหา 1.1.0 ของเดิมก่อนอัพเดท แต่ 1.1.0 ถูกอัพเดทไปแล้วหา SHA ใหม่ไม่เจอก็จะอัพเดทไมไ่ด้
oc import-image vue-todoapp-frontend --from=quay.io/linxianer12/vue-todoapp-frontend  --all --confirm

oc new-app --docker-image=quay.io/linxianer12/quarkus-todoapp-backend:1.0.0  --name=quarkus-todoapp-backend

oc set env dc quarkus-todoapp-backend  --from=secret/backend-secret

oc new-app --docker-image=quay.io/linxianer12/vue-todoapp-frontend:1.1.0 --name vue-todoapp-frontend
```


kubectl create deployment --image quay.io/linxianer12/quarkus-todoapp-backend:1.0.0 quarkus-todoapp-backend

kubectl set env deployment quarkus-todoapp-backend --from=secret/backend-secret 

kubectl expose deployment   quarkus-todoapp-backend  --type=NodePort --port=7070 --target-port=7070 --external-ip=192.168.122.215

kubectl create deployment  --image quay.io/linxianer12/vue-todoapp-frontend:1.0.0  vue-todoapp-frontend

kubectl expose deployment vue-todoapp-frontend    --type=NodePort --port=80 --target-port=80 --external-ip=192.168.122.215


 oc new-app --as-deployment-config  https://github.com/wdrdres3qew5ts21/openshift-practice-note --context-dir=DO288-Developer/php-helloworld
