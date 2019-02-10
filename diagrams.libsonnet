local context = import "context.ccpf-facts.json";

{
    plantUmlJar: context.CCPF_HOME + "/bin/plantuml.jar",
    plantUmlCmd(sourceFile, destPath, type = "png"): 
        context.vendor.javaHome + "/bin/java -jar " + $.plantUmlJar + " -t" + type + " -o " + destPath + " " + sourceFile,

    make: {
        define: {
            dependencies: |||
            # Find all PlantUML diagrams in the source and prepare list to generate the *.png versions
            # Recursion tip: https://stackoverflow.com/questions/2483182/recursive-wildcards-in-gnu-make
            CCPF_PROJECT_SSG_CONTENT_REL ?= hugo-src-main
            CCPF_PROJECT_PUML_DIAGRAM_SOURCES = $(shell find $(CCPF_PROJECT_SSG_CONTENT_REL)/ -type f -name '*.diagram.puml')
            CCPF_PROJECT_PUML_DIAGRAMS_PNG = $(patsubst $(CCPF_PROJECT_SSG_CONTENT_REL)/%.diagram.puml, $(CCPF_PROJECT_SSG_CONTENT_PATH)/static/img/generated/diagrams/%.diagram.png, $(CCPF_PROJECT_PUML_DIAGRAM_SOURCES))
            |||
        },

        target: {
            diagrams: |||
            $(CCPF_PROJECT_SSG_CONTENT_REL)/static/img/generated/diagrams/%.diagram.png: $(CCPF_PROJECT_SSG_CONTENT_REL)/%.diagram.puml
                echo "Generating diagram: $<"
                mkdir -p "$(@D)"
                %(javaHome)s/bin/java -jar %(plantUmlJar)s -tpng -o "$(@D)" "$<"
            ||| % (javaHome: context.vendor.javaHome, plantUmlJar: $.plantUmlJar)
        },
    },
}
