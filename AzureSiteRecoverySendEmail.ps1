<# 
	.DESCRIPTION 
		The script is used to send an email from within an Azure Site Recovery plan.
		The script is tested with the service SendGrid. To use SendGrid, create an 
		account in Azure and save the username and password.
		
		Import the script and create an an Azure Automation Credential with the 
		name SendEmailCred and add the username and password to be used when sending
		emails.

		Edit the variables:
		$EmailFrom
		$EmailTo
		
		The script is provided “AS-IS” with no warranties and I don’t take any 
		responsibility of errors that can occur.
		
		For more information see systemcenterme.com
			
		Version 2018.03.18.2
 
	.NOTES 
		AUTHOR: Jonathan Andersson
#> 

param (
		[Object]$RecoveryPlanContext 
)

# Get information from the ASR plan
$RecoveryPlanName = $RecoveryPlanContext.RecoveryPlanName
$FailoverType = $RecoveryPlanContext.FailoverType
$GroupId = $RecoveryPlanContext.GroupId

# Get credential from the Azure Automation account
$credential = Get-AutomationPSCredential -Name 'SendEmailCred'

# Prepare the email
# Edit this section to fit your needs
$SMTPServer = "smtp.sendgrid.net"
$EmailFrom = "EmailFrom@mysite.com"
$EmailTo = "EmailTo@mysite.com"
$Subject = "Azure Site Recovery Failover Plan $RecoveryPlanName"
$Body = @"
ASR failover in progress

Recovery plan name: $RecoveryPlanName

Group Id: $GroupId

Failover type: $FailoverType

"@

# Send email
Send-MailMessage -smtpServer $SMTPServer -Credential $credential -Usessl -Port 587 -from $EmailFrom -to $EmailTo -subject $Subject -Body $Body
