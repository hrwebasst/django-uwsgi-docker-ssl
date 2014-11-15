django-uwsgi-docker-ssl
=======================

This is a standalone docker for running your django app. It includes ssl configuration for nginx allowing you to self sign your own cert easily and make sure your admin logins are encrypted.

To spin up this docker you need to know your project name and have docker installed.

The nginx conf is added in on docker instantiation as well as a log folder.

This docker ASSUMES you have a key.pem and a cert.pem in this directory.

You can provide these or generate them with something like this:
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout key.pem -out cert.pem

Build your docker:
docker build -t hrwebasst/django .

Run this docker with:
docker run -d -e APPNAME=<YOUR PROJECT NAME> -p 80:80 -p 443:443 -v <PATH TO YOUR VIRTUALENV>:/var/local/app_venv/app -v `pwd`/default.conf:/etc/nginx/sites-enabled/default -v <PATH WHERE YOU WANT YOUR LOGS>:/var/log/nginx hrwebasst/django

Example: 
docker run -d -e APPNAME=mysite -p 80:80 -p 443:443 -v `pwd`/mysite:/var/local/app_venv/app -v `pwd`/default.conf:/etc/nginx/sites-enabled/default -v `pwd`/log:/var/log/nginx hrwebasst/django

TODO:
I will be giving instructions to spinning up multiple sites and having them all register through nginx-proxy docker SOON(TM)
