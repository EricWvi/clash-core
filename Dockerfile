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

CMD ["./clash", "-d", "/app/conf"]
