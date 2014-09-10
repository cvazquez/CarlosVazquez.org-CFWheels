<cfif qBlogDiscussions.recordCount GT 0>
<!--- Second type of discussion style --->
<cfoutput query="qBlogDiscussions">
	<!--- <div class="clear"></div> --->

	<a name="DiscussionId#qBlogDiscussions.id#"></a>
	<div id="BlogCommentUserHeaderContainer">
		<div id="BlogCommentUserHeaderImage"><img src="/images/emptyimage.jpg"></div>
		<div id="BlogCommentUserHeaderUser">
			<span id="BlogCommentUserHeaderName">#qBlogDiscussions.firstName# #qBlogDiscussions.lastName#</span>
			<span id="BlogCommentUserHeaderTime">#qBlogDiscussions.postDate# #qBlogDiscussions.postTime# - #qBlogDiscussions.userCommentCount# Comments</span>
		</div>
	</div>
	<div class="clear"></div>
	<div class="BlogCommentUserComment">#qBlogDiscussions.content#</div>

	<cfif qBlogDiscussions.hasReplies>
		<cfset qBlogDiscussionReplies = model("Entrydiscussion").GetDiscussionReplies(qBlogDiscussions.id)>


		<div style="margin-left: 50px;">
			<cfloop query="qBlogDiscussionReplies">
				<a name="DiscussionId#qBlogDiscussionReplies.id#">
				<p>&gt;&gt;&gt; #qBlogDiscussionReplies.content#</p>
			</cfloop>
		</div>
	</cfif>

	<div class="BlogCommentUserCommentReply">
			<span class="BlogCommentUserCommentCancelText">Cancel Reply<br /><br /></span>
			<span class="BlogCommentUserCommentReplyText" onclick="DisplayComment(#qBlogDiscussions.id#, this);">Reply</span>
			<div class="BlogCommentUserAddCommentBlock"></div>
	</div>

	<div class="BlogCommentUserSeparator"></div>
</cfoutput>
</cfif>
<beforeDebug>