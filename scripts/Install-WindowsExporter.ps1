function Install-PrometheusExporter {
    param (
        # Name of the Windows Exporter service
        $Name = 'Prometheus - Windows Exporter',

        # Port to expose the metrics endpoint on
        [ValidateRange(1, 65535)]
        $Port = 9182,


        # Name of the firewall group to add the rule to
        $FirewallGroup = 'Monitoring'
    )

    # Add firewall rule for the metrics endpoint
    $FirewallParams = @{
        Name = "$Name"
        DisplayName = "$Name"
        Description = "Allows access to $Name metrics endpoint"
        Group = "$FirewallGroup"
        Profile = 'Any'
        Direction = 'Inbound'
        Action = 'Allow'
        Protocol = 'TCP'
        LocalPort = "$Port"
    }

    New-NetFirewallRule @FirewallParams
}
