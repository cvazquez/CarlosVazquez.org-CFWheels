<cfcomponent output="false" extends="Controller">

<cffunction name="init">
	<cfset provides("html,json")>
	<cfset filters(through="logvisits", type="after")>

</cffunction>


<cffunction name="index" hint="/blog/">

	<cfset title = "The Adventures of Carlos">

	<cfset qBlogRoll = LatestBlogs(10)>
	<cfset qLatestBlogs = LatestBlogs()>
	<cfset qLatestDiscussions = LatestDiscussions()>
	<cfset qTopCategories = TopCategories()>

	<cfset breadCrumbArray = []>
	<cfset breadCrumbCurrent = "">

</cffunction>


<cffunction name="Categories" hint="/blog/categories">
	<cfset title = "All Categories">


	<cfset qAllCategories = model("category").findAll(
							select	= "categories.name, categoryurls.name AS nameURL, count(distinct(entrycategories.entryId)) AS entryCount",
							include = "categoryurl,entrycategories(entry)",
							group	= "entrycategories.categoryId",
							order	= "categories.name")>

	<cfset qLatestBlogs = LatestBlogs()>
	<cfset qLatestDiscussions = LatestDiscussions()>
	<cfset qTopCategories = TopCategories()>

</cffunction>


<cffunction name="Category" hint="/blog/category/[categoryName]">
	<!--- Find the category URL ---->
	<cfset qCategory = model("category").findOne(	select	= "categories.id, categories.name AS categoryName, categoryurls.name AS URLName",
													include	= "categoryurl,entrycategories",
													where	= "categoryurls.name = '#params.categoryName#' AND categoryurls.isActive = 1",
													returnAs	= "query")>

	<!--- Check if the correct case is used in URL. If not, then redirect to the correct case --->
	<cfif Compare(params.categoryName, qCategory.URLName) NEQ 0>
		<cfset redirectTo(	route			="Category",
							categoryName	= qCategory.URLName)>
	</cfif>

	<cfset qCategoryEntries = model("entry").findAll(	select	= "entries.title, entryurls.titleURL, Date_Format(entries.publishAt, '%b %e, %Y') AS publishDate,
																	entries.teaser AS contentTeaser",
																include	= "entrycategories,entryurls",
																where	= "entrycategories.categoryId = #qCategory.id#",
																order	= "entries.publishAt desc")>

	<cfset qLatestBlogs = LatestBlogs()>
	<cfset qLatestDiscussions = LatestDiscussions()>
	<cfset qTopCategories = TopCategories()>

	<cfset title = qCategory.categoryName & " Blog Entries">

	<cfset breadCrumbArray[1] = "/blog|Home">
	<cfset breadCrumbArray[2] = "/blog/categories|Categories">

</cffunction>


<cffunction name="Entry" access="public" hint="/blog/[title]">
	<cfset var loc = {}>

	<!--- This entry --->
	<cfset var qBlogEntry = model('entry').GetBlogEntry(titleURL	= params.title)>

	<cfset xmlResponseObject = "">



	<cfif qBlogEntry.recordCount EQ 0 OR qBlogEntry.id EQ "">
		<cfheader statuscode="404">
		<cfset doNotIndex = true>

		<cfset RenderPage(	controller	= "home",
							action		= "notfound")>
	<cfelse>

		<!--- Check if the correct case is used in URL. If not, then redirect to the correct case --->
		<cfif Compare(params.title, qBlogEntry.titleURL) NEQ 0>
			<cfset redirectTo(	route	= "Entry",
								title	= qBlogEntry.titleURL,
								statusCode	= "301")>
		</cfif>

		<cfset title = qBlogEntry.title>
		<cfset content = qBlogEntry.content>
		<cfset publishDate = qBlogEntry.publishAt>


		<!--- Comments/Discussion to display at bottom of blog --->
		<cfif qBlogEntry.discussionCount GT 0>
			<cfset qBlogDiscussions = model("Entrydiscussion").GetEntryDiscussions(qBlogEntry.id)>
		<cfelse>
			<cfset qBlogDiscussions = QueryNew("")>
		</cfif>



		<!--- Retrieve cached Flickr photo locations --->
		<cfset qFlikr = model("EntryFlickrSet").findAllByEntryId(	include	= "FlickrSet(FlickrSetPhotos(FlickrSetPhotoUrl))",
																	value	= qBlogEntry.id,
																	select	= "	flickrsetphotos.id, flickrsetphotos.title, flickrsetphotos.description,
																				flickrsetphotos.squareurl, flickrsetphotos.squarewidth, flickrsetphotos.squareheight,
																				flickrsetphotos.mediumurl, flickrsetphotos.mediumwidth, flickrsetphotos.mediumheight,
																				flickrsetphotourls.name AS mediumUrlReWritten
																				",
																	order	= "flickrsetphotos.orderid",
																	where	= "flickrsetphotourls.isActive = 1")>


		<!--- Side Breakouts --->
		<cfset qTopCategories = TopCategories()>
		<cfset qLatestBlogs = LatestBlogs()>
		<cfset qLatestDiscussions = LatestDiscussions()>


		<!--- Setup objects for Comments form --->
		<cfset NewEntryObject = model("entry").new(	id	= qBlogEntry.id)>
		<cfset NewUserObject = model("user").new()>
		<cfset NewEntryCommentObject = model("entrydiscussion").new()>


		<!--- Javascript functions for this action --->
		<cfset javaScriptIncludeTag(sources	= "blog/entry",
									head	= true)>

		<cfset breadCrumbArray[1] = "/blog|Home">
		<cfif listLen(qBlogEntry.categoryURL) AND listLen(qBlogEntry.categoryName)>
			<cfset breadCrumbArray[2] = "/blog/category/#qBlogEntry.categoryURL#|#qBlogEntry.categoryName#">
		</cfif>
		<cfset breadCrumbCurrent = ''>
	</cfif>
