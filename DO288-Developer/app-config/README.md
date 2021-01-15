oc create secret generic myapp.sec  --from-env-file=myapp.sec --dry-run -oyaml | oc apply -f -s

Deployment Config ไม่สามารถ Trigger อะไรที่อ้างอิงแบบ Reference ได้เพราะว่ามันไม่เห็นในตัวมันนั่นเอง

oc from-env-file จะทำให้เราแตก key:value ออกมาเป้นไฟล์แต่ล่ะอันพร้อมใช้งาน

```
etc/    secure/ src/    
bash-4.2$ cd /opt/app-root/
etc/    secure/ src/    
bash-4.2$ cd /opt/app-root/secure/
bash-4.2$ ls
myapp.sec  password  salt  username
bash-4.2$ cat password 
changedman
bash-4.2$ cat myapp.sec 
username=user1
password=pass1
salt=xyz123

```



