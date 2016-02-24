#!/bin/bash

sed -ri -e 's|TOMCAT_MANAGER_USER|'"$TOMCAT_MANAGER_USER"'|g' $CATALINA_HOME/conf/tomcat-users.xml
sed -ri -e 's|TOMCAT_MANAGER_PASSWORD|'"$TOMCAT_MANAGER_PASSWORD"'|g' $CATALINA_HOME/conf/tomcat-users.xml
sed -ri -e 's|<Context>|<Context sessionCookiePath="/" useHttpOnly="false" clearReferencesStopTimerThreads="true">|g' $CATALINA_HOME/conf/context.xml
sed -ri -e 's|<Connector (.*)$|<Connector URIEncoding="UTF-8" \1|g' $CATALINA_HOME/conf/server.xml

exec "$@"
