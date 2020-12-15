FROM ubuntu:bionic

WORKDIR  /opt
ENV WM_NCOMPPROCS 2

RUN apt-get install sudo
RUN sudo apt-get update && sudo apt-get install -y build-essential cmake openmpi-bin libopenmpi-dev python-dev git bc
RUN sudo apt-get install -y software-properties-common wget apt-transport-https && sudo sh -c "wget -O - http://dl.openfoam.org/gpg.key | apt-key add -" && sudo add-apt-repository http://dl.openfoam.org/ubuntu
RUN sudo apt-get update && sudo apt-get -y install openfoam6
RUN useradd --shell /bin/bash cfdem
RUN mkdir -p /opt/CFDEM/CFDEMcoupling && mkdir -p /root/CFDEM/-6
RUN git clone https://github.com/ParticulateFlow/LIGGGHTS-PFM.git /opt/CFDEM/LIGGGHTS
RUN git clone https://github.com/ParticulateFlow/CFDEMcoupling-PFM.git /opt/CFDEM/CFDEMcoupling
RUN sed -i "28s,\$HOME/OpenFOAM/OpenFOAM-6,/opt/openfoam6," /opt/CFDEM/CFDEMcoupling/etc/bashrc
RUN sed -i "31s,\$HOME,/opt," /opt/CFDEM/CFDEMcoupling/etc/bashrc
RUN echo "source /opt/openfoam6/etc/bashrc" >> $HOME/.bashrc
RUN echo "source /opt/CFDEM/CFDEMcoupling/etc/bashrc" >> $HOME/.bashrc
RUN bash -c "shopt -s expand_aliases && source /opt/openfoam6/etc/bashrc && source /opt/CFDEM/CFDEMcoupling/etc/bashrc &&  bash /opt/CFDEM/CFDEMcoupling/etc/compileLIGGGHTS.sh"
RUN bash -c "shopt -s expand_aliases && source /opt/openfoam6/etc/bashrc && source /opt/CFDEM/CFDEMcoupling/etc/bashrc && bash /opt/CFDEM/CFDEMcoupling/etc/compileCFDEMcoupling_src.sh"
RUN bash -c "shopt -s expand_aliases && source /opt/openfoam6/etc/bashrc && source /opt/CFDEM/CFDEMcoupling/etc/bashrc && bash /opt/CFDEM/CFDEMcoupling/etc/compileCFDEMcoupling_sol.sh"
RUN bash -c "shopt -s expand_aliases && source /opt/openfoam6/etc/bashrc && source /opt/CFDEM/CFDEMcoupling/etc/bashrc && bash /opt/CFDEM/CFDEMcoupling/etc/compileCFDEMcoupling_uti.sh"
