FROM alpine:latest
MAINTAINER Shawn <qiusct@gmail.com>

ADD saltstack.run /usr/local/bin/saltstack.run

RUN apk add --no-cache python py-crypto py-jinja2 py-tornado py-yaml && \
	apk add --no-cache -X http://dl-4.alpinelinux.org/alpine/edge/testing py-msgpack py-zmq salt && \
	\
	\
	mkdir -p /srv/salt /srv/pillar && \
	chmod 0700 /srv/pillar && \
	\
	\
	sed -i 's/^#master: salt/master: 127.0.0.1/;s/^#id:/id: minion/' /etc/salt/minion && \
	sed -i 's/^#worker_threads: 5/worker_threads: 20/' /etc/salt/master && \
	salt-master -d && salt-minion -d && while(true) ; do salt-key -yA && break || sleep 15 ; done && \
	chmod +x /usr/local/bin/saltstack.run

EXPOSE 4505 4506 
VOLUME ["/srv/salt", "/srv/pillar"] 
CMD ["/usr/local/bin/saltstack.run"]
