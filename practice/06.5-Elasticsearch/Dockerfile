# Pull base image.
FROM centos:centos7

MAINTAINER Egor Zhelobanov <e.zhelobanov@gmail.com>

#Version package
#ENV PKG_ES_VER 7.9.3

RUN groupadd -g 1000 elasticsearch && useradd elasticsearch -u 1000 -g 1000

RUN yum makecache && \
    yum -y install wget \
    yum -y install perl-Digest-SHA


# Install Elasticsearch.
RUN \
  cd / && \
  wget https://mirrors.huaweicloud.com/elasticsearch/7.9.3/elasticsearch-7.9.3-linux-x86_64.tar.gz && \
  wget https://mirrors.huaweicloud.com/elasticsearch/7.9.3/elasticsearch-7.9.3-linux-x86_64.tar.gz.sha512 && \
  shasum -a 512 -c elasticsearch-7.9.3-linux-x86_64.tar.gz.sha512 && \
  tar -xzf elasticsearch-7.9.3-linux-x86_64.tar.gz && \
  rm -f elasticsearch-7.9.3-linux-x86_64.tar.gz && \
  mv /elasticsearch-7.9.3 /elasticsearch

RUN mkdir /var/lib/elasticsearch /var/lib/elasticsearch/logs /var/lib/elasticsearch/data

COPY elasticsearch.yml /elasticsearch/config

RUN chmod -R 777 /elasticsearch && \
    chmod -R 777 /var/lib/elasticsearch/logs && \
    chmod -R 777 /var/lib/elasticsearch/data

USER elasticsearch

CMD ["/elasticsearch/bin/elasticsearch"]

# Expose ports.
EXPOSE 9200
