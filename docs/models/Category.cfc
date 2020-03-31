<cfcomponent extends="Model">
	<cffunction name="config">
		<cfset hasMany("entrycategories")>
		<cfset hasOne("categoryurl")>
	</cffunction>
</cfcomponent>