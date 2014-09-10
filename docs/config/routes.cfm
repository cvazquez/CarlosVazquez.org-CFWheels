<!---
	Here you can add routes to your application and edit the default one.
	The default route is the one that will be called on your application's "home" page.
--->
<!--- <cfset addRoute(name="home", pattern="", controller="wheels", action="wheels")>
	<cfset addRoute(name="home", pattern="", controller="home", action="index")>
 --->
<!--- <cfset addRoute(name="home", pattern="", controller="blog", action="index")> --->
<!--- <cfset addRoute(name="home", pattern="", controller="wheels", action="wheels")> --->
<!--- <cfset addRoute(name="Blog", pattern="/blog/[category]", controller="blog", action="index")> --->
<!--- <cfset addRoute(name="home", pattern="", controller="blog", action="index")>  --->

<!--- <cfset addRoute(name="videoList", pattern="video/list/[key]", controller="video", action="index")> --->

<cfset addRoute(name="home", pattern="", controller="home", action="index")>
<!--- <cfset addRoute(name="home2", pattern="/", controller="home", action="index")> --->
<cfset addRoute(name="notfound", pattern="", controller="home", action="notfound")>

<cfset addRoute(name="Category", pattern="/blog/category/[categoryName]", controller="blog", action="category")>
<cfset addRoute(name="Categories", pattern="/blog/categories", controller="blog", action="categories")>
<cfset addRoute(name="SaveComment", pattern="/blog/save-comment", controller="blog", action="SaveComment")>
<cfset addRoute(name="RefreshComments", pattern="/blog/refresh-comments", controller="blog", action="RefreshComments")>
<cfset addRoute(name="RefreshCommentForm", pattern="/blog/refresh-comment-form", controller="blog", action="RefreshCommentForm")>
<cfset addRoute(name="Validate", pattern="/blog/validate/[key]", controller="blog", action="validate")>
<cfset addRoute(name="Unsubscribe", pattern="/blog/unsubscribe/[email]/[entrydiscussionid]", controller="blog", action="unsubscribe")>
<cfset addRoute(name="Unsubscribe", pattern="/blog/unsubscribe/[email]", controller="blog", action="unsubscribe")>
<cfset addRoute(name="OldIndexPage", pattern="/blog/index\.cfm", controller="home", action="index")>
<cfset addRoute(name="CacheFlickrAll", pattern="/blog/cache-flickr-all", controller="blog", action="CacheFlickrAll")>
<cfset addRoute(name="CacheFlickrAll", pattern="/blog/cache-yelp-reviews", controller="blog", action="CacheYelpReviews")>
<cfset addRoute(name="PictureRedirect", pattern="/blog/picture-redirect/[pictureUrl]", controller="blog", action="PictureRedirect")>
<cfset addRoute(name="PictureRedirectSize", pattern="/blog/picture-redirect/[pictureUrl]/[size]", controller="blog", action="PictureRedirect")>
<cfset addRoute(name="BlogSearch", pattern="/blog/search", controller="blog", action="search")>

<cfset addRoute(name="Entry", pattern="/blog/[title]", controller="blog", action="entry")>