local context = import "context.ccpf-facts.json";
local hugo = import "hugo.libsonnet";

{
    plantUmlJar: context.CCPF_HOME + "/bin/plantuml.jar",
    plantUmlCmd(sourceFile, destPath, type = "png"): 
        context.vendor.javaHome + "/bin/java -jar " + $.plantUmlJar + " -t" + type + " -o " + destPath + " " + sourceFile,

    make: {
        plantUmlDeps: |||
		# Find all PlantUML diagrams in the source and prepare list to generate the *.png versions
		# Recursion tip: https://stackoverflow.com/questions/2483182/recursive-wildcards-in-gnu-make
		CCPF_PROJECT_PUML_DIAGRAM_SOURCES = $(shell find %(hugoSourcePath)s/ -type f -name '*.diagram.puml')
		CCPF_PROJECT_PUML_DIAGRAMS_PNG = $(patsubst %(hugoSourcePath)s/%%.diagram.puml, %(hugoSourcePath)s/static/images/generated/diagrams/%%.diagram.png, $(CCPF_PROJECT_PUML_DIAGRAM_SOURCES))
||| % { hugoSourcePath : hugo.mainSourcePath },

        plantUmlTargets: |||
		%(hugoSourcePath)s/static/images/generated/diagrams/%%.diagram.png: %(hugoSourcePath)s/%%.diagram.puml
			echo "Generating diagram: $<"
			mkdir -p "$(@D)"
			%(javaHome)s/bin/java -jar %(plantUmlJar)s -tpng -o "$(@D)" "$<"

		clean-generated-diagrams-puml.png:
			rm -rf %(hugoSourcePath)s/static/images/generated
||| % { javaHome: context.vendor.javaHome, plantUmlJar: $.plantUmlJar, hugoSourcePath : hugo.mainSourcePath },

		diagramsTargets: |||
		%(plantUmlDeps)s
		%(plantUmlTargets)s
		## Show diagrams discovered (PlantUML, etc.)
		list-diagrams: 
			echo $(CCPF_PROJECT_PUML_DIAGRAM_SOURCES)
			echo $(CCPF_PROJECT_PUML_DIAGRAMS_PNG)

		## Generate all diagrams (PlantUML, etc.)
		generate-diagrams: $(CCPF_PROJECT_PUML_DIAGRAMS_PNG)

		## Delete all generated diagrams (PlantUML, etc.)
		clean-generated-diagrams: clean-generated-diagrams-puml.png
||| % { plantUmlDeps: $.make.plantUmlDeps, plantUmlTargets: $.make.plantUmlTargets },
    },
}
