FROM solr:6

ENV SOLR_CONF_URL "http://docs.opencb.org/download/attachments/9240577/OpenCGAConfSet.tar.gz?version=1&modificationDate=1509374447353&api=v2"

RUN wget --quiet --no-cookies $SOLR_CONF_URL -O /tmp/opencgaconfset.tgz && \
tar xzvf /tmp/opencgaconfset.tgz -C /opt/solr/server/solr/configsets/ --no-acls && \
rm /tmp/opencgaconfset.tgz
