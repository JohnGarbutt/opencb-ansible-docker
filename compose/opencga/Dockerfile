FROM ubuntu:16.04

# Based on: https://github.com/cmoro-deusto/docker-tomcat8
# Not using upstream tomcat image so we get specific java versions
MAINTAINER OpenCB

# Take from: https://launchpad.net/~webupd8team/+archive/ubuntu/java
ARG JAVA_VERSION="8u171-1~webupd8~0"

# Install dependencies
RUN apt-get update && \
apt-get install -y git build-essential curl wget unzip tar software-properties-common vim

# Install JDK 8
RUN \
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
add-apt-repository -y ppa:webupd8team/java && \
apt-get update && \
apt-get install -y oracle-java8-installer=${JAVA_VERSION} && \
rm -rf /var/lib/apt/lists/* && \
rm -rf /var/cache/oracle-jdk8-installer

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# Install envsubst
RUN apt-get update && apt-get install -y gettext

# Get opencga
ARG OPENCGA_VERSION="1.2.0"

RUN wget --quiet https://github.com/opencb/opencga/releases/download/v${OPENCGA_VERSION}/opencga-${OPENCGA_VERSION}.tar.gz -O /tmp/opencga.tgz && \
tar xzvf /tmp/opencga.tgz -C /opt && \
mv /opt/opencga-${OPENCGA_VERSION} /opt/opencga && \
rm /tmp/opencga.tgz

WORKDIR /opt/opencga

ENV ADMIN_PASSWORD secret-admin-password
ENV SECRET_KEY super-secret-key
ENV MONGO_CATALOG="mongo-catalog:27017"
ENV MONGO_STORE="mongo-store:27017"
ENV SOLR_HOST="http://solr:8989/solr/"
ENV OPENCGA_HOST="opencga-tomcat"

RUN cp -r /opt/opencga/conf /opt/opencga/conf.orig
COPY configuration.yml /opt/opencga/conf/configuration.yml.tmp
COPY storage-configuration.yml /opt/opencga/conf/storage-configuration.yml.tmp
COPY client-configuration.yml /opt/opencga/conf/client-configuration.yml.tmp
COPY tutorial.sh /opt/opencga/bin/tutorial.sh.tmp

# TODO: add into entrypoint
RUN cat /opt/opencga/conf/configuration.yml.tmp | envsubst > /opt/opencga/conf/configuration.yml
RUN cat /opt/opencga/conf/storage-configuration.yml.tmp | envsubst > /opt/opencga/conf/storage-configuration.yml
RUN cat /opt/opencga/conf/client-configuration.yml.tmp | envsubst > /opt/opencga/conf/client-configuration.yml
RUN cat /opt/opencga/bin/tutorial.sh.tmp | envsubst > /opt/opencga/bin/tutorial.sh
RUN chmod +x /opt/opencga/bin/tutorial.sh

EXPOSE 9092

CMD /bin/bash -c "sleep 20 && /opt/opencga/bin/opencga-admin.sh catalog daemon --start -p <<< $ADMIN_PASSWORD"
