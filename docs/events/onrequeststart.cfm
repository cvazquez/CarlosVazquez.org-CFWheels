<cfscript>
	// Place code here that should be executed on the "onRequestStart" event.
	param default="" name="client.httpRefererExternal";
	if(NOT ReFindNoCase("^https?://#cgi.server_name#", cgi.http_referer)) {
		client.httpRefererExternal = cgi.http_referer;
	}
</cfscript>