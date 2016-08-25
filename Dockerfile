FROM amissemer/git-sync-jenkins:2.7.2-swarm

ENV JENKINS_CONFIG_PATH=apps/jenkins-master/jenkins-config

COPY jenkins-config /usr/share/jenkins/ref
RUN install-plugins.sh $(cat /usr/share/jenkins/ref/plugins.txt)

# You can provide the SSH keys for Jenkins (omit if you want the key to be generated, you can then retrieve the public key by running ./passwd.sh
USER root
RUN chown -R jenkins /usr/share/jenkins/ref && chmod 700 /usr/share/jenkins/ref/.ssh && chmod 600 /usr/share/jenkins/ref/.ssh/* || echo "No ssh key provided, one will be generated upon container startup"
USER jenkins

# You can provide additional system properties, for example to set the timezone
ENV JAVA_OPTS="$JAVA_OPTS -Dorg.apache.commons.jelly.tags.fmt.timeZone=America/Montreal"
