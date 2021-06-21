FROM node:14 AS superset-node

ARG NPM_VER=7
RUN npm install -g npm@${NPM_VER}

ARG NPM_BUILD_CMD="build"
ENV BUILD_CMD=${NPM_BUILD_CMD}

# NPM ci first, as to NOT invalidate previous steps except for when package.json changes
RUN mkdir -p /app/superset-frontend
RUN mkdir -p /app/superset/assets

COPY ./superset-ui  /app/superset-ui
WORKDIR /app/superset-ui
RUN npm install --force
RUN yarn build --type false


WORKDIR /app/

RUN wget -O superset-1.1.0.tar.gz https://github.com/apache/superset/archive/1.1.0.tar.gz
RUN tar  xzvf superset-1.1.0.tar.gz

#COPY ./docker/frontend-mem-nag.sh /


COPY ./superset-fronted-override/package* /app/superset-1.1.0/superset-frontend
WORKDIR /app/superset-1.1.0/superset-frontend
RUN  npm ci

RUN npm run ${BUILD_CMD}
RUN rm -rf node_modules

FROM apache/superset:1.1.0

COPY --from=superset-node /app/superset-1.1.0/superset/static/assets /app/superset/static/assets
COPY --from=superset-node /app/superset-1.1.0/superset-frontend /app/superset-frontend
USER root
RUN cd /app \
        && chown -R superset:superset *

# Switching to root to install the required packages

# Example: installing the MySQL driver to connect to the metadata database
# if you prefer Postgres, you may want to use `psycopg2-binary` instead
RUN pip install mysqlclient
# Example: installing a driver to connect to Redshift
# Find which driver you need based on the analytics database
# you want to connect to here:
# https://superset.apache.org/installation.html#database-dependencies
RUN pip install pybigquery
# Switching back to using the `superset` user

USER superset


