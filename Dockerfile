FROM ubuntu:14.04
MAINTAINER Nicolas Renkamp, <nico.re@gmail.com>

# install dependencies
RUN sudo apt-get -y update
RUN sudo apt-get -y install gfortran g++ make wish grace git expect expect-dev qt4-dev-tools zlib1g-dev && sudo apt-get -y autoremove
RUN cd ~ && git clone https://github.com/nrc-cnrc/EGSnrc.git

# install egsnrc
RUN export HEN_HOUSE= EGS_HOME= EGS_CONFIG=
ADD script.exp /root/script.exp
RUN chmod +x /root/script.exp
RUN /root/script.exp

ENV EGS_HOME /root/EGSnrc/egs_home/
ENV EGS_CONFIG /root/EGSnrc/HEN_HOUSE/specs/linux.conf

RUN echo "source /root/EGSnrc/HEN_HOUSE/scripts/egsnrc_bashrc_additions" >> /etc/bash.bashrc

# check if it works, by make of sample project
RUN cd $EGS_HOME/tutor7pp && make

#compile the GUIs which are ported to QT4 already
RUN cd /root/EGSnrc/HEN_HOUSE/gui/egs_gui && qmake && make
RUN cd /root/EGSnrc/HEN_HOUSE/gui/egs_inprz && qmake && make

#to test, runs this after container start: tutor7pp -i test1 -p /root/EGSnrc/HEN_HOUSE/pegs4/data/tutor_data.pegs4dat 
