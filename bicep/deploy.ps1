Connect-AzAccount

Set-AzContext -Subscription xxxx

# curl whatismyip.com #werkt niet meer....
# dit werkt wel:
Invoke-RestMethod https://api.ipify.org
$PublicIPLearner = Invoke-RestMethod https://api.ipify.org

#publicip wordt gebruikt in d ensg om alleen daarvan ssh toe te laten

$PlainPassword = Read-Host
$SecurePassword = ConvertTo-SecureString $PlainPassword -AsPlainText -Force

#change location of bicep and bicepparam:
New-AzDeployment -TemplateFile "C:\jbo\k8slearn\bicep\main.bicep" -TemplateParameterFile "C:\jbo\k8slearn\bicep\main.bicepparam" -vmadminpassword $SecurePassword -PublicIPLearner $PublicIPLearner -location northeurope

