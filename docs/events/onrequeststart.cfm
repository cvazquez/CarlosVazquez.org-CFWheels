<!--- Place code here that should be executed on the "onRequestStart" event. --->
<cfparam default="" name="client.httpRefererExternal">
<cfif NOT ReFindNoCase("^https?://#cgi.server_name#", cgi.http_referer)>
	<cfset client.httpRefererExternal = cgi.http_referer>
</cfif>