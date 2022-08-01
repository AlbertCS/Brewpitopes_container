# Dockerfile for Brewpitopes
# Base image rocker/r-ubuntu:20.04
#FROM rocker/r-base:4.2.1
FROM ubuntu:latest

# Update to latest packages and install python=3.7
RUN apt update && apt upgrade -y && \
    apt install software-properties-common -y && \
    add-apt-repository ppa:deadsnakes/ppa -y && \
    apt update && \
    apt install python3.7 python3-pip python-is-python3 wget libblas-dev liblapack-dev gfortran curl libcurl4-openssl-dev libxml2-dev -y

# Install R 4.2.1
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Madrid
#RUN wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | gpg --dearmor -o /usr/share/keyrings/r-project.gpg
#RUN echo "deb [signed-by=/usr/share/keyrings/r-project.gpg] https://cloud.r-project.org/bin/linux/ubuntu jammy-cran40/" | tee -a /etc/apt/sources.list.d/r-project.list
#RUN apt update
RUN apt install --no-install-recommends r-base -y

# R libraries
RUN R -e "install.packages('dplyr', dependencies=TRUE)"
RUN R -e "install.packages('tidyverse', dependencies=TRUE)"
RUN R -e "install.packages('data.table', dependencies=TRUE)"
RUN R -e "install.packages('segmented')"
RUN R -e "install.packages('seqinr')" # repos='http://R-Forge.R-project.org'
RUN R -e "install.packages('bitops')"
RUN R -e "install.packages('XML', repos = 'http://www.omegahat.net/R')" # no funciona
# Warning: unable to access index for repository http://www.omegahat.org/R/src/contrib:
#  cannot open URL 'http://www.omegahat.org/R/src/contrib/PACKAGES'
#Warning message:
#package 'XML' is not available for this version of R
#A version of this package for your version of R might be available elsewhere,
#see the ideas at
#https://cran.r-project.org/doc/manuals/r-patched/R-admin.html#Installing-packages

#RUN R -e "install.packages('devtools', dependencies=TRUE)"
# ERROR: dependencies 'usethis', 'pkgdown', 'rcmdcheck', 'roxygen2', 'rversions', 'urlchecker' are not available for package 'devtools'
# ERROR: configuration failed for package 'systemfonts'
# ERROR: configuration failed for package 'xml2 Failed with error:  'there is no package called 'shiny' ERROR: configuration failed for package 'openssl'
# ERROR: configuration failed for package 'curl' ERROR: dependencies 'openssl', 'curl' are not available for package 'credentials'
# ERROR: dependency 'systemfonts' is not available for package 'textshaping'

RUN R -e "install.packages('remotes')"
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

# Install dependencies, not needed : csv, sys, os, pathlib
RUN pip install more-itertools pandas

# Working directory
WORKDIR /home/Brewpitopes
# Look if there is a need to create all the folders, ex: Save at /Z_fasta
