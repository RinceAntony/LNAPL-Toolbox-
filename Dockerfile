FROM  quay.io/centos/centos:stream8
# Install required tools and dependencies
RUN yum install -y epel-release epel-next-release dnf-plugins-core net-tools wget && \
    yum install net-tools lsof tree -y 

RUN dnf config-manager --set-enabled powertools

# Install python3
RUN dnf install python3 -y 

# Install pip3 and numpy
RUN yum install python3-pip -y

RUN pip3 install numpy

# Install R and its dependencies
RUN yum install libxml2-devel udunits2-devel openssl-devel gdal-devel proj-devel sqlite-devel libcurl-devel geos-devel -y && \
    yum clean all

RUN yum install R  -y && \
    yum clean all 
	
# Install shiny Server
RUN wget https://download3.rstudio.org/centos7/x86_64/shiny-server-1.5.17.973-x86_64.rpm && \
    yum install -y --nogpgcheck shiny-server-1.5.17.973-x86_64.rpm

# Install shiny packages and LNAPL dependency packages
RUN R -e "install.packages('shiny', repos='https://cran.rstudio.com/')" && \
    R -e "install.packages('tidyverse', repos='https://cran.rstudio.com/')" && \
	R -e "install.packages('gt', repos='https://cran.rstudio.com/')" && \
	R -e "install.packages('openxlsx', repos='https://cran.rstudio.com/')" && \
	R -e "install.packages('ggforce', repos='https://cran.rstudio.com/')" && \
	R -e "install.packages('leafem', repos='https://cran.rstudio.com/')" && \
	R -e "install.packages('rsconnect', repos='https://cran.rstudio.com/')" && \
	R -e "install.packages('leaflet', repos='https://cran.rstudio.com/')" && \
	R -e "install.packages('leaflet.extras', repos='https://cran.rstudio.com/')" && \
	R -e "install.packages('plotly', repos='https://cran.rstudio.com/')" && \
	R -e "install.packages('DT', repos='https://cran.rstudio.com/')" && \
	R -e "install.packages('gstat', repos='https://cran.rstudio.com/')" && \
	R -e "install.packages('rgdal', repos='https://cran.rstudio.com/')" && \
	R -e "install.packages('dismo', repos='https://cran.rstudio.com/')" && \
	R -e "install.packages('rgeos', repos='https://cran.rstudio.com/')" && \
	R -e "install.packages('deldir', repos='https://cran.rstudio.com/')" && \
	R -e "install.packages('reticulate', repos='https://cran.rstudio.com/')" && \
	R -e "install.packages('shinycssloaders', repos='https://cran.rstudio.com/')" && \
	R -e "install.packages('shinyBS', repos='https://cran.rstudio.com/')" && \
	R -e "install.packages('shinythemes', repos='https://cran.rstudio.com/')" && \
	R -e "install.packages('shinyWidgets', repos='https://cran.rstudio.com/')" && \
	R -e "install.packages('shinyjs', repos='https://cran.rstudio.com/')"

# Enable shiny-server service
RUN systemctl enable shiny-server.service

# Startup Script
COPY run.sh /run.sh
RUN chmod +x /run.sh

# copy the app to the image
RUN mkdir /srv/shiny-server/LNAPL
COPY LNAPL /srv/shiny-server/LNAPL

#Expose application on port 80
EXPOSE  80
CMD ["/run.sh"]

