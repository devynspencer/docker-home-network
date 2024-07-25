function Install-PrometheusExporter {
    param (
        # Name of the Windows Exporter service
        $Name = 'Prometheus - Windows Exporter',

        # Port to expose the metrics endpoint on
        [ValidateRange(1, 65535)]
        $Port = 9182,


        # URL to download the latest version of Windows Exporter
        $ExporterUrl = 'https://github.com/prometheus-community/windows_exporter/releases/download/v0.17.0/windows_exporter-0.17.0-386.msi',

        # Name of the firewall group to add the rule to
        $FirewallGroup = 'Monitoring'
    )

    # Download latest version of Windows Exporter from GitHub
    $DownloadPath = "$env:TEMP\windows_exporter.msi"

    Invoke-WebRequest -Uri $ExporterUrl -OutFile $DownloadPath

    # Install Windows Exporter
    $InstallParams = @{
        FilePath = 'msiexec.exe'
        ArgumentList = '/i', "$DownloadPath", '/quiet'
        Wait = $true
        NoNewWindow = $true
    }

    Start-Process @InstallParams


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
