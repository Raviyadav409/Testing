FROM jboss/wildfly:14.0.0.Final
USER root
RUN  yum update -y && yum upgrade -y
USER jboss
# Different password should be used for production and saved in the keepass file
#ARG ADMIN_PW=Admin#70365
#RUN /opt/jboss/wildfly/bin/add-user.sh admin $ADMIN_PW --silent
RUN /opt/jboss/wildfly/bin/add-user.sh admin Sopra123!Admin --silent
COPY modules/ /opt/jboss/wildfly/modules/

COPY wmq.jmsra.rar /opt/jboss/wildfly/standalone/deployments/
COPY startup.sh /opt/jboss/wildfly/bin/
COPY application-users.properties /opt/jboss/wildfly/standalone/configuration/
COPY application-roles.properties /opt/jboss/wildfly/standalone/configuration/

ADD ncm.ear /opt/jboss/wildfly/standalone/deployments/
ADD config /opt/jboss/wildfly/standalone/deployments/config
COPY standalone.xml /opt/jboss/wildfly/standalone/configuration/
COPY standalone.conf /opt/jboss/wildfly/bin/

USER root
RUN chmod -R 775 /opt/jboss/wildfly/modules
RUN chmod -R 775 /opt/jboss/wildfly/bin
RUN chmod -R 775 /opt/jboss/wildfly/standalone
RUN chown -R jboss:jboss /opt/jboss/wildfly/standalone/deployments/config
USER jboss

CMD ["/opt/jboss/wildfly/bin/startup.sh"]
