FROM ubuntu:18.04

LABEL maintainer="RPF - github.com/RPFramework"
ARG DEBIAN_FRONTEND=noninteractive
RUN mkdir /arma3
RUN mkdir /arma3/mpmissions

#apt-utils
RUN apt-get update --fix-missing
RUN apt-get update
RUN apt-get install -q -y --no-install-recommends --no-install-suggests \
        apt-utils \
        dialog 
WORKDIR /

#TODO: Windows tbbmalloc
#---Steamcmd Arma server related stuff 
RUN apt-get install git wget rename vim software-properties-common -y  --no-install-recommends --no-install-suggests
RUN add-apt-repository multiverse
RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get install -y --no-install-recommends --no-install-suggests \
        lib32stdc++6 \
        libsdl2-2.0-0:i386 \
        lib32gcc1 \
        wget \
        ca-certificates \
        libc6-i386 \
        language-pack-en \
        mysql-client \
        net-tools \ 
        libtbb2:i386 \
        binutils
RUN apt-get upgrade -y
RUN apt-get clean
RUN echo steam steam/question select "I AGREE" | debconf-set-selections
RUN echo steam steam/license note '' | debconf-set-selections
RUN apt-get install -q -y steamcmd
RUN ln -s /usr/games/steamcmd /bin/steamcmd
RUN chmod -R a=u /usr/games/steamcmd
#end steamcmd

#Pwsh section
RUN wget -q http://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN add-apt-repository universe
RUN apt-get update
RUN apt-get install -y powershell
RUN apt-get remove --purge -y
RUN apt-get clean autoclean
RUN apt-get autoremove -y
RUN rm /var/lib/apt/lists/* -r
RUN rm packages-microsoft-prod.deb

RUN git config --global http.sslVerify false
RUN mkdir /mods

#arma3profile , -name=rpf
WORKDIR /arma3
RUN mkdir ./configs
RUN mkdir -p ~/".local/share/Arma 3 - Other Profiles/rpf"


#Scripts section
WORKDIR /root/".local/share/Arma 3 - Other Profiles/rpf"
COPY misc/rpf.Arma3Profile .

#persistent
VOLUME /root 
VOLUME /arma3

#ports
EXPOSE 2302/udp
EXPOSE 2303/udp
EXPOSE 2304/udp
EXPOSE 2305/udp
EXPOSE 2306/udp

ADD setup.ps1 /home

STOPSIGNAL SIGINT

CMD [ "pwsh","/home/setup.ps1" ]
