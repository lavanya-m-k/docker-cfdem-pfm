FROM ubuntu:trusty

WORKDIR  /home/cfdem/CFDEM/CFDEMcoupling
ENV WM_NCOMPPROCS 2

RUN sudo apt-get update && sudo apt-get install -y build-essential cmake openmpi-bin libopenmpi-dev python-dev git bc
RUN sudo apt-get install -y software-properties-common wget apt-transport-https && sudo sh -c "wget -O - http://dl.openfoam.org/gpg.key | apt-key add -" && sudo add-apt-repository http://dl.openfoam.org/ubuntu
RUN sudo apt-get update && sudo apt-get -y install openfoam6
RUN useradd --shell /bin/bash cfdem
RUN mkdir -p /home/cfdem/CFDEM/CFDEMcoupling && mkdir -p /home/cfdem/CFDEM/-6 && chown -R cfdem:cfdem /home/cfdem
USER cfdem
RUN git clone https://github.com/ParticulateFlow/LIGGGHTS-PFM.git /home/cfdem/CFDEM/LIGGGHTS
RUN git clone https://github.com/ParticulateFlow/CFDEMcoupling-PFM.git /home/cfdem/CFDEM/CFDEMcoupling
RUN sed "28d" /home/cfdem/CFDEM/CFDEMcoupling/etc/bashrc 
RUN echo "source /opt/openfoam6/etc/bashrc" >> $HOME/.bashrc
RUN echo "source /home/cfdem/CFDEM/CFDEMcoupling/etc/bashrc" >> $HOME/.bashrc
RUN bash -c "shopt -s expand_aliases && source /opt/openfoam6/etc/bashrc && source /home/cfdem/CFDEM/CFDEMcoupling/etc/bashrc &&  bash /home/cfdem/CFDEM/CFDEMcoupling/etc/compileLIGGGHTS.sh"
RUN bash -c "shopt -s expand_aliases && source /opt/openfoam6/etc/bashrc && source /home/cfdem/CFDEM/CFDEMcoupling/etc/bashrc && bash /home/cfdem/CFDEM/CFDEMcoupling/etc/compileCFDEMcoupling_src.sh"
RUN bash -c "shopt -s expand_aliases && source /opt/openfoam6/etc/bashrc && source /home/cfdem/CFDEM/CFDEMcoupling/etc/bashrc && bash /home/cfdem/CFDEM/CFDEMcoupling/etc/compileCFDEMcoupling_sol.sh"
RUN bash -c "shopt -s expand_aliases && source /opt/openfoam6/etc/bashrc && source /home/cfdem/CFDEM/CFDEMcoupling/etc/bashrc && bash /home/cfdem/CFDEM/CFDEMcoupling/etc/compileCFDEMcoupling_uti.sh"
