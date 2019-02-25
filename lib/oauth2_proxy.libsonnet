local context = import "context.ccpf-facts.json";

{
    vendor: {
   		oauth2ProxyCmd : "vendor/oauth2_proxy",
    },

    docker: {
        serveUpstreamHost(upstreamHost, upstreamPort = 80, upstreamPath = "/", listenHost = "localhost", listenPort = 4180, authnEmailsFile = "etc/oauth2_proxy-authenticated-emails.conf"): |||
            FROM alpine
            #RUN apt-get update -y && apt-get install -y ca-certificates
            COPY %(oauth2ProxyCmd)s /bin/oauth2_proxy
            COPY %(authnEmailsFile)s /etc/oauth2_proxy-authenticated-emails.conf
            EXPOSE %(upstreamPort)d %(listenPort)d
            ENTRYPOINT [ "/bin/oauth2_proxy" ]
            CMD [ "-upstream=%(upstreamHost)s:%(upstreamPort)d%(upstreamPath)s", \
                "-http-address=%(listenHost)s:%(listenPort)d", \
                "-authenticated-emails-file=/etc/oauth2_proxy-authenticated-emails.conf" ]
||| % { 
        oauth2ProxyCmd: $.vendor.oauth2ProxyCmd, 
        upstreamHost: upstreamHost, upstreamPort: upstreamPort, 
        listenHost : listenHost,
        listenPort : listenPort, 
        authnEmailsFile: authnEmailsFile },

        serveStaticFiles(staticFilesSrc, listenHost = "localhost", listenPort = 4180, authnEmailsFile = "etc/oauth2_proxy-authenticated-emails.conf"): |||
            FROM alpine
            #RUN apt-get update -y && apt-get install -y ca-certificates
            COPY %(oauth2ProxyCmd)s /bin/oauth2_proxy
            COPY %(staticFilesSrc)s /static
            COPY %(authnEmailsFile)s /etc/oauth2_proxy-authenticated-emails.conf
            EXPOSE %(listenPort)d
            ENTRYPOINT [ "/bin/oauth2_proxy" ]
            CMD [ "-upstream=file:///static/#/", \
                "-http-address=%(listenHost)s:%(listenPort)d", \
                "-authenticated-emails-file=/etc/oauth2_proxy-authenticated-emails.conf", \
                "-cookie-secure=false" ]
||| % { 
        oauth2ProxyCmd: $.vendor.oauth2ProxyCmd, 
        staticFilesSrc: staticFilesSrc,
        listenHost : listenHost,
        listenPort : listenPort,
        authnEmailsFile: authnEmailsFile },
    },
}