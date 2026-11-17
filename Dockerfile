# Stage 1: Build Go application
FROM golang:1.22.5 AS builder

WORKDIR /app

COPY go.mod  ./

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o main .

# Stage 2: Distroless runtime
FROM gcr.io/distroless/static-debian12

WORKDIR /

COPY --from=builder /app/main /main

COPY --from=builder /app/web-app /web-app

EXPOSE 8080

CMD ["/main"]