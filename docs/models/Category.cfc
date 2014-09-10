<cfcomponent extends="Model">

	<cffunction name="init">
		<cfset hasMany("entrycategories")>
		<cfset hasOne("categoryurl")>
	</cffunction>
</cfcomponent>