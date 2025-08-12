FROM golang:1.21-alpine AS builder
RUN apk add --no-cache git
RUN go install github.com/yudai/gotty@v1.0.1

FROM alpine:latest
RUN apk add --no-cache bash
COPY --from=builder /go/bin/gotty /usr/local/bin/gotty

# Render provides $PORT automatically, so no EXPOSE needed here
CMD ["sh", "-c", "gotty --port $PORT --permit-write /bin/bash"]
