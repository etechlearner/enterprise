FROM centos/nodejs-10-centos7:latest

ENV RPM stoplight-frontend-0.1.0.alpha.3-1.noarch.rpm
COPY ${RPM} /tmp/

USER root
RUN rpm -ivh /tmp/${RPM} --nodeps

USER default
ENV NODE_PATH /opt/stoplight-frontend/node_modules
WORKDIR /opt/stoplight-frontend/node_modules/@stoplight/frontend
CMD ["node","./server/index.js"]
