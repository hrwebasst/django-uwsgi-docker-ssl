#Licensed under MIT because this should be free damnit!
# this assumes you've made your own cert and key files with somthing like this command:
# openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout key.pem -out cert.pem
#Run this as such:
#docker run -d -v <full virtualenv path>:/var/local/app_venv/app -v <full log path>:/var/log/nginx -v <full nginx.conf path>:/etc/nginx/sites-enabled/default container_repo/container_name

from ubuntu:14.04
MAINTAINER Richard <hrwebasst@uoregon.edu>
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN apt-get update && \
    apt-get install -y git python python-dev python-setuptools nginx supervisor python-virtualenv python-software-properties libpq-dev libtiff5-dev libjpeg8-dev zlib1g-dev libfreetype6-dev liblcms2-dev libwebp-dev python-tk

RUN virtualenv --no-site-packages /var/local/app_venv 
RUN cd /var/local/app_venv && source bin/activate && pip install django==1.7 psycopg2 ipython ipdb uwsgi pillow

RUN echo "daemon off;" >> /etc/nginx/nginx.conf

VOLUME ['/var/local/app_venv/app','/etc/nginx/sites-enabled/default', '/var/log/nginx']

ADD supervisor.conf /etc/supervisor/conf.d/
ADD init-wsgi.sh /var/local/
RUN chmod +x /var/local/init-wsgi.sh
ADD django.ini /var/local/
ADD cert.pem /var/local/certs/
ADD key.pem /var/local/certs/

EXPOSE 80
EXPOSE 443
CMD supervisord -n