FROM node:24-alpine AS verify
WORKDIR /app
COPY server.js .
RUN node --check server.js
FROM node:24-alpine AS production
WORKDIR /app
COPY --from=verify /app/server.js ./server.js
USER node
EXPOSE 8080
CMD ["node","server.js"]
