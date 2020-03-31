
<!---
	If you leave these settings commented out, Wheels will set the data source name to the same name as the folder the application resides in.
	<cfset set(dataSourceName="")>
	<cfset set(dataSourceUserName="")>
	<cfset set(dataSourcePassword="")>
--->
<cfscript>
	set(dataSourceName="myblog");
</cfscript>
<!--- <cfset set(urlRewriting="On")> --->
<cfset set(setUpdatedAtOnCreate=false)>
<!---
	If you leave this setting commented out, Wheels will try to determine the URL rewrite capabilities automatically.
	The URLRewriting setting can bet set to "On", "Partial" or "Off".
	To run with "Partial" rewriting, the "PATH_INFO" variable needs to be supported by the web server.
	To run with rewriting "On", you need to apply the necessary rewrite rules on the web server first.
	<cfset set(URLRewriting="Partial")>
--->

<cfset
    set(
        functionName="textField", prependToLabel="<div>", append="</div>",
        labelPlacement="before"
    )
>
<cfset
    set(
        functionName="select", prependToLabel="<div>", append="</div>",
        labelPlacement="before"
    )
>


<!--- Populate the admin email structure --->
<cfquery datasource="#get("DATASOURCENAME")#" name="qAdminEmails">
	SELECT `type`, cast(group_concat(email) AS char) AS emails
	FROM adminemails
	WHERE deletedAt IS NULL
	GROUP BY `type`
</cfquery>

<cfset Application.AdminEmails = {}>
<cfset Application.AdminEmails.comments = "">
<cfset Application.AdminEmails.errors = "">

<cfloop query="qAdminEmails">
	<cfset Application.AdminEmails[qAdminEmails.type] = qAdminEmails.emails>
</cfloop>


<cfif ListLen(Application.AdminEmails.errors) EQ 0>
	<p>Please populate the adminemails table with email address(es) you want errors emailed to.</p>
	<cfabort>
</cfif>

<cfif ListLen(Application.AdminEmails.comments) EQ 0>
	<p>Please populate the adminemails table with email address(es) you want comments emailed to/from.</p>
	<cfabort>
</cfif>

<cfset set(sendEmailOnError=true)>
<cfset set(errorEmailAddress=Application.AdminEmails.errors)>
<cfset set(errorEmailSubject="Adventures Of Carlos Blog Error")>
<!--- <cfset set(errorEmailServer="localhost")> --->
<!--- <cfset set(showErrorInformation=false)> --->


<!--- Populae the captcha security structure --->
<cfquery datasource="#get("DATASOURCENAME")#" name="qReCaptcha">
	SELECT publicKey, privateKey
	FROM adminrecaptcha
	WHERE deletedAt IS NULL
</cfquery>

<cfset Application.reCaptcha = {}>
<cfset Application.reCaptcha.publicKey = qReCaptcha.publicKey>
<cfset Application.reCaptcha.privateKey = qReCaptcha.privateKey>



<cfif cgi.server_name EQ "dev.cf.carlosvazquez.org">
	<cfset Server.thisServer = "dev">
	<cfset set(reloadPassword="")>

<cfelse>
	<cfset Server.thisServer = "">

	<!--- Set the reload password --->
	<cfquery datasource="#get("DATASOURCENAME")#" name="qReCaptcha">
		SELECT `password`
		FROM adminreloads
		WHERE deletedAt IS NULL
	</cfquery>
	<cfset set(reloadPassword="#qReCaptcha.password#")>
</cfif>


<!--- Set application settings --->
<cfquery datasource="#get("DATASOURCENAME")#" name="qSettings">
	SELECT `name`, `value`
	FROM adminsettings
	WHERE deletedAt IS NULL
</cfquery>

<cfset Application.settings = {}>
<cfloop query="qSettings">
	<cfset "Application.settings.#qSettings.name#" = qSettings.value>
</cfloop>


<cfif server.thisServer EQ "dev">
	<cfset set(environment="design")>
<cfelse>
	<cfset set(environment="production")>
	<cfset set(showDebugInformation=false)>
</cfif>

<cfparam default="" name="client.httpRefererExternal">
