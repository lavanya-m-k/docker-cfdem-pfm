FROM centos:7

WORKDIR  /home/cfdem/CFDEM/CFDEMcoupling
ENV WM_NCOMPPROCS 2
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/lib64/openmpi3/bin/
ENV WM_MPLIB SYSTEMOPENMPI 
ENV WM_LABEL_SIZE 64 

RUN yum groupinstall -y 'Development Tools' 
RUN yum install -y zlib-devel libXext-devel libGLU-devel libXt-devel libXrender-devel libXinerama-devel libpng-devel libXrandr-devel libXi-devel libXft-devel libjpeg-turbo-devel libXcursor-devel readline-devel ncurses-devel python python-devel pfr-devel gmp-devel python3-devel openmpi3-devel openmpi3  wget

RUN yum update -y
RUN useradd --shell /bin/bash cfdem

RUN mkdir -p /home/cfdem/CFDEM/CFDEMcoupling && mkdir -p /home/cfdem/CFDEM/-6 && mkdir -p /home/cfdem/OpenFOAM && chown -R cfdem:cfdem /home/cfdem
USER cfdem

RUN git clone https://github.com/OpenFOAM/OpenFOAM-6.git /home/cfdem/OpenFOAM/OpenFOAM-6
RUN git clone https://github.com/OpenFOAM/ThirdParty-6.git /home/cfdem/OpenFOAM/ThirdParty-6
RUN mkdir /home/cfdem/OpenFOAM/ThirdParty-6/download
RUN wget -P /home/cfdem/OpenFOAM/ThirdParty-6/download https://www.cmake.org/files/v3.9/cmake-3.9.0.tar.gz
RUN wget -P /home/cfdem/OpenFOAM/ThirdParty-6/download https://github.com/CGAL/cgal/releases/download/releases%2FCGAL-4.10/CGAL-4.10.tar.xz
RUN wget -P /home/cfdem/OpenFOAM/ThirdParty-6/download  https://sourceforge.net/projects/boost/files/boost/1.55.0/boost_1_55_0.tar.bz2
RUN cd /home/cfdem/OpenFOAM/ThirdParty-6 
#RUN tar -xzf download/cmake-3.9.0.tar.gz && tar -xJf download/CGAL-4.10.tar.xz && tar -xjf download/boost_1_55_0.tar.bz2

#RUN sed -i -e 's/\(boost_version=\)boost-system/\1boost_1_55_0/'  /home/cfdem/OpenFOAM/OpenFOAM-6/etc/config.sh/CGAL
#RUN sed -i -e 's/\(cgal_version=\)cgal-system/\1CGAL-4.10/'  /home/cfdem/OpenFOAM/OpenFOAM-6/etc/config.sh/CGAL
RUN echo "alias of6='source \$HOME/OpenFOAM/OpenFOAM-6/etc/bashrc $FOAM_SETTINGS'" >> $HOME/.bashrc
#RUN bash -c "source $HOME/OpenFOAM/OpenFOAM-6/etc/bashrc WM_LABEL_SIZE=64 WM_MPLIB=SYSTEMOPENMPI && cd $WM_THIRD_PARTY_DIR && ./makeCmake > log.makeCmake 2>&1 && wmRefresh" 

RUN bash -c "source /home/cfdem/OpenFOAM/OpenFOAM-6/etc/bashrc WM_LABEL_SIZE=64 WM_MPLIB=SYSTEMOPENMPI; /home/cfdem/OpenFOAM/OpenFOAM-6/Allwmake -j" 


RUN git clone https://github.com/ParticulateFlow/LIGGGHTS-PFM.git /home/cfdem/CFDEM/LIGGGHTS
RUN git clone https://github.com/ParticulateFlow/CFDEMcoupling-PFM.git /home/cfdem/CFDEM/CFDEMcoupling
RUN sed -i -e 's/WM_LABEL_SIZE=32/WM_LABEL_SIZE=64/'  /home/cfdem/OpenFOAM/OpenFOAM-6/etc/bashrc
RUN echo "source /home/cfdem/OpenFOAM/OpenFOAM-6/etc/bashrc" >> $HOME/.bashrc
RUN echo "source /home/cfdem/CFDEM/CFDEMcoupling/etc/bashrc" >> $HOME/.bashrc
RUN bash -c "source /home/cfdem/OpenFOAM/OpenFOAM-6/etc/bashrc WM_LABEL_SIZE=64 WM_MPLIB=SYSTEMOPENMPI; source /home/cfdem/CFDEM/CFDEMcoupling/etc/bashrc; bash /home/cfdem/CFDEM/CFDEMcoupling/etc/compileLIGGGHTS.sh"
RUN bash -c "source /home/cfdem/OpenFOAM/OpenFOAM-6/etc/bashrc WM_LABEL_SIZE=64 WM_MPLIB=SYSTEMOPENMPI; source /home/cfdem/CFDEM/CFDEMcoupling/etc/bashrc; bash /home/cfdem/CFDEM/CFDEMcoupling/etc/compileCFDEMcoupling_src.sh"
RUN bash -c "source /home/cfdem/OpenFOAM/OpenFOAM-6/etc/bashrc WM_LABEL_SIZE=64 WM_MPLIB=SYSTEMOPENMPI; source /home/cfdem/CFDEM/CFDEMcoupling/etc/bashrc; bash /home/cfdem/CFDEM/CFDEMcoupling/etc/compileCFDEMcoupling_sol.sh"
RUN bash -c "source /home/cfdem/OpenFOAM/OpenFOAM-6/etc/bashrc WM_LABEL_SIZE=64 WM_MPLIB=SYSTEMOPENMPI; source /home/cfdem/CFDEM/CFDEMcoupling/etc/bashrc; bash /home/cfdem/CFDEM/CFDEMcoupling/etc/compileCFDEMcoupling_uti.sh"
