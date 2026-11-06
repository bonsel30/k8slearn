Connect-AzAccount

# curl whatismyip.com #werkt niet meer....
# dit werkt wel:
# Invoke-RestMethod https://api.ipify.org
$PublicIPLearner = Invoke-RestMethod https://api.ipify.org

#publicip wordt gebruikt in de nsg om ssh open te zetten naar control-node

$PlainPassword = Read-Host
$SecurePassword = ConvertTo-SecureString $PlainPassword -AsPlainText -Force

#change location of bicep and bicepparam:
New-AzDeployment -TemplateFile "C:\jbo\k8slearn\bicep\main.bicep" -TemplateParameterFile "C:\jbo\k8slearn\bicep\main.bicepparam" -vmadminpassword $SecurePassword -PublicIPLearner $PublicIPLearner -location northeurope

