FROM ubuntu:trusty

ENV ES_VERSION 1.7.1
ENV MYSQL_VERSION 5.6

RUN apt-get -y update && apt-get install -y \
redis-server \
git \
wget \
unzip \
nodejs \
npm \
default-jre \
libmysqlclient-dev \
libxml2-dev \
libxslt-dev \
libjpeg-dev \
libfreetype6-dev \
libtiff-dev \
libffi-dev \
software-properties-common \
python-dev \
python-pip

# Download and run ElasticSearch
RUN wget https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-"${ES_VERSION}".zip
RUN unzip elasticsearch-"${ES_VERSION}".zip
RUN rm elasticsearch-"${ES_VERSION}".zip
RUN ./elasticsearch-"${ES_VERSION}"/bin/elasticsearch &

# For the new Nodejs to work
RUN ln -s /usr/bin/nodejs /usr/bin/node

# Configure and install MySQL
RUN echo mysql-community-server mysql-community-server/data-dir select '' | debconf-set-selections
RUN echo mysql-community-server mysql-community-server/root-pass password '' | debconf-set-selections
RUN echo mysql-community-server mysql-community-server/re-root-pass password '' | debconf-set-selections
RUN echo mysql-community-server mysql-community-server/remove-test-db select false | debconf-set-selections
RUN apt-get install -y mysql-server-"${MYSQL_VERSION}"

# NPM dependencies (installed in /usr/local/bin)
RUN npm update
RUN npm install -g bower less clean-css uglify-js requirejs

# Invenio
RUN pip install git+https://github.com/HEPData/invenio@master#egg=Invenio
