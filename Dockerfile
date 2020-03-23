FROM golang:1.14 as builder

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -trimpath -o supervisord .


FROM alpine:latest

RUN apk --no-cache add ca-certificates

WORKDIR /

# Copy the Pre-built binary file from the previous stage
COPY --from=builder /app/supervisord /

# Expose port 8080 to the outside world
EXPOSE 8080

# Command to run the executable
CMD ["/supervisord"]