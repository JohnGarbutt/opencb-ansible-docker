FROM docker.elastic.co/beats/filebeat:6.3.0

USER root
RUN groupadd docker -g132
RUN usermod -a -G docker filebeat
