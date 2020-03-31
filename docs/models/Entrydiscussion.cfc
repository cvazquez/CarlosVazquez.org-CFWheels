<!---
	This is the parent model file that all your models should extend.
	You can add functions to this file to make them globally available in all your models.
	Do not delete this file.
--->
<cfcomponent extends="Model">

	<cffunction name="config">
		<cfset hasOne("user")>
		<cfset belongsTo("entry")>

		<cfset set(dataSourceName="mybloginsert")>
	</cffunction>


	<cffunction name="GetEntryDiscussions" access="public" returntype="query">
		<cfargument name="entryId" required="true" type="numeric">

		<cfset var qDiscussions = "">

		<cfquery datasource="#get("DATASOURCENAME")#" name="qDiscussions">
			SELECT 	entrydiscussions.id, entrydiscussions.content, Date_Format(entrydiscussions.createdAt, '%b %e, %Y') AS postDate,
					Time_Format(entrydiscussions.createdAt, '%l:%i %p') AS postTime,
					entrydiscussions.firstName, entrydiscussions.lastName,
					<!--- users.firstName, --->
					IF(ed2.id IS NOT NULL, 1, 0) AS hasReplies,
					(	SELECT count(*)
						FROM entrydiscussions userComments
						WHERE userComments.email = entrydiscussions.email AND userComments.deletedAt IS NULL
												AND (userComments.approvedAt IS NOT NULL OR (dateDiff(now(), userComments.createdAt) <= 1) ) )
					AS userCommentCount
			FROM entrydiscussions
			LEFT OUTER JOIN users ON users.id = entrydiscussions.userId AND users.deletedAt IS NULL
			LEFT JOIN entrydiscussions ed2 ON ed2.entryDiscussionId = entrydiscussions.id AND ed2.deletedAt IS NULL
			WHERE entrydiscussions.entryId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.entryId#">
				AND entrydiscussions.entryDiscussionId IS NULL
				AND entrydiscussions.deletedAt IS NULL
				AND (entrydiscussions.approvedAt IS NOT NULL OR (dateDiff(now(), entrydiscussions.createdAt) <= 1) )
			GROUP BY entrydiscussions.id
			ORDER BY entrydiscussions.id desc
		</cfquery>

		<cfreturn qDiscussions>

		<!---
			<cfset qBlogDiscussions = model("user").findAll(	select	= "	entrydiscussions.id, entrydiscussions.content, Date_Format(entrydiscussions.createdAt, '%b %e, %Y') AS postDate,
																					Time_Format(entrydiscussions.createdAt, '%l:%i %p') AS postTime,
																					users.firstName",
																		include	= "entrydiscussions",
																		where	= "entrydiscussions.entryId = #qBlogEntry.id# AND entrydiscussions.entryDiscussionId IS NULL",
																		order	= "entrydiscussions.id desc")>
		--->
	</cffunction>


	<cffunction name="GetDiscussionReplies" access="public" returntype="query">
		<cfargument name="entryDiscussionId" required="true" type="numeric">

		<cfset var qDiscussionReplies = "">

		<cfquery datasource="#get("DATASOURCENAME")#" name="qDiscussionReplies">
		SELECT 	entrydiscussions.id, entrydiscussions.content, Date_Format(entrydiscussions.createdAt, '%b %e, %Y') AS postDate,
					Time_Format(entrydiscussions.createdAt, '%l:%i %p') AS postTime,
					users.firstName
			FROM entrydiscussions
			LEFT OUTER JOIN users ON users.id = entrydiscussions.userId AND users.deletedAt IS NULL
			WHERE entrydiscussions.entryDiscussionId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.entryDiscussionId#">
				AND ( entrydiscussions.approvedAt IS NOT NULL OR (dateDiff(now(), entrydiscussions.createdAt) <= 1) )
				AND entrydiscussions.deletedAt IS NULL
			ORDER BY entrydiscussions.id
		</cfquery>

		<cfreturn qDiscussionReplies>
	</cffunction>


	<cffunction name="GetLatest" access="public" returntype="query">

		<cfset var qLatest = "">

		<cfquery datasource="#get("DATASOURCENAME")#" name="qLatest">
			SELECT 	users.firstName, CutText(entrydiscussions.content, 100, '...') AS commentTeaser,
					entrydiscussions.id AS entrydiscussionid, Date_Format(entrydiscussions.createdAt, '%b %e, %Y') AS commentDate,
					entryurls.titleURL,
					(	SELECT count(*)
						FROM entrydiscussions ed2
						WHERE ed2.entryDiscussionId = entrydiscussions.id AND (ed2.approvedAt IS NOT NULL OR (dateDiff(now(), ed2.createdAt) <= 1))
									AND ed2.deletedAt IS NULL
					) AS replyCount
			FROM users
			INNER JOIN entrydiscussions ON users.id = entrydiscussions.userId
									AND (entrydiscussions.approvedAt IS NOT NULL OR (dateDiff(now(), entrydiscussions.createdAt) <= 1))
									AND entrydiscussions.deletedAt IS NULL
									AND entrydiscussions.entryId <> 168 <!--- Comments form --->
			INNER JOIN entries ON entrydiscussions.entryId = entries.id AND entries.deletedAt IS NULL AND entries.publishAt <= now()
			INNER JOIN entryurls ON entries.id = entryurls.entryId AND entryurls.deletedAt IS NULL
			WHERE users.deletedAt IS NULL
			GROUP BY entrydiscussions.id
			ORDER BY entrydiscussions.id desc
			LIMIT 5
		</cfquery>

		<cfreturn qLatest>

		<!--- <cfset qLatestDiscussions = model("user").findAll(	select	= "	users.firstName, CutText(entrydiscussions.content, 100, '...') AS commentTeaser,
																	entrydiscussions.id AS entrydiscussionid, Date_Format(entrydiscussions.createdAt, '%b %e, %Y') AS commentDate,
																	0 AS replyCount, entryurls.titleURL,
																	dateDiff(now(), entrydiscussions.createdAt) AS daysSinceLive
																	",
														include = "entrydiscussions(entry(entryurls))",
														where	= "(entrydiscussions.approvedAt IS NOT NULL)",
														group	= "entrydiscussions.id",
														order	= "entrydiscussions.id desc",
														$limit	= 5)> --->
	</cffunction>


	<cffunction name="GetUsers" access="public" returntype="query">
		<cfargument name="entryDiscussionId" required="true" type="numeric">

		<cfset var qUsers = "">

		<cfquery datasource="#get("DATASOURCENAME")#" name="qUsers">
			SELECT users.email, users.firstName, users.lastName, e.title, entryurls.titleURL
			FROM entrydiscussions ed1
			INNER JOIN entries e ON e.id = ed1.entryId AND e.deletedAt IS NULL AND entries.publishAt <= now()
			INNER JOIN entryurls ON entryurls.entryId = e.id AND entryurls.isActive = 1 AND entryurls.deletedAt IS NULL
			INNER JOIN entrydiscussions ed2 ON ed2.entryId = ed1.entryId AND ed2.id <> ed1.id AND ed2.wantsReplies = 1 AND ed2.approvedAt IS NOT NULL AND ed2.deletedAt IS NULL
			INNER JOIN users ON users.id = ed2.userId AND users.deletedAt IS NULL
			WHERE ed1.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.entryDiscussionId#"> AND ed1.approvedAt IS NOT NULL AND ed1.deletedAt IS NULL
		</cfquery>

		<cfreturn qUsers>
	</cffunction>
</cfcomponent>