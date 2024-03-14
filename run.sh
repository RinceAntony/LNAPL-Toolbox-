#!/bin/bash
#  /usr/bin/shiny-server &

R -e "shiny::runApp(appDir = '/srv/shiny-server/LNAPL',  port = 80, host = '0.0.0.0' )"
 
