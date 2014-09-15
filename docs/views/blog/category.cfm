<div id="BlogEntryContainer">
<cfoutput>
<h1>#title#</h1>
<p>#qCategory.description#</p>
</cfoutput>

<!---
<ul>
<cfloop query="qCategoryEntries">
	<li><a href="/blog/#qCategoryEntries.titleURL#">#qCategoryEntries.title#</a></li>
</cfloop>
</ul>
</cfoutput>
</div>
--->

<div id="BlogRollContainer">
	<!--- <h1 style="padding-bottom: 10px;">Latest Posts</h1> --->

	<cfoutput query="qCategoryEntries">
		<div class="BlogRollEntryBorders">
		<h2 class="BlogRollEntryHeaders"><a href="/blog/#qCategoryEntries.titleURL#">#qCategoryEntries.title#</a></h2>
		<span class="BlogRollEntryPostedDate">Posted #qCategoryEntries.publishDate#</span>
	
		<p>#StripCR(qCategoryEntries.contentTeaser)#</p>
		</div>
	</cfoutput>
</div>
</div>


<div id="BlogHomeRightNav">
	<cfoutput>
	#includePartial("topcategories")#
	#includePartial("latestblogs")#
	#includePartial("latestdiscussions")#
	#includePartial("ads")#
	</cfoutput>
</div>
<div class="clear"></div>