FROM jenkins/jenkins:2.387.2-lts-jdk11

# Skip the initial setup wizard
# ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

# Copy the plugins.txt file
COPY --chown=jenkins:jenkins plugins.txt /usr/share/jenkins/ref/plugins.txt
COPY --chown=jenkins:jenkins install-plugins.sh /tmp

# Install plugins
# RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

RUN chmod +x /tmp/install-plugins.sh \
    && /tmp/install-plugins.sh
