<!---
	This is the parent model file that all your models should extend.
	You can add functions to this file to make them globally available in all your models.
	Do not delete this file.
--->
<cfcomponent extends="Model">

	<cffunction name="config">
		<cfset set(dataSourceName="mybloginsert")>
		<cfset table("users")>

		<cfset validatesPresenceOf(properties="firstName,lastName,email")>
		<cfset validatesLengthOf(properties="firstName,lastName", maximum=50)>
		<cfset validatesLengthOf(properties="email", maximum=255)>

		<cfset validate(method="validateEmailFormat")>
        <cfset validatesUniquenessOf(property="email")>


		<cfset automaticValidations(false)>
	</cffunction>


	<cffunction name="validateEmailFormat" access="private">
	    <cfif not IsValid("email", this.email)>
	        <cfset addError(property="email", message="Email address is not in a valid format.")>
	    </cfif>
	</cffunction>

</cfcomponent>