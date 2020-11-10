FROM ubuntu:16.04

RUN apt-get update && apt-get install -y \
    wget dos2unix \
    python3 \
    python3-pip \
    python3-setuptools \
    python3-dev \
    cmake unzip git
RUN pip3 install networkx
RUN pip3 install pandas
RUN pip3 install pyfastaq

##Download CCGBpipe
WORKDIR /opt
RUN git clone https://github.com/wiliamwalace/CCBGpipe.git
WORKDIR /opt/CCBGpipe/CCBGpipe
RUN chmod +x *.py

#guppy 4.0.14
#This software requires the user to download manually!!!


#samtools 1.9
ADD https://github.com/samtools/samtools/releases/download/1.9/samtools-1.9.tar.bz2 /opt
RUN apt-get update && apt-get install -y \
    libncurses-dev \
    apt-file \
    liblzma-dev \
    libz-dev \
    libbz2-dev \
    vim parallel
WORKDIR /opt
RUN tar -xjf /opt/samtools-1.9.tar.bz2
WORKDIR /opt/samtools-1.9
RUN make && make install
WORKDIR /

#bwa BWA-0.7.17
WORKDIR /opt
RUN git clone https://github.com/lh3/bwa.git
WORKDIR /opt/bwa
RUN make
WORKDIR /

#nanopolish v0.13.2
RUN apt-get update && apt-get install -y python-pip python-dev python-biopython build-essential python-matplotlib
WORKDIR /opt
RUN git clone --recursive https://github.com/jts/nanopolish.git
WORKDIR /opt/nanopolish
RUN git checkout v0.13.2
RUN make
WORKDIR /

#canu v2.1
WORKDIR /opt
RUN wget https://github.com/marbl/canu/archive/v2.1.tar.gz
RUN gunzip -dc v2.1.tar.gz | tar -xf -
WORKDIR /opt/canu-2.1/src
RUN make -j 16
WORKDIR /

#MUMmer 3.23
WORKDIR /opt
RUN wget https://sourceforge.net/projects/mummer/files/mummer/3.23/MUMmer3.23.tar.gz
RUN tar -zxvf MUMmer3.23.tar.gz
WORKDIR /opt/MUMmer3.23
RUN make
RUN make install
WORKDIR /

#Minimap2, miniasm-0.2
WORKDIR /opt
RUN curl -L https://github.com/lh3/minimap2/releases/download/v2.17/minimap2-2.17_x64-linux.tar.bz2  | tar -jxvf -
RUN wget https://github.com/lh3/miniasm/archive/v0.3.tar.gz \
    && tar -xzf v0.3.tar.gz \
    && (cd /opt/miniasm-0.3 && make) \
    && rm v0.3.tar.gz
WORKDIR /

#Racon1.4.17
WORKDIR /opt
RUN wget https://github.com/isovic/racon/releases/download/1.4.17/racon-v1.4.17.tar.gz \
    && tar -xzf racon-v1.4.17.tar.gz \
    && (cd /opt/racon-v1.4.17 && cmake -DCMAKE_BUILD_TYPE=Release && make) \
    && rm racon-v1.4.17.tar.gz
WORKDIR /


#Graphmap v0.5.2
WORKDIR /opt
RUN git clone https://github.com/isovic/graphmap.git
WORKDIR /opt/graphmap
RUN make modules && make
WORKDIR /

#set path
ENV PATH $PATH:/opt:/opt/CCBGpipe/CCBGpipe:/opt/samtools-1.9/bin:/opt/bwa:/opt/nanopolish:/opt/nanopolish/scripts:/opt/canu-2.1/Linux-amd64/bin:/opt/MUMmer3.23:/opt/minimap2-2.17_x64-linux/:/opt/miniasm-0.3:/opt/racon-v1.4.17/bin:/opt/graphmap/bin/Linux-x64
