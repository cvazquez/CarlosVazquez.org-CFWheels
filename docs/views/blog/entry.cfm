<cfoutput>
<div id="BlogEntryContainer">
	<h1>#title#</h1>
	<span id="PostDate">Posted #DateFormat(publishDate, "mmm dd, yyyy")#</span><br /><br />
	#content#


	<!-- Finally, to actually run the highlighter, you need to include this JS on your page -->
	<script type="text/javascript">
	     SyntaxHighlighter.all()
	</script>

	<!--- Image slideshow --->
	<cfif qFlikr.recordCount Gt 0>
		<div class="clear"></div>

		<!--- Display the regular size image --->
		<div class="ImageRegularFrame">
			<img src="/images/blog/#qFlikr.mediumUrlReWritten#.jpg" alt="#qFlikr.title#" title="#qFlikr.title#" border="0" id="ImageRegular" height="#qFlikr.mediumHeight#" width="#qFlikr.mediumWidth#">
		</div>
		<div id="ImageTitle">#qFlikr.title#</div>
		<div id="ImageDescription">#qFlikr.description#</div>


		<!--- List Thumbnails. When clicking on a thumbnail, it will fire an event to switch the Regular image with the thumbnail's regular image --->
		<div class="ImageThumbCarouselFrame">
		<cfloop query="qFlikr">
			<img 	src="/images/blog/#qFlikr.mediumUrlReWritten#.jpg?size=thumb" height="#qFlikr.squareHeight#" width="#qFlikr.squareWidth#"
					alt="#qFlikr.title# Thumbnail Picture"
					title="#qFlikr.title# Thumbnail Picture"
					ImageThumbNailId="#qFlikr.id#"
					class="SlideShowThumbNail"
					ImageRegularSrc="/images/blog/#qFlikr.mediumUrlReWritten#.jpg"
					ImageRegularAlt="#qFlikr.title#"
					ImageRegularHeight="#qFlikr.mediumHeight#"
					ImageRegularWidth="#qFlikr.mediumWidth#">
		</cfloop>
		</div>

	</cfif>


	<cfif qSeriesPosts.recordCount GT 0>
		<h3>Read more posts in the <i>#qSeriesPosts.name#</i> series:</h2>
		<ul>
			<cfloop query="qSeriesPosts">
				<li>
					<cfif qSeriesPosts.entryId EQ id>
						#qSeriesPosts.title#
					<cfelse>
						#linkTo(text="#qSeriesPosts.title#", href="/blog/#qSeriesPosts.titleURL#")#
					</cfif>
				</li>
			</cfloop>
		</ul>
	</cfif>


	<cfif NewEntryObject.id NEQ 168> <!--- Comments form --->
		<div class="clear"></div>

		<div  style="border-top: 20px solid silver; opacity: .25; margin-top: 20px; padding-top: 20px;"></div>

		<h2><a name="discussions">Discussions</a></h2>

		<div id="DiscussionBlock">
		<!--- When submitting a successfull new comment or reply, call the partial with AJAX and replace this block with the response --->
			#includePartial("entrydiscussions")#
		</div>

		<div class="clear"></div>

		<div id="CommentBlockContainer">
			<cfif cgi.server_name EQ "www.carlosvazquez.org">
				<p>Comments are currently turned off</p>
			<cfelse>
				#includePartial("commentform")#
			</cfif>
		</div>
	</cfif>

</div>

<div id="BlogHomeRightNav">
	#includePartial("topcategories")#
	#includePartial("latestblogs")#
	#includePartial("latestdiscussions")#
	#includePartial("ads")#
	#includePartial("yelp")#
</div>
<div class="clear"></div>

<cfif NOT flashIsEmpty()>
	<cfif flashKeyExists("success")>
		<script language="JavaScript">
			alert("#flash("success")#")
		</script>
	</cfif>
</cfif>
</cfoutput>