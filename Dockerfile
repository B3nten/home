FROM alpine:latest as build

RUN apk add --update zip bash

COPY redbean-3.0.0.com /redbean.com

RUN zip -R /redbean.com assets/*

COPY src /src
WORKDIR /src
RUN zip -R /redbean.com '*.lua' '*.html' '*.js' '*.css'

RUN chmod +x /redbean.com

FROM alpine:latest as scratch

COPY --from=build /redbean.com /

CMD ["/bin/sh", "-c", "/redbean.com", "-vv", "-p", "${HOST_VARIABLE}"]
