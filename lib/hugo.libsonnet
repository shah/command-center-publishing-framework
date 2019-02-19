local context = import "context.ccpf-facts.json";
local eth0 = import "eth0-interface-localhost.ccpf-facts.json";

{
    hugoCmd: context.CCPF_HOME + "/bin/hugo",
	main: {
		id: "main",
		sourcePath : "hugo-src-main",
		publishPath : "hugo-publish-main" 
	},

    make(id, sourcePath, publishPath): 
		"" + |||
		## Serve %(id)s Hugo content at http://%(ipAddress)s
		hugo-serve-%(id)s:
			cd %(sourcePath)s && \
				%(hugoCmd)s serve --bind %(ipAddress)s --baseURL http://%(ipAddress)s --disableFastRender

		## Create %(id)s Hugo static content in '%(publishPath)s' directory
		hugo-publish-%(id)s: clean-hugo-publish-%(id)s
			cd %(sourcePath)s && \
				%(hugoCmd)s --destination %(publishPath)s --minify

		## Delete %(id)s Hugo static content directory '%(publishPath)s' 
		clean-hugo-publish-%(id)s:
			rm -rf %(publishPath)s
||| % { id: id, sourcePath: sourcePath, publishPath: publishPath, hugoCmd : $.hugoCmd, ipAddress: eth0.address },
}
