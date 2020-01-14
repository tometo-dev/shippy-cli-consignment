FROM golang:alpine as builder
RUN apk update && apk upgrade && apk add --no-cache git
RUN apk add --no-cache gcc musl-dev linux-headers
WORKDIR /app
COPY . .
RUN go get
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o shippy-cli-consignment

FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /app
ADD consignment.json /app/consignment.json
COPY --from=builder /app/shippy-cli-consignment .
CMD ["./shippy-cli-consignment"]