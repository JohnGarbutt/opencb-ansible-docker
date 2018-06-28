FROM ubuntu:16.04

# Based on: https://github.com/cmoro-deusto/docker-tomcat8
# Not using upstream tomcat image so we get specific java versions
MAINTAINER OpenCB

# Take from: https://launchpad.net/~webupd8team/+archive/ubuntu/java
ENV JAVA_VERSION "8u171-1~webupd8~0"

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

# Get opencga
ENV OPENCGA_VERSION "1.2.0"

RUN wget --quiet https://github.com/opencb/opencga/releases/download/v${OPENCGA_VERSION}/opencga-${OPENCGA_VERSION}.tar.gz -O /tmp/opencga.tgz && \
tar xzvf /tmp/opencga.tgz -C /opt && \
mv /opt/opencga-${OPENCGA_VERSION} /opt/opencga && \
rm /tmp/opencga.tgz

WORKDIR /opt/opencga

CMD /bin/bash -c "/opt/opencga/bin/opencga-admin.sh catalog daemon --start -p <<< $ADMIN_PASSWORD"
