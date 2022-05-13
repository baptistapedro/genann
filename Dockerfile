FROM fuzzers/afl:2.52

RUN apt-get update
RUN apt install -y build-essential wget git clang cmake \ 
    autoconf automake autotools-dev libtool pkg-config 
RUN git clone https://github.com/codeplea/genann.git
WORKDIR /genann
COPY fuzzers/fuzz.c .
RUN afl-clang fuzz.c -o /fuzz genann.c -lm
RUN mkdir /genCorpus
RUN cp ./example/*.ann /genCorpus

ENTRYPOINT ["afl-fuzz", "-i", "/genCorpus", "-o", "/genOut"]
CMD ["/fuzz", "@@"]
