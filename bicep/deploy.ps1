Connect-AzAccount

Set-AzContext -Subscription rivm-az-cpt-jbonsel-sandbox

# curl whatismyip.com
Invoke-RestMethod https://api.ipify.org
$PublicIPLearner = Invoke-RestMethod https://api.ipify.org


$PlainPassword = Read-Host
$SecurePassword = ConvertTo-SecureString $PlainPassword -AsPlainText -Force

New-AzDeployment -TemplateFile "C:\jbo\k8slearn\bicep\main.bicep" -TemplateParameterFile "C:\jbo\k8slearn\bicep\main.bicepparam" -vmadminpassword $SecurePassword -PublicIPLearner $PublicIPLearner -location northeurope



C:\jbo\k8slearn\bicep\main.bicep
