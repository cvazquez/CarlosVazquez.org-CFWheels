<cfif NOT flashIsEmpty()>
	<cfif flashKeyExists("success")>
		<cfoutput>
		<script language="JavaScript">
			alert("#flash("success")#")
		</script>
		</cfoutput>
	</cfif>
</cfif>

<div id="BlogRollContainer">
	<!--- <h1 style="padding-bottom: 10px;">Latest Posts</h1> --->

	<cfoutput query="qBlogRoll">
	<div class="BlogRollEntryBorders">
	<h2 class="BlogRollEntryHeaders"><a href="/blog/#qBlogRoll.titleURL#">#qBlogRoll.title#</a></h2>
	<span class="BlogRollEntryPostedDate">Posted #qBlogRoll.publishDate#</span>

	<p>#StripCR(qBlogRoll.contentTeaser)#</p>
	</div>
	</cfoutput>
</div>


<div id="BlogHomeRightNav">
	<cfoutput>
	#includePartial("topcategories")#
	</cfoutput>

	<cfoutput>
	#includePartial("latestdiscussions")#
	</cfoutput>

	<cfoutput>
	#includePartial("latestblogs")#
	</cfoutput>

	<cfoutput>
	#includePartial("ads")#
	</cfoutput>
</div>
<div class="clear"></div>