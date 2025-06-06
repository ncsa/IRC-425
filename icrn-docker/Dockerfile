# This Dockerfile is installing R and RStudio Server on Ubuntu 22.04.03

# Use the minimal-notebook as base
ARG JUPYTER_VERSION=latest
# FROM jupyter/minimal-notebook:${JUPYTER_VERSION}
FROM jupyter/minimal-notebook:x86_64-ubuntu-22.04

# Switch to root to install additional packages
USER root

WORKDIR /

# Install R and its dependencies
RUN apt update -qq && \
    apt install -y --no-install-recommends software-properties-common dirmngr && \
    wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc && \
    add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/" && \
    apt install -y r-base

# Installs Rstudio Server
RUN apt install -y --no-install-recommends gdebi-core && \
    wget https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2024.12.0-467-amd64.deb && \
    gdebi -n rstudio-server-2024.12.0-467-amd64.deb && \
    rm -f rstudio-server-2024.12.0-467-amd64.deb

# Install tidyverse
RUN apt update -qq && apt install --yes --no-install-recommends wget ca-certificates gnupg && \
    wget -q -O- https://eddelbuettel.github.io/r2u/assets/dirk_eddelbuettel_key.asc | tee -a /etc/apt/trusted.gpg.d/cranapt_key.asc && \
    echo "deb [arch=amd64] https://r2u.stat.illinois.edu/ubuntu jammy main" > /etc/apt/sources.list.d/cranapt.list && \
    apt update -qq && \
    apt install --yes --no-install-recommends  r-cran-data.table r-cran-tidyverse && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Installs the jupyter-rsession-proxy
# RUN mkdir -p /home/jovyan/.cache &&\
#  chown -R $NB_USER:users /home/$NB_USER/.cache

RUN pip install jupyter-rsession-proxy &&\ 
    mkdir -p /home/$NB_USER/.cache &&\
    chown -R $NB_USER:users /home/$NB_USER/.cache

RUN mkdir -p /home/$NB_USER/.icrn &&\
    chown -R $NB_USER:users /home/$NB_USER/.icrn
COPY ./.Renviron /home/$NB_USER/.icrn/.Renviron

ENV R_ENVIRON_USER=/home/$NB_USER/.icrn/.Renviron

# Switch to default working directory
WORKDIR /home/$NB_USER

# Switch to default NB_USER
USER $NB_USER