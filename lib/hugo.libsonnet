local context = import "context.ccpf-facts.json";
local eth0 = import "eth0-interface-localhost.ccpf-facts.json";

{
    hugoCmd: context.CCPF_HOME + "/bin/hugo",
    mainSourcePath: "hugo-src-main",
    publishPath: "publication",

    make : {
		hugoTargets: |||
		## Serve Hugo content at http://%(ipAddress)s
		hugo-serve:
			cd %(hugoSourcePath)s && \
				%(hugoCmd)s serve --bind %(ipAddress)s --baseURL http://%(ipAddress)s --disableFastRender

		## Create Hugo static content in '%(hugoPublishPath)s' directory
		hugo-publish: clean-hugo-publish
			cd %(hugoSourcePath)s && \
				%(hugoCmd)s --destination %(hugoPublishPath)s --minify

		## Delete Hugo static content directory '%(hugoPublishPath)s' 
		clean-hugo-publish:
			rm -rf %(hugoPublishPath)s
||| % { hugoCmd : $.hugoCmd, hugoSourcePath : $.mainSourcePath, hugoPublishPath: $.publishPath, ipAddress: eth0.address },
    },
}
