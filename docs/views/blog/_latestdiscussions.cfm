<div id="BlogRightSideMenuContainer">
	<div id="BlogRightSideLatest">
		<h3 class="BlogRightSideHeaderBG">Latest Discussions</h3>
		<ul>
			<cfoutput query="qLatestDiscussions">
			<li>	<span class="BlogRightTitle"><a href="/blog/#qLatestDiscussions.titleURL###DiscussionId#qLatestDiscussions.entrydiscussionid#">#qLatestDiscussions.firstName#</a>: #qLatestDiscussions.commentTeaser#</span><br />
					<span class="BlogRightDateComment">#qLatestDiscussions.commentDate# | Replies (#qLatestDiscussions.replyCount#)</span>
			</li>
			</cfoutput>
		</ul>
	</div>
</div>