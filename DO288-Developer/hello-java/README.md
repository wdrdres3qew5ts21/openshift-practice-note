oc create cm throntail-config --from-literal APP_MSG="End of Life Support please go to Quarkus JAVA EE is Dead !"

oc set env dc/hello-java-docker --from=cm/throntail-config 