</cffunction>


<cffunction name="CacheFlickrAll" access="public">
	<!--- http://railo.carlosvazquez.org/blog/cache-flickr-all?passwd= --->
	<cfset var loc = {}>

	<cfparam default="" name="params.passwd">


	<cfif params.passwd EQ get("reloadPassword")>

		<!--- Retrieve Collections you would insert into the database yourself, based on collections containing sets which contain images you want to show on the blog--->
		<cfset loc.qFlickrCollections	= model("FlickrCollection").findAll(	select	= "id")>


		<cfloop query="loc.qFlickrCollections">
			<!--- Loop through Collections  --->

			<!--- Do a json and xml version for documentation --->
			<!--- Create a request string, to retrieve a list of sets in this collection --->
			<!--- http://www.flickr.com/services/api/explore/flickr.collections.getTree --->
			<cfset loc.apiCollectionURL = "http://api.flickr.com/services/rest/?method=flickr.collections.getTree&api_key=#Application.settings.flickrAPIKey#&collection_id=#loc.qFlickrCollections.id#&user_id=#Application.settings.flickrUserId#&format=rest">

			<cfoutput>
				apiPhotoSetURL = #loc.apiCollectionURL#<br />
			</cfoutput>


			<!--- Request this Collections list of Sets --->
			<cfhttp url		= "#loc.apiCollectionURL#"
					method	= "get"
					result	= "loc.xmlCollectionResponse"
					timeout	= "5">
			<!--- Possible Error codes
					name	= "rFlikr"
					http://www.flickr.com/services/api/flickr.photosets.getPhotos.html
			--->

			<cfset loc.apiCollectionResponse = xmlParse(loc.xmlCollectionResponse.FileContent)>

			<cfoutput>
				<!--- <p><cfdump var="#rFlikr#" label="rFlikr"></p> --->
				<p><cfdump var="#loc.apiCollectionResponse#" label="apiCollectionResponse"></p>
			</cfoutput>

			<cfset loc.xmlCollectionOfSets = loc.apiCollectionResponse.XmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren>

			<cfdump var="#loc.xmlCollectionOfSets#">

			<!--- <cfdump var="#loc.xmlCollectionOfSets[1].XmlChildren#"> --->

			<cfset loc.numOfSets = arrayLen(loc.xmlCollectionOfSets)>

			<cfoutput><p>numOfSets = #loc.numOfSets#</p></cfoutput>



			<!--- Loop through sets. Insert if they don't exists, and update if different. Then loop through the images in the set and cache their URLs --->
			<cfloop from = "1" to = "#loc.numOfSets#" index="setIndex">

				<!--- Informaiton about this set --->
				<cfset loc.thisSet= loc.xmlCollectionOfSets[setIndex].xmlAttributes>

				<!--- Check if this set exists in the database --->
				<cfset loc.FlickrSet = model("FlickrSet").FindByKey(	key 	= loc.thisSet.id,
																		select	= "id, title, description")>

				<cfif isObject(loc.FlickrSet)>
					<!--- This set exists, so we try to update it --->

					<!--- Check if anything changed and if it did, then just update that field. I don't want to blindly update the table if nothing changed, so the updatedAt and timestamp field don't update  --->
					<cfif	loc.FlickrSet.title NEQ loc.thisSet.title OR
							loc.FlickrSet.description NEQ loc.thisSet.description>

						<cfif loc.FlickrSet.title NEQ loc.thisSet.title>
							<cfset loc.FlickrSet.title = loc.thisSet.title>
						</cfif>

						<cfif loc.FlickrSet.description NEQ loc.thisSet.description>
							<cfset loc.FlickrSet.description = loc.thisSet.description>
						</cfif>

						<cfset loc.FlickrSet.save()>

						<cfif loc.FlickrSet.hasErrors()>
							<cfoutput>
								<p>Updating a Flickr SET has Errors</p>
								<cfdump var="#loc.FlickrSet.allErrors()#">
							</cfoutput>
							<cfabort>
						</cfif>
					</cfif>


				<cfelse>

					<!--- Create a new set --->
					<cfset loc.newFlickrSet	= model("FlickrSet").new()>
						<cfset loc.newFlickrSet.id = loc.thisSet.id>
						<cfset loc.newFlickrSet.flickrCollectionId = loc.qFlickrCollections.id>
						<cfset loc.newFlickrSet.title = loc.thisSet.title>
						<cfset loc.newFlickrSet.description = loc.thisSet.description>
					<cfset loc.newFlickrSet.save()>

					<cfif loc.newFlickrSet.hasErrors()>
						<cfoutput>
							<p>Creating a Flickr SET has Errors</p>
							<cfdump var="#loc.newFlickrSet.allErrors()#">
						</cfoutput>
						<cfabort>
					</cfif>


				</cfif>

			</cfloop>



			<!--- Loop through the sets retrieved in this Collection. Then retrieve photos for these sets to cache in a database --->
			<cfloop from = "1" to = "#loc.numOfSets#" index="setIndex">

					<!--- Information about this set --->
					<cfset loc.thisSet= loc.xmlCollectionOfSets[setIndex].xmlAttributes>


					<cfdump var="#loc.thisSet#" label="loc.thisSet">


					<!--- http://www.flickr.com/services/api/explore/flickr.photosets.getPhotos --->
					<!--- Create a Flickr Request string to get a list of photos in this set --->
					<cfset loc.apiPhotoSetURL = "http://api.flickr.com/services/rest/?method=flickr.photosets.getPhotos&api_key=#Application.settings.flickrAPIKey#&photoset_id=#loc.thisSet.id#&extras=date_taken,url_sq,url_s,url_m,url_o&user_id=#Application.settings.flickrUserId#&format=rest">

					<cfoutput>
						<p>apiPhotoSetURL = #loc.apiPhotoSetURL#</p>
					</cfoutput>


					<!--- Request a list of photos for this Flikr Set --->
					<cfhttp url		= "#loc.apiPhotoSetURL#"
							method	= "get"
							result	= "loc.xmlPhotoResponse"
							timeout	= "5">
					<!--- Possible Error codes
							http://www.flickr.com/services/api/flickr.photosets.getPhotos.html
					--->

					<cfset loc.apiPhotoSetReponseObject = xmlParse(loc.xmlPhotoResponse.FileContent)>

					 <cfoutput>
						<p><cfdump var="#loc.apiPhotoSetReponseObject#" label="loc.apiPhotoSetReponseObject"></p>
					</cfoutput>


					<cfset loc.numOfImages = arrayLen(loc.apiPhotoSetReponseObject.XmlRoot.XmlChildren[1].XmlChildren)>

					<cfoutput>
						<p>numOfImages = #loc.numOfImages#</p>
					</cfoutput>



					<!--- Loop through IMAGES. Insert if they don't exists, and update if different --->
					<cfloop from = "1" to = "#loc.numOfImages#" index="pI">

						<cfset loc.thisImage = loc.apiPhotoSetReponseObject.XmlRoot.XmlChildren[1].XmlChildren[pI].XmlAttributes>

						<cfoutput>
						<P><cfdump var="#loc.thisImage #"></P>

						</cfoutput>

						<!--- Check if this image exists --->
						<cfset loc.FlickrImage = model("FlickrSetPhoto").FindByKey(	key 	= loc.thisImage.id,
																					select	= "	id, flickrSetId, orderId, title,
																								squareURL, squareWidth, squareHeight,
																								mediumURL, mediumWidth, mediumHeight,
																								largeURL, largeWidth, largeHeight,
																								takenAt,")>


						<cfif isObject(loc.FlickrImage)>
							<!--- This Image Exists. Update its information in the database --->

							<!--- Check if anything changed and if it did, then just update that field --->
							<cfif	loc.FlickrImage.flickrSetId NEQ loc.thisSet.id OR
									loc.FlickrImage.orderId NEQ pI OR
									loc.FlickrImage.title NEQ loc.thisImage.title OR
									loc.FlickrImage.squareURL NEQ loc.thisImage.url_sq OR
									loc.FlickrImage.squareWidth NEQ loc.thisImage.width_sq OR
									loc.FlickrImage.squareHeight NEQ loc.thisImage.height_sq OR
									loc.FlickrImage.mediumURL NEQ loc.thisImage.url_m OR
									loc.FlickrImage.mediumWidth NEQ loc.thisImage.width_m OR
									loc.FlickrImage.mediumHeight NEQ loc.thisImage.height_m OR
									loc.FlickrImage.takenAt NEQ loc.thisImage.datetaken>


								<cfif loc.FlickrImage.flickrSetId NEQ loc.thisSet.id>
									<cfoutput> loc.thisSet.id = # loc.thisSet.id#</cfoutput>
									<!--- <cfset loc.FlickrImage.flickrSetId = loc.thisSet.id> --->
								</cfif>

								<cfif loc.FlickrImage.orderId NEQ pI>
									<cfset loc.FlickrImage.orderId = pI>
								</cfif>

								<cfif loc.FlickrImage.title NEQ loc.thisImage.title>
									<cfset loc.FlickrImage.title = loc.thisImage.title>
								</cfif>

								<cfif loc.FlickrImage.squareURL NEQ loc.thisImage.url_sq>
									<cfset loc.FlickrImage.squareURL = loc.thisImage.url_sq>
								</cfif>

								<cfif loc.FlickrImage.squareWidth NEQ loc.thisImage.width_sq>
									<cfset loc.FlickrImage.squareWidth = loc.thisImage.width_sq>
								</cfif>

								<cfif loc.FlickrImage.squareHeight NEQ loc.thisImage.height_sq>
									<cfset loc.FlickrImage.squareHeight = loc.thisImage.height_sq>
								</cfif>

								<cfif loc.FlickrImage.mediumURL NEQ loc.thisImage.url_m>
									<cfset loc.FlickrImage.mediumURL = loc.thisImage.url_m>
								</cfif>

								<cfif loc.FlickrImage.mediumWidth NEQ loc.thisImage.width_m>
									<cfset loc.FlickrImage.mediumWidth = loc.thisImage.width_m>
								</cfif>

								<cfif loc.FlickrImage.mediumHeight NEQ loc.thisImage.height_m>
									<cfset loc.FlickrImage.mediumHeight = loc.thisImage.height_m>
								</cfif>

								<cfif loc.FlickrImage.largeURL NEQ loc.thisImage.url_m>
									<cfset loc.FlickrImage.largeURL = loc.thisImage.url_m>
								</cfif>

								<cfif loc.FlickrImage.largeWidth NEQ loc.thisImage.width_m>
									<cfset loc.FlickrImage.largeWidth = loc.thisImage.width_m>
								</cfif>

								<cfif loc.FlickrImage.largeHeight NEQ loc.thisImage.height_m>
									<cfset loc.FlickrImage.largeHeight = loc.thisImage.height_m>
								</cfif>

								<cfif loc.FlickrImage.takenAt NEQ loc.thisImage.datetaken>
									<cfset loc.FlickrImage.takenAt = loc.thisImage.datetaken>
								</cfif>

								<cfset loc.FlickrImage.save()>

								<cfif loc.FlickrImage.hasErrors()>
									<cfoutput>
										<p>Updating a Flickr Image has Errors</p>
										<cfdump var="#loc.FlickrImage.allErrors()#">
									</cfoutput>
									<cfabort>
								</cfif>
							</cfif>

						<cfelse>

							<!--- The Image doesn't exist, so we Create a database record for it --->
							<cfset loc.newFlickrImage	= model("FlickrSetPhoto").new()>
								<cfset loc.newFlickrImage.id = loc.thisImage.id>
								<cfset loc.newFlickrImage.flickrSetId = val(loc.thisSet.id)>
								<cfset loc.newFlickrImage.orderId = pI>
								<cfset loc.newFlickrImage.title = loc.thisImage.title>
								<cfset loc.newFlickrImage.squareURL = loc.thisImage.url_sq>
								<cfset loc.newFlickrImage.squareWidth = loc.thisImage.width_sq>
								<cfset loc.newFlickrImage.squareHeight = loc.thisImage.height_sq>
								<cfset loc.newFlickrImage.mediumURL = loc.thisImage.url_m>
								<cfset loc.newFlickrImage.mediumWidth = loc.thisImage.width_m>
								<cfset loc.newFlickrImage.mediumHeight = loc.thisImage.height_m>
								<cfset loc.newFlickrImage.largeURL = loc.thisImage.url_m>
								<cfset loc.newFlickrImage.largeWidth = loc.thisImage.width_m>
								<cfset loc.newFlickrImage.largeHeight = loc.thisImage.height_m>
								<cfset loc.newFlickrImage.takenAt = loc.thisImage.datetaken>
							<cfset loc.newFlickrImage.save()>

							<cfif loc.newFlickrImage.hasErrors()>
								<cfoutput>
									<p>Creating a Flickr Image has Errors</p>
									<cfdump var="#loc.newFlickrImage.allErrors()#">
								</cfoutput>
								<cfabort>
							</cfif>

						</cfif>

					</cfloop>

			</cfloop>

		</cfloop>

		<!--- Create image urls with title of the image. An htaccess rule will rewrite them to the flikr URL --->
		<cfquery datasource="mybloginsert">
			INSERT IGNORE INTO flickrsetphotourls (flickrSetPhotoId, name, isActive, createdAt)
			SELECT id, CreateTitleURL(title), 1, now()
			FROM flickrsetphotos
			WHERE deletedAt IS NULL
			ORDER BY id;
		</cfquery>

		<!--- Disable any urls that don't equal the title --->
		<cfquery datasource="mybloginsert">
			UPDATE flickrsetphotourls fspu
			INNER JOIN flickrsetphotos fsp ON fsp.id = fspu.flickrSetPhotoId AND CreateTitleURL(fsp.title) <> fspu.name
			SET fspu.isActive = 0;
		</cfquery>

	</cfif>

	<cfset renderNothing()>

</cffunction>


<cffunction name="CacheFlickrImages" access="public">
	<cfparam default="" name="params.entryId">


	<cfif isnumeric(params.entryId)>
		<cfset qFlikr = model("EntryFlickrSet").findOneByEntryId(	value		= params.entryId,
																	select		= "photoSetId",
																	returnAs 	= "query")>
	<cfelse>

		<cfset qFlikr = model("EntryFlickrSet").findAllByEntryId(	select	= "photoSetId")>

	</cfif>

	<cfloop query="qFlikr">

		<!--- Do a json and xml version for documentation --->
		<cfset apiPhotoSetURL = "http://api.flickr.com/services/rest/?method=flickr.photosets.getPhotos&api_key=#Application.settings.flickrAPIKey#&photoset_id=#qFlikr.photoSetId#&extras=date_taken,url_sq,url_s,url_m&format=rest">

		<cfoutput>
			<!--- <cfdump var="#qFlikr#"><br /><br /> --->
			<!--- apiURL = #apiPhotoSetURL#<br /> --->
		</cfoutput>


		<!--- Maybe I can cache these into a database and it only reloads the database when I tell it to --->
		<cfhttp url		= "#apiPhotoSetURL#"
				method	= "get"
				name	= "rFlikr"
				result	= "xmlResponse"
				timeout	= "5">
		<!--- Possible Error codes
				http://www.flickr.com/services/api/flickr.photosets.getPhotos.html
		--->

		<cfset xmlResponseObject = xmlParse(xmlResponse.FileContent)>

		<!--- <cfoutput>
			<cfdump var="#rFlikr#">
			<cfdump var="#xmlResponseObject#">
		</cfoutput>
		<cfabort> --->


		<!--- Let's store the image information in a table, so we don't have to call the Flikr API everytime.
				I need to create a variable that updates the table
		--->


			<cfset numOfImages = arrayLen(xmlResponseObject.XmlRoot.XmlChildren[1].XmlChildren)>

			<cfquery datasource="mybloginsert">
				INSERT INTO entryflickrsetpictures
						(	flickrSetId, orderId, title, description,
							squareURL, squareWidth, squareHeight,
							mediumURL, mediumWidth, mediumHeight,
							<!--- largeURL, largeWidth, largeHeight,  --->
							takenAt, createdAt)
				VALUES
					<cfloop from = "1" to = "#numOfImages#" index="pI">
						<cfset thisRecord = xmlResponseObject.XmlRoot.XmlChildren[1].XmlChildren[pI].XmlAttributes>
						(	#qFlikr.photoSetId#, #pI#, "#thisRecord.title#", "",
							"#thisRecord.url_sq#", #thisRecord.width_sq#, #thisRecord.height_sq#,
							"#thisRecord.url_m#", #thisRecord.width_m#, #thisRecord.height_m#,
							<!--- "#thisRecord.url_o#", #thisRecord.width_o#, #thisRecord.height_o#, --->
							"#thisRecord.datetaken#", now()
						)
						<cfif pI LT numOfImages>,</cfif>
					</cfloop>
			</cfquery>
	</cfloop>

</cffunction>


<cffunction name="DivParser" access="private">

</cffunction>

<cffunction name="CacheYelpReviews" access="public">

	<!---
		http://railo.carlosvazquez.org/blog/cache-yelp-reviews?pageStart=10
	--->

	<cfparam default="AMaRAzW-FXc2hqrBmHS40w" name="params.userId">
	<cfparam default="0" name="params.pageStart">


	<cfset var local = {}>
	<cfset local.nextPos = 0>
	<cfset local.Positions = {}>
	<cfset local.reviewStartString = '<div class=\"review clearfix\">'>
	<cfset local.yelpURL = "http://www.yelp.com/user_details_reviews_self?userid=#params.userid#&rec_pagestart=#params.pageStart#">

	<cfoutput><p>local.yelpURL = #local.yelpURL#</p></cfoutput>

	<cfhttp url="#local.yelpURL#"
			method="get">
	</cfhttp>

	<!--- <cfdump var="#cfhttp#"> --->


	<cfset local.startPos = reFindNoCase('<div class="column column-alpha " id="user_main_content">', cfhttp.FileContent, 1, "TRUE")>
	<cfset local.endPos = reFindNoCase('<div class="column column-beta " id="about_user_column">', cfhttp.FileContent, 1, "TRUE")>
	<cfset local.docLength = len(cfhttp.FileContent)>
	<cfset local.reviewContent = Mid(cfhttp.FileContent, local.startPos.pos[1], local.endPos.pos[1]-local.startPos.pos[1])>

	<cfset newYelpArchive = model("yelparchivesave").new()>

	<cfset newYelpArchive.content = trim(local.reviewContent)>
	<cfset newYelpArchive.pageNumber = params.pageStart>
	<cfset newYelpArchive.userId = 1>
	<cfset newYelpArchive.save()>

	<cfif newYelpArchive.hasErrors()>
		<cfoutput>local.reviewContent = #len(local.reviewContent)#</cfoutput>
		<cfdump var="#newYelpArchive.allErrors()#">
		<cfabort>
	</cfif>


	<cfabort>

	<cfset local.reviewSt = reFindNoCase(local.reviewStartString, local.reviewContent, local.nextPos, TRUE)>
	<cfset local.reviewThisPageCount = REMatchNoCase(local.reviewStartString, local.reviewContent)>
	<cfset local.numOfReviews = ArrayLen(local.reviewThisPageCount)>

	<cfset local.nextPos = local.reviewSt.pos[1] + local.reviewSt.len[1]>

	<cfloop from = "1" to = "#local.numOfReviews#" index="local.x">
		<cfset local.aPositions[local.x].Pos = local.reviewSt.pos[1]>
		<cfset local.aPositions[local.x].Len = local.reviewSt.len[1]>

		<cfset local.reviewSt = reFindNoCase(local.reviewStartString, local.reviewContent, local.nextPos, TRUE)>
		<cfset local.nextPos = local.nextPos + local.reviewSt.pos[1]> <!---  + local.reviewSt.len[1] --->
		<cfset local.aPositions[local.x].NextPos = local.nextPos>

		<cfoutput>
			<cfif local.aPositions[local.x].Pos GT 0 AND (local.reviewSt.pos[1] - local.aPositions[local.x].Pos) GT 0>
				<p><strong>(#local.x#)</strong><br />
					#mid(local.reviewContent, local.aPositions[local.x].Pos, local.reviewSt.pos[1] - local.aPositions[local.x].Pos)#</p>
				<hr>
			</cfif>
		</cfoutput>
	</cfloop>


	<cfdump var="#local#">

	<!--- <cfoutput>#cfhttp.FileContent#</cfoutput> --->

	<!--- <div class="column column-alpha " id="user_main_content">
	<div class="column column-beta " id="about_user_column"> --->




<cfabort>


</cffunction>


<cffunction name="PictureRedirect" access="public">
	<!--- 	http://railo.carlosvazquez.org/images/blog/Colca-Canyon-Valley-Floor.jpg
			http://railo.carlosvazquez.org/images/blog/Colca-Canyon-Valley-Floor.jpg?size=thumb
	 --->

	<cfset var loc = {}>

	<!--- By default we display the medium sized photo --->
	<cfset loc.pictureURL = "mediumURL">

	<cfparam default="" name="params.pictureUrl">
	<cfparam default="" name="params.size">

	<!--- Currently only the thumb value is supported --->
	<cfif params.size EQ "thumb">
		<cfset loc.pictureURL = "squareURL">
	<cfelse>
		<cfset params.size = "">
	</cfif>


	<cfset qPicture = model("FlickrSetPhotoUrl").findOneByName(	select	= "flickrsetphotos.#loc.pictureURL# AS picURL, flickrsetphotourls.name AS correctCase",
																include	= "flickrSetPhoto",
																value	= params.pictureUrl,
																where	= "isActive = 1",
																returnAs = "query")>



	<!--- Detect if the picture filename is the correct case and if it isn't, then redirect to the correct case --->
	<cfif Compare("#params.pictureUrl#.jpg", "#qPicture.correctCase#.jpg") NEQ 0>
		<!---
			http://railo.carlosvazquez.org/images/blog/colca-cANyon-Valley-Floor.jpg
			http://railo.carlosvazquez.org/images/blog/colca-cANyon-Valley-Floor.jpg?size=thumb
			http://railo.carlosvazquez.org/images/blog/colca-cANyon-Valley-Floor.jpg?size=thumbdede
		--->
		<!--- <cfoutput>
			params.pictureUrl, "#qPicture.correctCase#.jpg" = #params.pictureUrl#, "#qPicture.correctCase#.jpg"<br />
			<cfabort>
		</cfoutput> --->

		<cflocation url="#qPicture.correctCase#.jpg#(params.size NEQ '' ? '?size=' & params.size : '')#" addtoken="false" statuscode="301">
	</cfif>


	<!--- <cfdump var="#qPicture#">
	<cfabort> --->

	<!--- <cfcontent > --->
	<cflocation url="#qPicture.picURL#" addtoken="false" statuscode="301">

</cffunction>


<cffunction name="SaveComment" access="public" hint="Submitted through AJAX">
	<cfset var loc = {}>

	<cftry>
		<cftransaction>
			<cfset newComment = model("entrydiscussionsave").new()>
			<cfset newComment.content = params.NewEntryCommentObject.content>
			<cfset newComment.firstName = params.NewEntryCommentObject.firstName>
			<cfset newComment.lastName = params.NewEntryCommentObject.lastName>
			<cfset newComment.email = params.NewEntryCommentObject.email>
			<cfset newComment.entryId = params.NewEntryObject.id>
			<cfset newComment.wantsReplies = params.NewEntryCommentObject.wantsReplies>


			<cfset newComment.cfId = client.cfid>

			<!--- If the referrer is not this domain, then it should be external --->
			<cfif NOT ReFindNoCase("^https?://#cgi.server_name#", cgi.http_referer)>
				<cfset newComment.httpRefererExternal = cgi.http_referer>
			</cfif>
			<cfset newComment.httpRefererInternal = cgi.HTTP_REFERER>
			<cfset newComment.httpUserAgent = cgi.http_user_agent>
			<cfset newComment.ipAddress = cgi.remote_addr>
			<cfset newComment.pathInfo = cgi.path_info>


			<cfif val(params.NewEntryCommentObject.entryDiscussionId) GT 0>
				<!--- Check if this entry exists --->
				<cfset newComment.entryDiscussionId = params.NewEntryCommentObject.entryDiscussionId>
			</cfif>

			<cfset newComment.validCaptcha = validateCaptcha()>

			<cfset newComment.save(	parameterize	= true)>
		</cftransaction>

		<cfsetting showdebugoutput="false">
		<cfif newComment.hasErrors()>
			<cfset renderWith(newComment.allErrors())>
		<cfelse>

			<cfquery datasource="#get("DATASOURCENAME")#" name="qValidation">
				SELECT sha2(concat(id, entryId, IFNULL(entryDiscussionId, 0), IFNULL(userId, 0), firstName, lastName, email, content, createdAt), 224) AS encryptString
				FROM entrydiscussions
				WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#newComment.id#">;
			</cfquery>

			<cfquery datasource="#get("DATASOURCENAME")#">
				UPDATE entrydiscussions
				SET emailValidationString = "#qValidation.encryptString#"
				WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#newComment.id#">;
			</cfquery>

			<!--- Email validation sent to the user to validate this comment --->
			<cfmail	to		= "#params.NewEntryCommentObject.email#"
					from 	= "#Application.AdminEmails.comments#"
					bcc 	= "#Application.AdminEmails.admin#"
					subject	= "CarlosVazquez.org - Comment Validation Confirmation"
					server	= "localhost">
			Please click the following link to validate your comment:
			http://#cgi.server_name#/blog/validate/#qValidation.encryptString#

			This email was sent to #params.NewEntryCommentObject.email#
			</cfmail>

			<cfset comment = {}>
			<cfset comment["id"] = newComment.id>
			<cfset renderWith(comment)>
		</cfif>

	<cfcatch type="any">
		<cfset EmailError(cfcatch)>
	</cfcatch>
	</cftry>

	<!--- </cfif> --->
</cffunction>


<cffunction name="validate" access="public">
	<cfparam default="" name="params.key">

	<cfset var LocalValidate = {}>
	<cfset LocalValidate.validated = FALSE>
	<cfset LocalValidate.error = FALSE>


	<cfif len(params.key) EQ 56>
		<cfset LocalValidate = model("entrydiscussionsave").validateComment(emailValidationString	= params.key)>

		<cfif LocalValidate.validated>

			<cfset EmailReplies(LocalValidate.entryDiscussionId)>
			<!--- <cfabort> --->

			<!--- Redirect to the blog entry and anchor to the comment. Flash an approved message --->
			<cfset flashInsert(success="Your comment was approved successfully.")>
			<cflocation addtoken="no" url="/blog/#LocalValidate.titleURL###DiscussionId#LocalValidate.entryDiscussionId#">
		</cfif>
	</cfif>

	<cfif LocalValidate.error IS TRUE>
		<cfset title = "Error Validating String">

		<cfset errorMessage = "There was an error on the server trying to validate your email address. Please try again later. I have been emailed the error and I am sorry for any invonvenience.">

	<cfelse>
		<cfset title = "Invalid Validation String">

		<cfset errorMessage = "The validation string you submitted could not be found. Please check you are sending the complete link. Try copying and pasting the link into the browser.">
	</cfif>

	<cfset renderPage(action="invalidvalidation")>

</cffunction>


<cffunction name="RefreshComments" access="public">
	<cfset qBlogDiscussions = model("Entrydiscussion").GetEntryDiscussions(params.id)>

	<cfset renderPartial("entrydiscussions")>
</cffunction>


<cffunction name="RefreshCommentForm" access="public">
	<!---
	http://railo.carlosvazquez.org/blog/RefreshCommentForm?id=
	<cfdump var="#params#">
	<cfabort> --->

	<cfparam default="" name="params.id">

	<cfset NewEntryObject = model("entry").new(	id	= params.id)>
	<cfset NewUserObject = model("user").new()>
	<cfset NewEntryCommentObject = model("entrydiscussion").new()>

	<cfset renderPartial("commentform")>
</cffunction>


<cffunction name="SaveUser" access="public" hint="Submitted through AJAX">
	<cfset var loc = {}>


	<cftransaction>
		<!--- <cfset newUser = model("usersave").create(params.NewUserObject)> --->

		<cfset newUser = model("usersave").new()>
		<cfset newUser.firstName = params.NewUserObject.firstName>
		<cfset newUser.lastName = params.NewUserObject.lastName>
		<cfset newUser.email = params.NewUserObject.email>

		<cfset newUser.cfId = client.cfid>
		<cfset newUser.httpRefererInternal = cgi.HTTP_REFERER>
		<cfset newUser.httpUserAgent = cgi.http_user_agent>
		<cfset newUser.ipAddress = 	cgi.remote_addr>
		<cfset newUser.pathInfo = cgi.path_info>

		<cfset thisSave = newUser.save()>

		<cfif newUser.hasErrors()>
			<cfoutput>#errorMessagesFor(objectName="newUser")#</cfoutput>
			<cfabort>
		</cfif>
	</cftransaction>
</cffunction>


<cffunction name="LatestBlogs" access="private" returnType="query">
	<cfargument name="thisLimit" default="5" type="numeric">

	<cfset var qLatestBlogs = "">

	<cfset qLatestBlogs = model("entry").GetLatestBlogs(thisLimit)>

	<cfreturn qLatestBlogs>
</cffunction>


<cffunction name="LatestDiscussions" access="private" returnType="query">
	<cfset var qLatestDiscussions = "">

	<cfset qLatestDiscussions = model("entrydiscussion").GetLatest()>


	<cfreturn qLatestDiscussions>
</cffunction>


<cffunction name="TopCategories" access="private" returnType="query">
	<cfset var qTopCategories = "">

	<cfset qTopCategories = model("category").findAll(
							select	= "categories.name, categoryurls.name AS nameURL, count(distinct(entrycategories.entryId)) AS entryCount",
							include = "categoryurl,entrycategories(entry)",
							group	= "entrycategories.categoryId",
							order	= "count(distinct(entrycategories.entryId)) desc",
							$limit	= 5)>

	<cfreturn qTopCategories>
</cffunction>


<cffunction name="EmailReplies" access="private" hint="Check if a user replied to an existing discussion and email the discussion users who opted into recieving the replies">
	<cfargument name="entryDiscussionId" required="true" type="numeric">

	<cfset var qUsers = "">

	<cfset qUsers = model("entrydiscussion").GetUsers(arguments.entryDiscussionId)>

	<cfloop query="qUsers">
		<cfmail	to	= "#qUsers.email#"
				from 	= "#Application.AdminEmails.comments#"
				bcc 	= "#Application.AdminEmails.admin#"
				subject	= "CarlosVazquez.org - Reply to #qUsers.title#"
				server	= "localhost"
				type	= "html">
			<p><strong>#qUsers.firstName# #qUsers.lastName#</strong>,</p>

			<p>
			Someone replied to the following Blog entry you subscribed to:<br />
			http://#cgi.server_name#/blog/#qUsers.titleURL#
			</p>

			<p><a href="http://#cgi.server_name#/blog/unsubscribe/#URLEncodedFormat(qUsers.email)#">Click to UNSUBSCRIBE to any further replies from ALL Blog Posts.</p>

			<p><a href="http://#cgi.server_name#/blog/unsubscribe/#URLEncodedFormat(qUsers.email)#/#arguments.entryDiscussionId#">Click to UNSUBSCRIBE to any further replies from JUST THIS Blog Posts.</p>

			<p>This email was sent to #qUsers.email#</p>
		</cfmail>
	</cfloop>

</cffunction>

<cffunction name="Unsubscribe" access="public">
	<cfparam default="" name="params.email">
	<cfparam default="" name="params.entrydiscussionid">

	<!--- <cfoutput>Email = #params.email#</cfoutput> --->

	<!--- <cfdump var="#params#"> --->

	<!--- Check if email address is in our db and message them it's incorrect --->
	<cfquery datasource="#get("DATASOURCENAME")#" name="qCheckUser">
		SELECT count(*) AS exist
		FROM users
		WHERE users.email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#params.email#">
	</cfquery>

	<cfif NOT qCheckUser.exist>
		<cfset title = "Email Address Does Not Exist">
		<cfset renderPage(action="invaliduser")>

	<cfelse>

		<!--- Unsubscribe from replies --->
		<cfquery datasource="#get("DATASOURCENAME")#">
			UPDATE users
			INNER JOIN entrydiscussions ed ON ed.userId = users.id
					<cfif isnumeric(params.entrydiscussionid)>
						AND ed.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#params.entrydiscussionid#">
					</cfif>
			SET ed.wantsReplies = 0
			WHERE users.email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#params.email#">
		</cfquery>

		<cfif isnumeric(params.entrydiscussionid)>
			<cfquery datasource="#get("DATASOURCENAME")#" name="qURL">
				SELECT eu.titleURL
				FROM entrydiscussions ed
				INNER JOIN entryurls eu ON eu.entryId = ed.entryId AND eu.isActive = 1 AND eu.deletedAt IS NULL
				WHERE ed.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#params.entrydiscussionid#">
			</cfquery>

			<cfset flashInsert(success="You are unsubscribed from this Blog Post.")>
			<cflocation addtoken="no" url="/blog/#qURL.titleURL#">
		<cfelse>

			<cfset flashInsert(success="You are unsubscribed from all Blog Posts.")>
			<cflocation addtoken="no" url="/blog/">
		</cfif>
	</cfif>

</cffunction>

<cffunction name="LogVisits" access="private">
	<cftry>
		<cfset model("LogVisit").Save(params)>

	<cfcatch type="ANY">
		<cfdump var ="#cfcatch#">
		<cfabort>

		<cfset EmailError(thisCATCH	= CFCATCH)>
	</cfcatch>
	</cftry>
</cffunction>


<cffunction name="Search" access="public">
	<cfsetting showdebugoutput="false">

	<cfset var LocalSearch = {}>
	<cfset BlogSearch = "">
	<cfset sBlogSearch = "">

	<cfparam default="" name="params.term">

	<cfset qBlogSearch = model("Entry").BlogSearch(params.term)>

	<cfloop query="qBlogSearch">
		<cfsavecontent variable="BlogSearch">
		<cfoutput>
		{"id":"#xmlFormat(qBlogSearch.label)#","label":"#xmlFormat(qBlogSearch.label)#","value":"#xmlFormat(qBlogSearch.value)#"}
		</cfoutput>
		</cfsavecontent>
		<cfset sBlogSearch = ListAppend(sBlogSearch, trim(BlogSearch))>
	</cfloop>

	<cfset renderText("[#sBlogSearch#]")>
</cffunction>

</cfcomponent>