<!---
	This is the parent model file that all your models should extend.
	You can add functions to this file to make them globally available in all your models.
	Do not delete this file.
--->
<cfcomponent extends="Model">

	<cffunction name="init">
		<cfset set(dataSourceName="mybloginsert")>
		<cfset table("logvisits")>
	</cffunction>


	<cffunction name="Save" access="public">
		<cfargument name="params" required="false" type="struct">

		<cfset var loopCount = 0>

		<cfparam default="" name="client.userId">

		<!--- <cfset fake = fake2> --->

		<cftransaction>
	    <cfquery datasource="#get("DATASOURCENAME")#">
			INSERT INTO logvisits (cfId, httpRefererExternal, httpRefererInternal, httpUserAgent, ipAddress, pathInfo, createdAt, createdBy)
			VALUES (<cfqueryparam cfsqltype="cf_sql_varchar" value="#client.cfId#">,
					<cfif NOT ReFindNoCase("^https?://#cgi.server_name#", cgi.http_referer)>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.http_referer#">
					<cfelse>
						""
					</cfif>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.http_referer#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.http_user_agent#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.path_info#">,
					now(),
					<cfif val(client.userId) GT 0 AND isnumeric(client.userId)>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#client.userId#">
					<cfelse>
						NULL
					</cfif>
					)
		</cfquery>

		<cfif StructCount(arguments.params)>

			<!--- <cfdump var="#arguments.params#">
			<cfabort> --->
			 <cfquery datasource="#get("DATASOURCENAME")#" name="qLogVisit">
				SELECT last_insert_id() AS id
			</cfquery>

			 <cfquery datasource="#get("DATASOURCENAME")#">
				INSERT INTO logvisitdata (logVisitId, name, value, createdAt, createdBy)
				VALUES
					<cfloop collection="#arguments.params#" item="cP">
						<cfset loopCount = loopCount + 1>
						(	#qLogVisit.id#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#cP#">,
							<cfif IsSimpleValue(arguments.params[cP])>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.params[cP]#">,
							<cfelse>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Serialize(arguments.params[cP])#">,
							</cfif>
							now(),
							<cfif val(client.userId) GT 0 AND isnumeric(client.userId)>
								<cfqueryparam cfsqltype="cf_sql_integer" value="#client.userId#">
							<cfelse>
								NULL
							</cfif>
						)
						<cfif loopCount LT StructCount(arguments.params)>,</cfif>

					</cfloop>
			</cfquery>

		</cfif>
		</cftransaction>

	</cffunction>


</cfcomponent>