<div id="BlogRollContainer">
	<h1>All Categories</h1>

	<ul>
		<cfoutput query="qAllCategories">
		<li>	<span class="BlogRightTitle">
					#linkTo(	route			= "Category",
								categoryName	= qAllCategories.nameURL,
								text			= qAllCategories.name)#
					 (#qAllCategories.entryCount#)
				</span>
		</li>
		</cfoutput>
	</ul>
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