<cfscript>

	// Use this file to add routes to your application and point the root route to a controller action.
	// Don't forget to issue a reload request (e.g. reload=true) after making changes.
	// See http://docs.cfwheels.org/docs/routing for more info.

	mapper()
		// The "wildcard" call below enables automatic mapping of "controller/action" type routes.
		// This way you don't need to explicitly add a route every time you create a new action in a controller.
		//.wildcard()

		// The root route below is the one that will be called on your application's home page (e.g. http://127.0.0.1/).
		// You can, for example, change "wheels##wheels" to "home##index" to call the "index" action on the "home" controller instead.
		.root(to="home##index", method="get")
		.get(name="Category", pattern="/blog/category/[categoryName]", controller="blog", action="category")
		.get(name="Categories", pattern="/blog/categories", controller="blog", action="categories")
		.get(name="Blog", controller="blog", action="index")
		.get(name="notfound", pattern="", controller="home", action="notfound")
		.post(name="SaveComment", pattern="/blog/save-comment", controller="blog", action="SaveComment")
		.get(name="RefreshComments", pattern="/blog/refresh-comments", controller="blog", action="RefreshComments")
		.get(name="RefreshCommentForm", pattern="/blog/refresh-comment-form", controller="blog", action="RefreshCommentForm")
		.get(name="Validate", pattern="/blog/validate/[key]", controller="blog", action="validate")
		.get(name="Unsubscribe", pattern="/blog/unsubscribe/[email]/[entrydiscussionid]", controller="blog", action="unsubscribe")
		.get(name="Unsubscribe", pattern="/blog/unsubscribe/[email]", controller="blog", action="unsubscribe")
		.get(name="OldIndexPage", pattern="/blog/index\.cfm", controller="home", action="index")
		.get(name="CacheFlickrAll", pattern="/blog/cache-flickr-all", controller="blog", action="CacheFlickrAll")
		.get(name="CacheFlickrAll", pattern="/blog/cache-yelp-reviews", controller="blog", action="CacheYelpReviews")
		.get(name="PictureRedirect", pattern="/blog/picture-redirect/[pictureUrl]", controller="blog", action="PictureRedirect")
		.get(name="PictureRedirectSize", pattern="/blog/picture-redirect/[pictureUrl]/[size]", controller="blog", action="PictureRedirect")
		.get(name="BlogSearch", pattern="/blog/search", controller="blog", action="search")
		.get(name="entry", pattern="/blog/[title]", to="blog##entry")
	.end();
</cfscript>