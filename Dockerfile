FROM ubuntu:trusty

WORKDIR  /root/CFDEM/CFDEMcoupling
ENV WM_NCOMPPROCS 2

RUN sudo apt-get update && sudo apt-get install -y build-essential cmake openmpi-bin libopenmpi-dev python-dev git bc
RUN mkdir -p /root/CFDEM/CFDEMcoupling && mkdir -p /root/CFDEM/-6
RUN sudo apt-get install -y software-properties-common wget apt-transport-https && sudo sh -c "wget -O - http://dl.openfoam.org/gpg.key | apt-key add -" && sudo add-apt-repository http://dl.openfoam.org/ubuntu
RUN sudo apt-get update && sudo apt-get -y install openfoam6
RUN git clone https://github.com/ParticulateFlow/LIGGGHTS-PFM.git /root/CFDEM/LIGGGHTS
RUN shopt -s expand_aliases && source /opt/openfoam6/etc/bashrc && source /root/CFDEM/CFDEMcoupling/etc/bashrc && bash /root/CFDEM/CFDEMcoupling/etc/compileLIGGGHTS.sh
RUN shopt -s expand_aliases && source /opt/openfoam6/etc/bashrc && source /root/CFDEM/CFDEMcoupling/etc/bashrc && bash /root/CFDEM/CFDEMcoupling/etc/compileCFDEMcoupling_src.sh
RUN shopt -s expand_aliases && source /opt/openfoam6/etc/bashrc && source /root/CFDEM/CFDEMcoupling/etc/bashrc && bash /root/CFDEM/CFDEMcoupling/etc/compileCFDEMcoupling_sol.sh
RUN shopt -s expand_aliases && source /opt/openfoam6/etc/bashrc && source /root/CFDEM/CFDEMcoupling/etc/bashrc && bash /root/CFDEM/CFDEMcoupling/etc/compileCFDEMcoupling_uti.sh
