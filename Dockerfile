FROM ubuntu:16.04

RUN apt-get -y update && apt-get -y install gcc perl csh libaio1 libc6 libstdc++6 iputils-ping uuid uuid-runtime

COPY sapinst /tmp/sapinst
COPY zinstall.sh /tmp/sapinst
WORKDIR /tmp/sapinst
RUN chmod +x zinstall.sh
RUN mkdir /run/uuuidd

# HTTP
EXPOSE 8000
# HTTPS
EXPOSE 44300
# ADT
EXPOSE 3300
# SAP GUI
EXPOSE 3200