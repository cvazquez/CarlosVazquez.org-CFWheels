<!--- Place functions here that should be globally available in your application. --->

<cffunction name="EmailError">
	<cfargument name="thisCATCH" required="false" default="">

	<cfmail from	= "#Application.AdminEmails.errors#"
			to		= "#Application.AdminEmails.errors#"
			bcc 	= "#Application.AdminEmails.admin#"
			subject	= "CarlosVazquez.org - Website Error: #cgi.path_info#"
			type	= "HTML">

		<cfif isStruct(arguments.thisCATCH)>
			<cfdump var="#arguments.thisCATCH#" label="CFCATCH">
		</cfif>

		<cfdump var="#CGI#" label="CGI">

	</cfmail>

</cffunction>