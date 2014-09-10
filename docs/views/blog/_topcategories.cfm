<div id="BlogRightSideMenuContainer">
	<div id="BlogRightSideLatest">
		<h3 class="BlogRightSideHeaderBG">Top Categories</h3>
		<ul>
			<cfoutput query="qTopCategories">
			<li><span class="BlogRightTitle">
					#linkTo(	route			= "Category",
								categoryName	= qTopCategories.nameURL,
								text			= qTopCategories.name)#
					(#qTopCategories.entryCount#)
				</span>
			</li>
			</cfoutput>
		</ul>

		<cfoutput>
		#linkTo(	route	= "Categories",
					text	= "All Categories",
					id		= "BlogRightAllCategories")#<br /><br />
		</cfoutput>
	</div>
</div>