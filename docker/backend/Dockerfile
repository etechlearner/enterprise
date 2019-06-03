FROM centos/nodejs-10-centos7:latest

ENV RPM stoplight-backend-0.1.0.alpha.5-1.noarch.rpm
COPY ${RPM} /tmp/

USER root
RUN rpm -i /tmp/${RPM} --nodeps

USER default
ENV NODE_PATH /opt/stoplight-backend/node_modules
WORKDIR /opt/stoplight-backend/node_modules/@stoplight/backend
CMD ["node","./dist/src/index.js"]
