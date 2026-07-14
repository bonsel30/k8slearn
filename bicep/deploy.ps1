Connect-AzAccount

Set-AzContext -Subscription rivm-az-cpt-jbonsel-sandbox

curl whatismyip.com

$PlainPassword = Read-Host
$SecurePassword = ConvertTo-SecureString $PlainPassword -AsPlainText -Force

New-AzDeployment -TemplateFile "C:\github\k8s\k8slearn\bicep\main.bicep" -TemplateParameterFile "C:\github\k8s\k8slearn\bicep\main.bicepparam" -vmadminpassword $SecurePassword -PublicIPLearner "82.169.80.254" -location northeurope



C:\github\k8s\k8slearn\bicep\main.bicep
