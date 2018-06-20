FROM google/cloud-sdk:alpine
MAINTAINER Benjamin Müller <benjamin@7mind.de>

RUN apk update && apk add jq

COPY script.sh /bin/
RUN chmod +x /bin/script.sh

ENTRYPOINT /bin/script.sh