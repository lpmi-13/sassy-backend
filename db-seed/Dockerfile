FROM golang:1.22-alpine AS builder

ARG USER=seeder
ARG GROUP=seeder-group
ARG USER_ID=1000
ARG GROUP_ID=1001

RUN adduser --disabled-password --shell /bin/false --uid $USER_ID $USER \
    && cat /etc/passwd | grep $USER > /tmp/passwd_file

RUN addgroup --gid $GROUP_ID $GROUP
RUN addgroup $USER $GROUP

WORKDIR /app

COPY go.mod ./
COPY go.sum ./

RUN go mod download

COPY main.go ./

RUN CGO_ENABLED=0 go build -ldflags="-w -s" -o /db-seed

FROM scratch

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /tmp/passwd_file /etc/passwd
COPY --from=builder /db-seed /db-seed

USER seeder

CMD ["/db-seed"]
