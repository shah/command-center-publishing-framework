local context = import "context.ccpf-facts.json";

{
    vendor: {
   		oauth2ProxyCmd : "vendor/oauth2_proxy",
    },

    docker: {
        serveStaticFiles(staticFilesSrc, oauth2ProxyListenPort = 4180, oauth2ProxyConfigFile = "etc/oauth2_proxy-main.cfg", oauth2ProxyAuthnEmailsFile = "etc/oauth2_proxy-authenticated-emails.conf"): |||
            FROM alpine
            #RUN apt-get update -y && apt-get install -y libc6-compat ca-certificates
            COPY %(oauth2ProxyCmd)s /bin/oauth2_proxy
            COPY %(staticFilesSrc)s /static
            COPY %(oauth2ProxyAuthnEmailsFile)s /etc/oauth2_proxy-authenticated-emails.conf
            COPY %(oauth2ProxyConfigFile)s /etc/oauth2_proxy.cfg
            EXPOSE %(oauth2ProxyListenPort)d
            ENTRYPOINT [ "/bin/oauth2_proxy" ]
            CMD [ "-upstream=file:///static/#/", \
                  "-authenticated-emails-file=/etc/oauth2_proxy-authenticated-emails.conf", \
                  "-config=/etc/oauth2_proxy.cfg" ]
||| % { 
        oauth2ProxyCmd: $.vendor.oauth2ProxyCmd, 
        staticFilesSrc: staticFilesSrc,
        oauth2ProxyConfigFile : oauth2ProxyConfigFile,
        oauth2ProxyAuthnEmailsFile: oauth2ProxyAuthnEmailsFile,
        oauth2ProxyListenPort: oauth2ProxyListenPort },
    },
}