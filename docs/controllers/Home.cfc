<cfcomponent output="false" extends="Controller">

<cffunction name="index">

	<!--- Handle detection of URLs from previous website version and 301 redirect to this version --->

	<!--- 	301 Blog Entries
			http://www.carlosvazquez.org/index.cfm?a=comment&blog_id=99
	--->
	<cfif isdefined("params.blog_id") AND isnumeric(params.blog_id)>
		<cfset qURL = model("entryurl").findOneByEntryIdAndIsActive(	select		= "titleURL",
																		value = "#params.blog_id#,1")>

		<cfif isObject(qURL)>
			<cflocation addtoken="no" url="/blog/#qURL.titleURL#" statuscode="301">
		</cfif>
	</cfif>

	<!---	301 Categories
			http://www.carlosvazquez.org/index.cfm?a=category&category_id=8
	--->
	<cfif isdefined("params.category_id") AND isnumeric(params.category_id)>
		<cfset qURL = model("categoryurl").findOneByCategoryIdAndIsActive(	select	= "name",
																			value	= "#params.category_id#,1")>

		<cfif isObject(qURL)>
			<cflocation addtoken="no" url="/blog/category/#qURL.name#" statuscode="301">
		</cfif>
	</cfif>


	<cfheader statuscode="301" statustext="Moved permanently">
	<cfheader name="Location" value="/blog">
</cffunction>

<cffunction name="notfound">
	<cfset title = "Not Found">
</cffunction>

</cfcomponent>