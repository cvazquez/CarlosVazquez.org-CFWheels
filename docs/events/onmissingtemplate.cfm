<cfif isdefined("url.blog_id") AND isnumeric(url.blog_id)>
	<!--- 	Catch previous version url
			http://railo.carlosvazquez.org/blog/index.cfm?blog_id=65 to http://railo.carlosvazquez.org/index.cfm?blog_id=65
	--->

	 <cfquery datasource="#get("DATASOURCENAME")#" name="qURL">
		SELECT titleURL
		FROM entryurls
		WHERE entryId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.blog_id#"> AND isActive = 1 AND deletedAt IS NULL
	</cfquery>

	<cfif qURL.recordCount GT 0>
		<cflocation addtoken="no" url="/blog/#qURL.titleURL#" statuscode="301">
	</cfif>
</cfif>


<cfif isdefined("url.category_id") AND isnumeric(url.category_id)>

	<cfquery datasource="#get("DATASOURCENAME")#" name="qURL">
		SELECT name
		FROM categoryurls
		WHERE categoryId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.category_id#"> AND isActive = 1 AND deletedAt IS NULL
	</cfquery>

	<cfif qURL.recordCount GT 0>
		<cflocation addtoken="no" url="/blog/category/#qURL.name#" statuscode="301">
	</cfif>
</cfif>

<cfif cgi.script_name EQ "/blog/index.cfm">
	<cflocation addtoken="no" url="/blog" statuscode="301">
</cfif>


<cfheader statuscode="404" statustext="Not Found">
<!--- Place HTML here that should be displayed when a file is not found while running in "production" mode. --->
<h1>File Not Found!</h1>
<p>
	Sorry, the page you requested could not be found.<br />
	Please verify the address.
</p>


<p><a href="/blog">Return to website</a></p>