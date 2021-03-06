function Get-User {
    [cmdletbinding(SupportsShouldProcess, ConfirmImpact = 'low')]
    param(
        [parameter(Position = 0, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [alias('URL')]
        [string]$OctopusBaseURL
    )

    begin { }
    process {
        try {
            $octopusAPIKey = Read-Host 'Input API Key' -AsSecureString
            $headers = @{ "X-Octopus-ApiKey" = $octopusAPIKey }

            $header = @{ "X-Octopus-ApiKey" = $octopusAPIKey | ConvertFrom-SecureString -AsPlainText }

            $listSpaces = $(Invoke-WebRequest -Method GET -Uri $OctopusBaseURL/users -Headers $header).content
            $convert = $listSpaces | ConvertFrom-Json
        }

        catch {
            Write-Warning 'An error has occurred. Please confirm your API key and Octopus Base URL is correct'
            $PSCmdlet.ThrowTerminatingError($_)
        }

        try {
            $obj = [pscustomobject] @{
                'ID' = $convert.Items.id
                'Username'  = $convert.Items.Username
            }

            $obj | fl
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
    end { }
}
