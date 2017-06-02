FROM rastydnb/agent-base

RUN apt-get update && \
        apt-get install --no-install-recommends -y \
	build-essential \
	git \
	wget
COPY register.py resolve_url.py run.sh /
RUN wget https://storage.googleapis.com/golang/go1.7.5.linux-armv6l.tar.gz
RUN tar -xvf go1.7.5.linux-armv6l.tar.gz -C /usr/local
ENV PATH /usr/local/go/bin:$PATH
RUN mkdir /go
ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV PATH $GOPATH/bin:$GOROOT/bin:$PATH
RUN go get github.com/rancher/agent
RUN cd $GOPATH/src/github.com/rancher/agent && go build && go install


ADD bootstrap.sh /tmp/bootstrap.sh
RUN chmod +x /run.sh /register.py /resolve_url.py /tmp/bootstrap.sh
ENTRYPOINT ["/run.sh"]
LABEL "io.rancher.container.system"="rancher-agent"
RUN ls -la /var/lib/cattle/
ADD host-api /host-api
ENV RANCHER_AGENT_IMAGE rancher/agent:v1.2.2
