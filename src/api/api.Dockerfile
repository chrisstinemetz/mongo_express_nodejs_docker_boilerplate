FROM node:12.18 AS development

RUN mkdir -p /src/api && chown node:node /src/api

USER node

WORKDIR /src/api

COPY --chown=node:node package.json package-lock.json ./

RUN npm install --quiet

FROM node:12.18-slim AS production

USER node

WORKDIR /src/api

#COPY --from=development /src/api/node_modules ./node_modules 
COPY --from=development --chown=root:root /src/api/node_modules ./node_modules

COPY . .

EXPOSE 3000

ENV MONGODB_USERNAME=root
ENV MONGODB_PASSWORD=secret

CMD ["npm", "start"]