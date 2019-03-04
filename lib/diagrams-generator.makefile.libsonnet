# This Makefile is called by the CCPF main Makefile, it is not designed to be
# called on its own. The following variables are expected to be passed through
# the environment:
# CCPF_HOME, CCPF_VERSION, CCPF_LOG_LEVEL
# CCPF_JSONNET, CCPF_JQ 
# CCPF_PROJECT_NAME, CCPF_PROJECT_HOME, CCPF_PROJECT_VENDOR_HOME
# CCPF_FACTS_DEST_PATH

SHELL := /bin/bash
MAKEFLAGS := silent

CURRENT_DIR_NAME := $(shell basename `pwd`)
CURRENT_DIR_ABS_PATH := $(shell echo `pwd`)
CURRENT_DIR_REL_PATH := $(shell realpath --relative-to=$(CCPF_PROJECT_HOME) $(CURRENT_DIR_ABS_PATH))

SOURCE_HOME_REL_PATH := %(sourceHomeRelPath)s
GENERATED_DIAGRAMS_HOME_REL_PATH := %(generatedDiagramsHomeRelPath)s
GENERATED_DIAGRAMS_HOME_ABS_PATH := $(shell realpath $(GENERATED_DIAGRAMS_HOME_REL_PATH))

# Find all PlantUML diagrams in the source and prepare list to generate the *.png versions
# Recursion tip: https://stackoverflow.com/questions/2483182/recursive-wildcards-in-gnu-make
PUML_DIAGRAM_SOURCES_REL = $(shell find $(SOURCE_HOME_REL_PATH) -type f -name '*.diagram.puml')
PUML_DIAGRAM_PNGs_REL = $(patsubst $(SOURCE_HOME_REL_PATH)/%%.diagram.puml, $(GENERATED_DIAGRAMS_HOME_REL_PATH)/diagrams/%%.diagram.png, $(PUML_DIAGRAM_SOURCES_REL))
PUML_DIAGRAM_PNGs_ABS = $(patsubst $(SOURCE_HOME_REL_PATH)/%%.diagram.puml, $(GENERATED_DIAGRAMS_HOME_ABS_PATH)/diagrams/%%.diagram.png, $(PUML_DIAGRAM_SOURCES_REL))

include $(CCPF_HOME)/lib/common.ccpf-make.inc

default:
	$(call logInfo,No default target in $(YELLOW)$(CURRENT_DIR_REL_PATH)/Makefile$(RESET))

$(GENERATED_DIAGRAMS_HOME_ABS_PATH)/diagrams/%%.diagram.png: $(SOURCE_HOME_REL_PATH)/%%.diagram.puml
	$(call logInfo,Generated diagram $(YELLOW)$<$(RESET))
	mkdir -p "$(@D)"
	$(CCPF_PROJECT_VENDOR_HOME)/java/home/bin/java -jar $(CCPF_HOME)/bin/plantuml.jar -tpng -o "$(@D)" "$<"

## Generate all diagrams (PlantUML, etc.) in $(SOURCE_HOME_REL_PATH)
generate: vendorize $(PUML_DIAGRAM_PNGs_ABS)

clean:
	$(call logInfo,Deleting diagrams in $(YELLOW)$(CURRENT_DIR_NAME)/$(GENERATED_DIAGRAMS_HOME_ABS_PATH)$(RESET))
	rm -rf $(GENERATED_DIAGRAMS_HOME_ABS_PATH)

vendorize: $(CCPF_PROJECT_VENDOR_HOME)/java/home

## Show diagrams discovered (PlantUML, etc.) in $(SOURCE_HOME_REL_PATH)
list-diagrams: 
	echo $(PUML_DIAGRAM_SOURCES_REL)
	tree $(GENERATED_DIAGRAMS_HOME_REL_PATH)
