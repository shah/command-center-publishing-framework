local context = import "context.ccpf-facts.json";

{
    plantUmlJar: context.CCPF_HOME + "/bin/plantuml.1.2019.0.jar",
    plantUmlCmd(sourceFile, destPath, type = "png"): 
        context.vendor.javaHome + "/bin/java -jar " + $.plantUmlJar + " -t" + type + " -o " + destPath + " " + sourceFile
}
