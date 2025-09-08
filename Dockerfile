# --- Stage 1: Frontend Builder ---
FROM node:alpine AS frontend-builder

WORKDIR /app

RUN npm i -g pnpm
COPY pnpm-lock.yaml package.json ./
COPY ./dashboard/patches/ ./patches/
RUN pnpm i

COPY . .
RUN pnpm build \
  # remove source maps - people like small image
  && rm public/*.map || true

# --- Stage 2: Backend Builder ---
FROM golang:1.21-alpine AS backend-builder

# Set working directory
WORKDIR /app

# Copy Go modules files for better caching
COPY go.mod go.sum ./
RUN go mod download

# Copy source code and build
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build

FROM alpine:latest

# Install a shell and CA certificates
RUN apk add --no-cache bash ca-certificates tzdata

# Set working directory inside container
WORKDIR /app

COPY --from=backend-builder /app/clash .
COPY --from=frontend-builder /app/public /app/dashboard/public
COPY Country.mmdb /app/Country.mmdb

CMD ["./clash", "-d", "/app/conf"]
