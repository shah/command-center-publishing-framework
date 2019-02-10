local context = import "context.ccpf-facts.json";

{
    plantUmlJar: context.CCPF_HOME + "/bin/plantuml.jar",
    plantUmlCmd(sourceFile, destPath, type = "png"): 
        context.vendor.javaHome + "/bin/java -jar " + $.plantUmlJar + " -t" + type + " -o " + destPath + " " + sourceFile
}
