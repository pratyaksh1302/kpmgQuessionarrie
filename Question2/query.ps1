#Access to Get the Azure resources Login details"

$TenantId = "" # Enter Tenant Id.
$ClientId = "" # Enter Client Id.
$ClientSecret = "" # Enter Client Secret.
$Resource = "https://management.core.windows.net/"
$SubscriptionId = "" # Enter Subscription Id.
$resourceGroupName = "KPMGRG"
$VMName = "KPMGClientVM"

#Request URL to generate a bearer token to start managing azure resources

$RequestAccessTokenUri = "https://login.microsoftonline.com/$TenantId/oauth2/token"
$body = "grant_type=client_credentials&client_id=$ClientId&client_secret=$ClientSecret&resource=$Resource"
$Token = Invoke-RestMethod -Method Post -Uri $RequestAccessTokenUri -Body $body -ContentType 'application/x-www-form-urlencoded'

Write-Host "Print Token" -ForegroundColor Green
Write-Output $Token

# Get VirtualMachine
$VMAPIUri = "https://management.azure.com/subscriptions/$SubscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Compute/virtualMachines/$VMName ?api-version=2020-06-01"

$Headers = @{}
$Headers.Add("Authorization","$($Token.token_type) "+ " " + "$($Token.access_token)")

#Creating file to store the json and extract information

#Creating file to store the json and extract information
if(Test-Path $Path) {
    Write-Host "PathExist"
}
else {
    Write-Host "Path Doesnot Exist Creating"
    New-Item -Path C:\KPMG -Name VM.json
}
    $VM = Invoke-RestMethod -Method Get -Uri $VMAPIUri -Headers $Headers | ConvertTo-Json     #Converting output into a Json
    $VMInfo = $VM | Out-File C:\KPMG\VM.json # Saving it to a Json file
    #Query to fetech VM size
    $VMconf = (Get-Content C:\KPMG\VM.json | ConvertFrom-Json)
    Write-Host $VMconf.properties.hardwareProfile.vmSize -ForegroundColor Green
    #Query to fetch computeName
    Write-Host $VMconf.properties.osProfile.computerName -ForegroundColor Green


