<!---
	This is the parent model file that all your models should extend.
	You can add functions to this file to make them globally available in all your models.
	Do not delete this file.
--->
<cfcomponent extends="Model">

	<cffunction name="init">
		<cfset belongsTo("flickrSetPhoto")>
	</cffunction>

</cfcomponent>