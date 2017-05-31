FROM rastydnb/agent-base
COPY register.py resolve_url.py run.sh /

RUN apt-get update && \
        apt-get install --no-install-recommends -y \
	build-essential \
	git \
	wget

RUN wget https://storage.googleapis.com/golang/go1.7.5.linux-armv6l.tar.gz
RUN tar -xvf go1.7.5.linux-armv6l.tar.gz -C /usr/local
ENV PATH /usr/local/go/bin:$PATH
RUN mkdir /go
ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV PATH $GOPATH/bin:$GOROOT/bin:$PATH
RUN go get github.com/rancher/agent
RUN cd $GOPATH/src/github.com/rancher/agent && go build && go install
RUN cd $GOPATH/src/github.com/rancher/agent && ls -la
RUn cd /bin && ls -la

RUN chmod +x /run.sh /register.py /resolve_url.py
ENTRYPOINT ["/run.sh"]
LABEL "io.rancher.container.system"="rancher-agent"
ENV RANCHER_AGENT_IMAGE rancher/agent:v1.2.2
