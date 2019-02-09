// This is a template for the context.rsmf-facts.jsonnet file that is generated
// automatically for each project.
{
	CCPF_VERSION : std.extVar('CCPF_VERSION'),
	CCPF_HOME : std.extVar('CCPF_HOME'),
	CCPF_FACTS_FILES : std.extVar('CCPF_FACTS_FILES'),
	CCPF_FACTS_DEST_PATH : std.extVar('CCPF_FACTS_DEST_PATH'),
	CCPF_LOG_LEVEL : std.extVar('CCPF_LOG_LEVEL'),	
	GENERATED_ON : std.extVar('GENERATED_ON'),

	jsonnet : {
		command: std.extVar('CCPF_JSONNET'),
		path: std.extVar('JSONNET_PATH')
	},

	jq : {
		command: std.extVar('CCPF_JQ'),
	},

	CCPF_Makefile : {
		customPreConfigureScriptName : std.extVar('CCPF_MakeFileCustomPreConfigureScriptName'),
		customPostConfigureScriptName : std.extVar('CCPF_MakeFileCustomPostConfigureScriptName'),
		customTargetsIncludeFile : std.extVar('CCPF_MakeFileCustomTargetsIncludeFile'),
	},

	projectName : std.extVar('projectName'),
	projectHome : std.extVar('projectHome'),

	vendor : {
		path : std.extVar('projectHome') + "/vendor",
		javaHome : $.vendor.path + "/java/jdk-11.0.2",
		goHome : $.vendor.path + "/gohome",
		goPath : $.vendor.path + "/gopath",
		mageCmd : $.vendor.goPath + "/bin/mage",
	},

	currentUser : {
		name : std.extVar('currentUserName'),
		id : std.extVar('currentUserId'),
		groupId : std.extVar('currentUserGroupId'),
		home : std.extVar('currentUserHome')
	},
}
