# intermine-tomcat

Docker files to setup the InterMine Tomcat server

## Initial setup

```
# Setup a tomcat instance that is exposed only to the local host machine via port 8080.
$ docker run --name intermine-tomcat -p 127.0.0.1:8080:8080 -d flybase/intermine-tomcat

# Setup a tomcat instance that is publicly accessible via port 8080 and set the tomcat manager user to mymanager with a password of mypass.
$ docker run --name intermine-tomcat -p 8080:8080 -e TOMCAT_MANAGER_USER=mymanager -e TOMCAT_MANAGER_PASSWORD=mypass -d flybase/intermine-tomcat

# Setup a tomcat instance as previously done and link it to the intermine-db image.
$ docker run --name intermine-tomcat -p 8080:8080 -e TOMCAT_MANAGER_USER=mymanager -e TOMCAT_MANAGER_PASSWORD=mypass --link intermine-db:db -d flybase/intermine-tomcat
```

See [flybase/intermine](https://github.com/FlyBase/intermine/tree/master) for more information.

The --link flag takes parameters in the form of <container_name>:<alias>.
<container_name> is the name used to start the intermine-db container.
<alias> is the name that can be used to reference this database container within the tomcat container.
If you change the value of <alias> you will need to update $HOME/.intermine/flybasemine.properties

### Manager user

#### Default

*Username:* manager
*Password:* manager

#### Setting your own

To override the default user, pass the ```-e TOMCAT_MANAGER_USER=myuser``` and ```-e TOMCAT_MANAGER_PASSWORD=mypass``` flags to ```docker run```.

