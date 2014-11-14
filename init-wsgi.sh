#!/bin/bash
sed -i 's/$APPNAME/'"$APPNAME"'/' /var/local/django.ini
source /var/local/app_venv/bin/activate
uwsgi --ini /var/local/django.ini