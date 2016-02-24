FROM debian:jessie

MAINTAINER Josh Goodman <jogoodma@indiana.edu>

ENV TOMCAT_MAJOR 7
ENV TOMCAT_VERSION 7.0.68
ENV TOMCAT_TGZ_URL https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz
ENV CATALINA_HOME /tomcat
ENV TOMCAT_MANAGER_USER manager
ENV TOMCAT_MANAGER_PASSWORD manager

ENV PATH $CATALINA_HOME/bin:$PATH

RUN mkdir -p "$CATALINA_HOME"

RUN groupadd intermine && useradd -g intermine intermine

WORKDIR $CATALINA_HOME

RUN apt-get update && apt-get install -y \
        curl \
        default-jdk

# see https://www.apache.org/dist/tomcat/tomcat-8/KEYS
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys \
    05AB33110949707C93A279E3D3EFE6B686867BA6 \
    07E48665A34DCAFAE522E5E6266191C37C037D42 \
    47309207D818FFD8DCD3F83F1931D684307A10A5 \
    541FBE7D8F78B25E055DDEE13C370389288584E7 \
    61B832AC2F1C5A90F0F9B00A1C506407564C17A3 \
    713DA88BE50911535FE716F5208B0AB1D63011C7 \
    79F7026C690BAA50B92CD8B66A3AD3F4F22C4FED \
    9BA44C2621385CB966EBA586F72C284D731FABEE \
    A27677289986DB50844682F8ACB77FC2E86E29AC \
    A9C5DF4D22E99998D9875A5110C01C5A2F6059E7 \
    DCFD35E0BF8CA7344752DE8B6FB21E8933C60243 \
    F3A04C595DB5B6A5F1ECA43E3B7BBB100D811BBE \
    F7DA48BB64BCB84ECBA7EE6935CD23C10D498E23

RUN set -x \
    && curl -fSL "$TOMCAT_TGZ_URL" -o tomcat.tar.gz \
    && curl -fSL "$TOMCAT_TGZ_URL.asc" -o tomcat.tar.gz.asc \
    && gpg --verify tomcat.tar.gz.asc \
    && tar -xvf tomcat.tar.gz --strip-components=1 \
    && rm bin/*.bat \
    && rm tomcat.tar.gz*

RUN chown -R intermine:intermine $CATALINA_HOME

USER intermine

COPY tomcat-users.xml $CATALINA_HOME/conf/tomcat-users.xml

RUN sed -ri -e 's|TOMCAT_MANAGER_USER|${TOMCAT_MANAGER_USER}|g' $CATALINA_HOME/conf/tomcat-users.xml
RUN sed -ri -e 's|TOMCAT_MANAGER_PASSWORD|${TOMCAT_MANAGER_PASSWORD}|g' $CATALINA_HOME/conf/tomcat-users.xml
RUN sed -ri -e 's|<Context>|<Context sessionCookiePath="/" useHttpOnly="false" clearReferencesStopTimerThreads="true">|g' $CATALINA_HOME/conf/context.xml
RUN sed -ri -e 's|<Connector (.*)$|<Connector URIEncoding="UTF-8" \1|g' $CATALINA_HOME/conf/server.xml

ENV ANT_OPTS="-server -XX:MaxPermSize=256M -Xmx1700m -XX:+UseParallelGC -Xms1700m -XX:SoftRefLRUPolicyMSPerMB=1 -XX:MaxHeapFreeRatio=99"
ENV JAVA_OPTS="$JAVA_OPTS -Dorg.apache.el.parser.SKIP_IDENTIFIER_CHECK=true"
ENV TOMCAT_OPTS="-Xmx256m -Xms128m"

EXPOSE 8080

VOLUME /tomcat 

CMD ["catalina.sh","run"]
