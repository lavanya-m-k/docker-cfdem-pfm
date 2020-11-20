FROM ubuntu:trusty

WORKDIR  /home/CFDEM/CFDEMcoupling
ENV WM_NCOMPPROCS 2

RUN sudo apt-get update && sudo apt-get install -y build-essential cmake openmpi-bin libopenmpi-dev python-dev git bc
RUN mkdir -p /home/CFDEM/CFDEMcoupling && mkdir -p /home/CFDEM/-6
RUN sudo apt-get install -y software-properties-common wget apt-transport-https && sudo sh -c "wget -O - http://dl.openfoam.org/gpg.key | apt-key add -" && sudo add-apt-repository http://dl.openfoam.org/ubuntu
RUN sudo apt-get update && sudo apt-get -y install openfoam6
RUN git clone https://github.com/ParticulateFlow/LIGGGHTS-PFM.git /home/CFDEM/LIGGGHTS
RUN git clone https://github.com/ParticulateFlow/CFDEMcoupling-PFM.git /home/CFDEM/CFDEMcoupling
RUN bash -c "shopt -s expand_aliases && source /opt/openfoam6/etc/bashrc && source /home/CFDEM/CFDEMcoupling/etc/bashrc &&  bash /home/CFDEM/CFDEMcoupling/etc/compileLIGGGHTS.sh"
RUN bash -c "shopt -s expand_aliases && source /opt/openfoam6/etc/bashrc && source /home/CFDEM/CFDEMcoupling/etc/bashrc && bash /home/CFDEM/CFDEMcoupling/etc/compileCFDEMcoupling_src.sh"
RUN bash -c "shopt -s expand_aliases && source /opt/openfoam6/etc/bashrc && source /home/CFDEM/CFDEMcoupling/etc/bashrc && bash /home/CFDEM/CFDEMcoupling/etc/compileCFDEMcoupling_sol.sh"
RUN bash -c "shopt -s expand_aliases && source /opt/openfoam6/etc/bashrc && source /home/CFDEM/CFDEMcoupling/etc/bashrc && bash /home/CFDEM/CFDEMcoupling/etc/compileCFDEMcoupling_uti.sh"
