FROM node:24-alpine

# Patch OS packages (fixes the OpenSSL findings)
RUN apk upgrade --no-cache

WORKDIR /app
COPY package*.json ./
RUN npm install --omit=dev && npm cache clean --force
COPY . .

# npm/yarn/corepack are only needed to install. Remove them from the runtime image.
RUN rm -rf /usr/local/lib/node_modules/npm /usr/local/lib/node_modules/corepack \
           /usr/local/bin/npm /usr/local/bin/npx /usr/local/bin/corepack \
           /usr/local/bin/yarn /usr/local/bin/yarnpkg /opt/yarn-*

USER node
EXPOSE 3000
CMD ["node", "server.js"]
