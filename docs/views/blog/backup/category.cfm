<div id="BlogEntryContainer">
<cfoutput>
<h1>#title#</h1>

<ul>
<cfloop query="qCategoryEntries">
	<li><a href="/blog/#qCategoryEntries.titleURL#">#qCategoryEntries.title#</a></li>
</cfloop>
</ul>
</cfoutput>
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