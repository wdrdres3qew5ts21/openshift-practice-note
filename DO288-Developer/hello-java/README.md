oc create cm throntail-config --from-literal APP_MSG="End of Life Support please go to Quarkus JAVA EE is Dead !"

oc set env dc/hello-java-docker --from=cm/throntail-config 

เป็นไปอย่งาที่เข้าใจคือ user container อยู่ใน group root เสมอเราเลยต้องให้สิทธิ Group Root Execute ได้นั่นเองและ Openshift จทำการ Ignore User ใน dockerfile อีกด้วยเพราะมันไม่มีประโยชน์ที่จะ Fix user เพราะยังไงก็โดน Random User อยุ๋ดีนั่นเอง
