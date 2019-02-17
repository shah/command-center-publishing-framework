local context = import "context.ccpf-facts.json";
local hugo = import "hugo.libsonnet";

{
    plantUmlJar: context.CCPF_HOME + "/bin/plantuml.jar",
    plantUmlCmd(sourceFile, destPath, type = "png"): 
        context.vendor.javaHome + "/bin/java -jar " + $.plantUmlJar + " -t" + type + " -o " + destPath + " " + sourceFile,

    make(id, sourcePath): 
		"" + |||
		# Find all PlantUML diagrams in the source and prepare list to generate the *.png versions
		# Recursion tip: https://stackoverflow.com/questions/2483182/recursive-wildcards-in-gnu-make
		CCPF_PROJECT_PUML_DIAGRAM_SOURCES_%(id)s = $(shell find %(sourcePathRel)s -type f -name '*.diagram.puml')
		CCPF_PROJECT_PUML_DIAGRAMS_PNG_%(id)s = $(patsubst %(sourcePathRel)s/%%.diagram.puml, %(sourcePathAbs)s/static/images/generated/diagrams/%%.diagram.png, $(CCPF_PROJECT_PUML_DIAGRAM_SOURCES_%(id)s))

		%(sourcePathAbs)s/static/images/generated/diagrams/%%.diagram.png: %(sourcePathRel)s/%%.diagram.puml
			echo "Generating diagram: $<"
			mkdir -p "$(@D)"
			%(javaHome)s/bin/java -jar %(plantUmlJar)s -tpng -o "$(@D)" "$<"

		clean-generated-diagrams-puml-%(id)s.png:
			rm -rf %(sourcePathAbs)s/static/images/generated

		## Show diagrams discovered (PlantUML, etc.)
		list-diagrams-%(id)s: 
			echo $(CCPF_PROJECT_PUML_DIAGRAM_SOURCES_%(id)s)
			echo $(CCPF_PROJECT_PUML_DIAGRAMS_PNG_%(id)s)

		## Generate all diagrams (PlantUML, etc.)
		generate-diagrams-%(id)s: $(CCPF_PROJECT_PUML_DIAGRAMS_PNG_%(id)s)

		## Delete all generated diagrams (PlantUML, etc.)
		clean-generated-diagrams-%(id)s: clean-generated-diagrams-puml.png
||| % { id: id, sourcePathRel: sourcePath, sourcePathAbs: context.projectHome + '/' + sourcePath, javaHome: context.vendor.javaHome, plantUmlJar: $.plantUmlJar },
}
