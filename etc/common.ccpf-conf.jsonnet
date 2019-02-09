local systemFacts = import "system-localhost.ccpf-facts.json";

{
  domainName: 'appliance.local',
  defaultDockerNetworkName : 'appliance',
  
  applianceName: systemFacts.hostname,
  applianceHostName: $.applianceName,
  applianceFQDN: $.applianceHostName + '.' + $.domainName,
}