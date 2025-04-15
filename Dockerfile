FROM geonetwork:3.10.2-postgres

COPY ./alteracoes-inde.tar.gz .
RUN tar -xzf alteracoes-inde.tar.gz -C $CATALINA_HOME/webapps/ --overwrite

COPY ./perfil-mgb2.zip .
RUN unzip -qq perfil-mgb2.zip && \
     rm perfil-mgb2.zip && \
     cp -r mgb2/iso19115-3.2018 $CATALINA_HOME/webapps/geonetwork/WEB-INF/data/config/schema_plugins/ && \
     cp -r mgb2/iso19115-3.mgb $CATALINA_HOME/webapps/geonetwork/WEB-INF/data/config/schema_plugins/ && \
     cp -r mgb2/config-spring-mgb-2.xml $CATALINA_HOME/webapps/geonetwork/WEB-INF/ && \
     rm -rf mgb2
