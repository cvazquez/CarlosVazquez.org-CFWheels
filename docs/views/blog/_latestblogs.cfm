<div id="BlogRightSideMenuContainer">
	<div id="BlogRightSideLatest">
		<h3 class="BlogRightSideHeaderBG">Latest Blogs</h3>
		<ul>
			<cfoutput query="qLatestBlogs">
			<li>	<span class="BlogRightTitle"><a href="/blog/#qLatestBlogs.titleURL#">#qLatestBlogs.title#</a></span><br />
					<span class="BlogRightDateComment">
						#qLatestBlogs.publishDate# |
						<a href="/blog/#qLatestBlogs.titleURL###discussions">COMMENTS (#qLatestBlogs.commentCount#)</a>
					</span>
			</li>
			</cfoutput>
		</ul>
	</div>
</div>