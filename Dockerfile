################## BASE IMAGE ######################

FROM ubuntu:latest

################## METADATA ######################

LABEL maintainer="Albert Cañellas-Sole <albert.canellas@bsc.es>, Roc Farriol-Duran <roc.farriol@bsc.es>" \
    container="Brewpitopes" \
    about.summary="BREWPITOPES: a pipeline to refine B-cell epitope predictions during public health emergencies" \
    about.home="https://github.com/rocfd/brewpitopes/tree/dockerized" \
    software.version="1.0"

################## INSTALLATION ######################

# Update to latest packages and install python=3.7
RUN apt update && apt upgrade -y && \
    apt install software-properties-common -y && \
    add-apt-repository ppa:deadsnakes/ppa -y && \
    apt update && \
    apt install python3.7 python3-pip git python-is-python3 vim wget libblas-dev liblapack-dev gfortran curl libcurl4-openssl-dev libxml2-dev -y

# Install R 4.2.1
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Madrid
RUN apt install --no-install-recommends r-base -y

# R libraries
RUN R -e "install.packages('dplyr', dependencies=TRUE)"
RUN R -e "install.packages('tidyverse', dependencies=TRUE)"
RUN R -e "install.packages('data.table', dependencies=TRUE)"
RUN R -e "install.packages('segmented')"
RUN R -e "install.packages('seqinr')" # repos='http://R-Forge.R-project.org'
RUN R -e "install.packages('bitops')"
RUN R -e "install.packages('XML', repos = 'http://www.omegahat.net/R')"
RUN R -e "install.packages('remotes')"
RUN R -e "install.packages('argparser')"
RUN R -e "remotes::install_github('cttobin/ggthemr')"

# Load libraries
RUN R -e "library(dplyr)"
RUN R -e "library(tidyr)"
RUN R -e "library(tibble)"
RUN R -e "library(data.table)"
RUN R -e "library(stringr)"
RUN R -e "library(purrr)"
RUN R -e "library(seqinr)"
RUN R -e "library(XML)"
RUN R -e "library(ggplot2)"
RUN R -e "library(ggthemr)"
RUN R -e "library(argparser)"

# Install dependencies
RUN pip install more-itertools pandas

# Working directory
WORKDIR /home
RUN git clone --branch dockerized https://github.com/rocfd/brewpitopes.git
