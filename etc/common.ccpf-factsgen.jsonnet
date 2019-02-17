{
  osQueries: {
    singleRow : [
      { name: "system-localhost", query: "select * from system_info" },
      { name: "eth0-interface-localhost", query: "select * from interface_addresses where interface = 'eth0'" }
    ],
    multipleRows : [
      { name: "interfaces-localhost", query: "select * from interface_addresses" }
    ],
  },

  shellEvals: 
  [
    // TIP: Check out http://www.bashoneliners.com/ for many useful Bash one-liners

    // Define the CCPF-specific commands and utilities available
    // { name: "hugo", key: "command", evalAsTextValue: "ls -1 $CCPF_HOME/bin/hugo-*" },
    // { name: "plantUML", key: "command", evalAsTextValue: "ls -1 $CCPF_HOME/bin/plantuml*" },

    // The dockerHostIPAddress value is useful when the project needs to know its externally-facing IP address.
    // Use it like this:
    //     local dockerFacts = import "docker-localhost.ccpf-facts.json";
    //     static_configs: [ { targets: [dockerFacts.dockerHostIPAddress + ":9100"] } ]
    //{ name: "docker-localhost", key: "dockerHostIPAddress", evalAsTextValue: "/sbin/ip -4 -o addr show dev eth0| awk '{split(\\$4,a,\\\"/\\\");print a[1]}'" },

    // The dockerBridgeNetworkGatewayIPAddress value is useful for docker-compose.yml extra_hosts (e.g. --add-host) 
    // when one project needs to reference another project on the same docker host. Use it like this:
    //     local dockerFacts = import "docker-localhost.ccpf-facts.json";
    //     extra_hosts: ["other_migration" + ':' + dockerFacts.dockerBridgeNetworkGatewayIPAddress],
    //{ name: "docker-localhost", key: "dockerBridgeNetworkGatewayIPAddress", evalAsTextValue: "docker network inspect --format='{{range .IPAM.Config}}{{.Gateway}}{{end}}' bridge" },
  ],
}