local context = import "context.ccpf-facts.json";

{
    vendor: {
   		oauth2ProxyCmd : context.vendor.path + "/oauth2_proxy",
    },

    dockerFile(upstreamHost, upstreamPort = 80, listenPort = 4180, authnEmailsFile = "etc/oauth2_proxy-authenticated-emails.conf"): |||
        FROM debian:stable-slim
        RUN apt-get update -y && apt-get install -y ca-certificates
        COPY %(oauth2ProxyCmd)s /bin/oauth2_proxy
        COPY %(authnEmailsFile)s /etc/oauth2_proxy-authenticated-emails.conf
        EXPOSE %(upstreamPort)d %(listenPort)d
        ENTRYPOINT [ "/bin/oauth2_proxy" ]
        CMD [ "-upstream=%(upstreamHost)s:%(upstreamPort)d", 
              "-http-address=0.0.0.0:%(listenPort)d", 
              "-authenticated-emails-file=/etc/oauth2_proxy-authenticated-emails.conf" ]
||| % { 
    oauth2ProxyCmd: $.vendor.oauth2ProxyCmd, 
    upstreamHost: upstreamHost, upstreamPort: upstreamPort, 
    listenPort : listenPort, 
    authnEmailsFile: authnEmailsFile },
}