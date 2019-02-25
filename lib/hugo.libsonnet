local context = import "context.ccpf-facts.json";
local eth0 = import "eth0-interface-localhost.ccpf-facts.json";

{
    hugoCmd: context.CCPF_HOME + "/bin/hugo",
	main: {
		id: "main",
		sourcePath : "hugo-src-main",
		sourcePathAbs : context.projectHome + "/" + $.main.sourcePath,
		publishPath : "hugo-publish-main",
		publishPathAbs : context.projectHome + "/" + $.main.publishPath,
	},

	shortCode: {
		plantUmlDiagram: {
			fileName(sourcePath): "%(sourcePath)s/layouts/shortcodes/plantuml.html" % {sourcePath : sourcePath},
			content: '<img class="plantUML" src="/images/generated/diagrams/{{ .Get "diagram" }}.diagram.png" align="{{ if .Get "align" }}{{ .Get "align" }}{{ else }}center{{ end }}"/>'
		}
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
