<!---
	This is the parent model file that all your models should extend.
	You can add functions to this file to make them globally available in all your models.
	Do not delete this file.
--->
<cfcomponent extends="Model">

	<cffunction name="config">
		<cfset hasMany("entrydiscussions")>
		<cfset hasOne("entryurls")>
		<cfset hasMany("entrycategories")>
	</cffunction>

	<cffunction name="GetBlogEntry" returntype="query" access="public">
		<cfargument name="titleURL">

		<cfset var qBlogEntry = "">


		<cfquery datasource="#get("DATASOURCENAME")#" name="qBlogEntry">
			SELECT 	entries.id, entries.title, entries.content, entries.metaDescription, entries.metaKeyWords, entries.publishAt,
					entrydiscussions.id AS entryDiscussionsId, count(distinct(entrydiscussions.id)) AS discussionCount,
					entryurls.titleURL, categories.name AS categoryName, categoryurls.name AS categoryURL
			FROM entryurls
			INNER JOIN entries ON entries.id = entryurls.entryId AND entries.deletedAt IS NULL AND entries.publishAt <= now()
			LEFT OUTER JOIN entrydiscussions ON entries.id = entrydiscussions.entryId
								AND ( entrydiscussions.approvedAt IS NOT NULL OR (dateDiff(now(), entrydiscussions.createdAt) <= 1) )
								AND entrydiscussions.deletedAt IS NULL
			LEFT JOIN entrycategories ec ON ec.entryId = entryurls.entryId AND ec.deletedAt IS NULL
			LEFT JOIN categories ON categories.id = ec.categoryId AND categories.deletedAt IS NULL
			LEFT JOIN categoryurls ON categoryurls.categoryId = categories.id AND categoryurls.deletedAt IS NULL
			WHERE entryurls.titleURL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.titleURL#%">  AND entryurls.isActive = 1
					AND entryurls.deletedAt IS NULL
			ORDER BY entries.id ASC
			LIMIT 1
		</cfquery>

		<cfreturn qBlogEntry>


		<!---
		<cfset var qBlogEntry = model('entry').findOne(	select		= "	entries.id, entries.title, entries.content, entries.metaDescription, entries.metaKeyWords, entries.publishAt,
																	entrydiscussions.id AS entryDiscussionsId, count(distinct(entrydiscussions.id)) AS discussionCount,
																	entryurls.titleURL",
												include		= "entryurls,entrydiscussions",
												where		= "entryurls.titleURL = '#params.title#' AND entryurls.isActive = 1",
												returnAs	= "query",
												$limit		= 1)>
		 --->
	</cffunction>

	<cffunction name="GetLatestBlogs" returntype="query" access="public">
		<cfargument name="thisLimit" default="5" type="numeric">

		<cfset var qLatestBlogs = "">

		<cfquery datasource="#get("DATASOURCENAME")#" name="qLatestBlogs">
			SELECT 	entries.title, entryurls.titleURL, Date_Format(entries.publishAt, '%b %e, %Y') AS publishDate,
					entries.teaser AS contentTeaser,
					count(distinct(entrydiscussions.id)) AS commentCount
			FROM entries
			LEFT OUTER JOIN entrydiscussions ON
								entries.id = entrydiscussions.entryId AND entrydiscussions.entryDiscussionId IS NULL
								AND ( entrydiscussions.approvedAt IS NOT NULL OR (dateDiff(now(), entrydiscussions.createdAt) <= 1) )
								AND entrydiscussions.deletedAt IS NULL
			LEFT OUTER JOIN entryurls ON entries.id = entryurls.entryId AND entryurls.isActive = 1 AND entryurls.deletedAt IS NULL
			WHERE entries.deletedAt IS NULL AND entries.publishAt <= now()
			GROUP BY entries.id
			ORDER BY entries.id desc
			LIMIT <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.thisLimit#">
		</cfquery>

		<cfreturn qLatestBlogs>

		<!--- <cfset qLatestBlogs = model("entry").findAll(	select	= "	entries.title, entryurls.titleURL, Date_Format(entries.publishAt, '%b %e, %Y') AS publishDate,
																entries.teaser AS contentTeaser,
																count(distinct(entrydiscussions.id)) AS commentCount",
													include = "entrydiscussions,entryurls",
													where	= "entryurls.isActive = 1",
													group	= "entries.id",
													order	= "entries.id desc",
													$limit	= #arguments.thisLimit#)> --->

	</cffunction>

	<cffunction name="BlogSearch" returntype="query" access="public">
		<cfargument name="terms" default="" required="true">

		<cfset var qBlogSearch = "">

		<cfquery datasource="#get("DATASOURCENAME")#" name="qBlogSearch">
			SELECT entries.id, entries.title AS label, entryurls.titleURL AS value
			FROM entries
			JOIN entryurls ON entries.id = entryurls.entryId AND entryurls.isActive = 1 AND entryurls.deletedAt IS NULL
			WHERE MATCH (title,content) AGAINST (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.terms#"> IN NATURAL LANGUAGE MODE)
				 AND entries.publishAt <= now();
		</cfquery>

		<cfreturn qBlogSearch>

	</cffunction>

	<cffunction name="GetSeriesEntries" returntype="query">
		<cfargument name="entryId" required="true">

		<cfset var qSeriesPosts = "">

		<!--- Query any series this entry might belong to --->
		<cfquery datasource="#get("DATASOURCENAME")#" name="qSeriesPosts">
			SELECT e.id AS entryId, s.name, e.title, eu.titleURL
			FROM seriesentries se
			INNER JOIN seriesentries se2 ON se2.seriesid = se.seriesId AND se.deletedAt IS nULL
			INNER JOIN series s ON s.id = se.seriesId AND s.deletedAt IS NULL
			INNER JOIN entries e ON e.id = se2.entryId AND e.deletedAt IS NULL
			INNER JOIN entryurls eu ON eu.entryId = e.id AND eu.isActive = 1 AND eu.deletedAt IS NULL
			WHERE se.entryId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.entryId#"> AND se.deletedAt IS NULL
			ORDER BY se2.sequence
		</cfquery>

		<cfreturn qSeriesPosts>

	</cffunction>

</cfcomponent>