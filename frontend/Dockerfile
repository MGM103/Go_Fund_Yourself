FROM node:18-alpine AS builder

#Define build time env args
ARG DB_PATH
ARG PUBLIC_WALLET_CONNECT_ID
ARG SEPOLIA_RPC_URL
ENV DB_PATH=${DB_PATH}
ENV PUBLIC_WALLETCONNECT_ID=${PUBLIC_WALLET_CONNECT_ID}
ENV SEPOLIA_RPC_URL=${SEPOLIA_RPC_URL}

WORKDIR /app
RUN mkdir data
COPY package*.json .
RUN npm ci
COPY . . 
RUN npm run build
RUN npm ci --prod

FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/build ./build
COPY --from=builder /app/node_modules ./node_modules
COPY package*.json .

CMD ["node", "build"]