<!---
	This is the parent model file that all your models should extend.
	You can add functions to this file to make them globally available in all your models.
	Do not delete this file.
--->
<cfcomponent extends="Model">

	<cffunction name="config">
		<cfset set(dataSourceName="mybloginsert")>
		<cfset table("entrydiscussions")>

		<!--- <cfset hasMany("users")>
		<cfset belongsTo("entry")> --->

		<!--- <cfset validatesPresenceOf(properties="userId,content")> --->

		<cfset validatesPresenceOf(properties="firstName,lastName,email,content")>
		<cfset validatesLengthOf(properties="firstName,lastName", minimum=1, maximum=50)>
		<cfset validatesLengthOf(properties="email", minimum=5, maximum=255)>
		<cfset validatesLengthOf(properties="content", minimum=5, maximum=65536)>
		<cfset validate(method="validateEmailFormat")>

		<cfset validate( method="validateCaptcha" )>

		<cfset automaticValidations(false)>


	</cffunction>


	<cffunction name="validateEmailFormat" access="private">
	    <cfif not IsValid("email", this.email)>
	        <cfset addError(property="email", message="Email address is not in a valid format.")>
	    </cfif>
	</cffunction>


	<cffunction name="validateCaptcha" access="private">
		<cfif NOT this.validCaptcha>
	        <cfset addError(property="recaptcha_response_field", message="Captcha is incorrect.")>
	    </cfif>
	</cffunction>


	<cffunction name="validateComment" access="public" returntype="Struct" hint="Email user a validation link">
		<cfargument name="emailValidationString" required="true" type="string">

		<cfset var LocalValidateComment = {}>
		<cfset LocalValidateComment.validated = FALSE>
		<cfset LocalValidateComment.error = FALSE>

		<cftransaction>
			<cftry>
				<!--- If the validation string matches, then approved the comment ---->
				<cfquery datasource="mybloginsert">
					UPDATE entrydiscussions
					SET approvedAt = now(),
						rejectedAt = NULL
					WHERE emailValidationString = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailValidationString#"> AND approvedAt IS NULL;
				</cfquery>

				<!--- Check if the validaion string actually matched and approved --->
				<cfquery datasource="#get("DATASOURCENAME")#" name="qEntryDiscussion">
					SELECT eu.titleURL, ed.id
					FROM entrydiscussions ed
					INNER JOIN entries e ON e.id = ed.entryId AND e.deletedAt IS NULL
					INNER JOIN entryurls eu ON eu.entryId = e.id AND eu.isActive = 1 AND eu.deletedAt IS NULL
					WHERE ed.emailValidationString = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailValidationString#"> AND approvedAt IS NOT NULL AND ed.deletedAt IS NULL
				</cfquery>

				<cfif qEntryDiscussion.recordCount GT 0>
					<!--- 	The comment was validated. Check if an existing user is associated with the comments email address.
							Insert this user into users table and associate the discussion record with the user id --->
					<cfquery datasource="#get("DATASOURCENAME")#" name="qCheckUserExists">
						SELECT u.id AS userId
						FROM entrydiscussions ed
						INNER JOIN users u ON u.email = ed.email
						WHERE ed.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#qEntryDiscussion.id#"> AND ed.deletedAt IS NULL
					</cfquery>

					<cfif qCheckUserExists.recordCOunt GT 0>
						<!--- A user is associated with the discussions email address. Update the discussion with the emails user id --->
						<cfquery datasource="#get("DATASOURCENAME")#" name="UpdateDiscussionUser">
							UPDATE entrydiscussions
							SET userId = <cfqueryparam cfsqltype="cf_sql_integer" value="#qCheckUserExists.userId#">,
								updatedAt = now(),
								updatedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#qCheckUserExists.userId#">,
								deletedAt = NULL
							WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#qEntryDiscussion.id#">
						</cfquery>
					<cfelse>
						<!--- A user is NOT associationed. Create the user --->
						<cfquery datasource="#get("DATASOURCENAME")#" name="InsertNewDiscussionUser">
							INSERT INTO users (firstName, lastName, email, cfId, httpRefererInternal, httpUserAgent, ipAddress, pathInfo, createdAt)
							SELECT 	ed.firstName, ed.lastName, ed.email,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#client.cfid#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.HTTP_REFERER#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.http_user_agent#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.path_info#">,
									 now()
							FROM entrydiscussions ed
							WHERE ed.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#qEntryDiscussion.id#">
						</cfquery>


						<!--- Associate the discussion with the new user's id --->
						<cfquery datasource="#get("DATASOURCENAME")#" name="UpdateDiscussionUserId">
							UPDATE entrydiscussions
							SET userId = last_insert_id(),
								updatedAt = now(),
								updatedBy = last_insert_id()
							WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#qEntryDiscussion.id#">
						</cfquery>
					</cfif>

					<!--- The validation is successfully, so return the success ---->
					<cfset LocalValidateComment.validated = TRUE>
					<cfset LocalValidateComment.entryDiscussionId = qEntryDiscussion.id>
					<cfset LocalValidateComment.titleURL = qEntryDiscussion.titleURL>
				</cfif>


				<cfcatch type="ANY">
					<cftransaction action = "rollback"/>

					<cfset EmailError(thisCATCH	= CFCATCH)>

					<cfset LocalValidateComment.error = TRUE>
				</cfcatch>
			</cftry>
		</cftransaction>

		<cfreturn LocalValidateComment>

	</cffunction>
</cfcomponent>