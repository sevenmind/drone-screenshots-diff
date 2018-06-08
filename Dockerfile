FROM google/cloud-sdk:alpine

COPY script.sh /bin/
RUN chmod +x /bin/script.sh

ENTRYPOINT /bin/script.sh