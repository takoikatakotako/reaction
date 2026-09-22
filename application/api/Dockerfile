FROM golang:1.23.2-alpine3.19 AS builder
WORKDIR /app
COPY .. .
RUN go mod tidy
# main.go だけを指定すると同じ package の他ファイル（logger.go 等）が
# コンパイル対象から外れるため、package 単位でビルドする
RUN CGE_ENABLE=0 GOOS=linux GOARCH=arm64 go build -o main ./api


FROM golang:1.23.2-alpine3.19

WORKDIR /app
COPY --from=builder /app/main .

COPY --from=public.ecr.aws/awsguru/aws-lambda-adapter:0.9.0 /lambda-adapter /opt/extensions/lambda-adapter

EXPOSE 8080

CMD ["/app/main"]
