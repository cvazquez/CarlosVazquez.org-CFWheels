<cfparam default="FALSE" name="doNotIndex" type="Boolean">
<cfparam default="#[]#" name="breadCrumbArray" type="array">
<cfparam default="" name="breadCrumbCurrent">
<cfparam default="FALSE" name="showHeaderSlideShow" type="boolean">

<!DOCTYPE html>
<html>
<head>
<!--
 * All Code Written by Carlos Vazquez for carlosvazquez.org
 * You may copy any or all code without written consent, but referencing my site and I would be nice
-->
<title><cfoutput>#title#</cfoutput></title>
<cfif doNotIndex IS TRUE>
	<meta name="robots" content="noindex" />
</cfif>
<cfoutput>
		#styleSheetLinkTag("index")#<br />
</cfoutput>
<link rel="stylesheet" href="http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css">
<script src="http://code.jquery.com/jquery-1.9.1.js"></script>
<script src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>

<cfoutput>#javaScriptIncludeTag("/blog/main")#</cfoutput>
<cfif get("environment") is "production">
<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-41839649-1', 'carlosvazquez.org');
  ga('send', 'pageview');
</script>
</cfif>
</head>
	<body>
		<div id="SiteContainer">
			<div id="HeaderContainer">
				<div id="HeaderLogoContainer">&nbsp;</div>
				<div id="HeaderAdContainer"><!--- <img src="/images/samplead.gif" border="1"> --->
					<cfif get("environment") is "production">
						<script type="text/javascript"><!--
						google_ad_client = "ca-pub-4772985754168821";
						/* HeaderAdContainer */
						google_ad_slot = "1771136707";
						google_ad_width = 728;
						google_ad_height = 90;
						//-->
						</script>
						<script type="text/javascript"
						src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
						</script>
					</cfif>
				</div>
			</div>
			<div id="HeaderSmallLinksContainer">
				<div id="HeaderSmallLinksGradient" class="HeaderLinksGradient"></div>
				<div id="HeaderSmallLinksText">
					<a href="/blog">Home</a>
					<a href="/blog/About-Me">About</a>
					<a href="/blog/Contact-Me">Contact</a>
				</div>
			</div>
			<div id="HeaderSearchBoxContainer">
				<div class="ui-widget">
				  <input id="HeaderSearchBox" placeholder="search & enter">
				</div>
			</div>

			<div id="HeaderMainLinksContainer">
				<div id="HeaderMainLinksGradient"></div>
				<div id="HeaderMainLinksText">
					<a href="/blog/category/Travel">Travel</a>
					<a href="/blog/category/Fitness-And-Health">Fitness/Health</a>
					<!--- <a href="/blog/category/Recipies">Recipies</a>
					<a href="/blog/category/development">Development</a>
					<a href="/blog/category/reviews">Reviews</a> --->
					<a href="/blog/category/Random-Ramblings">Random&nbsp;Stuff</a>
					<a href="/blog/category/Website-Development">Website Development</a>
					<a href="/blog/category/Portfolio">Portfolio</a>
				</div>
			</div>

			<div id="HeaderAdLinkUnit">
				<cfif get("environment") is "production">
					<!--- Ads by Google --->
					<script type="text/javascript">
						<!--
						google_ad_client = "ca-pub-4772985754168821";
						/* HeaderAdLinkUnit */
						google_ad_slot = "6340937107";
						google_ad_width = 468;
						google_ad_height = 15;
						//-->
					</script>
					<script type="text/javascript" src="http://pagead2.googlesyndication.com/pagead/show_ads.js"></script>
				</cfif>
			</div>


			<cfif NOT ArrayIsEmpty(breadCrumbArray) OR breadCrumbCurrent NEQ "">
			<ul class="breadcrumb">
				<cfoutput>
					<cfloop array="#breadCrumbArray#" index="bCA">
						<li><a href="#listFirst(bCA, '|')#">#listLast(bCA, '|')#</a> <span class="divider">/</span></li>
					</cfloop>

					<cfif breadCrumbCurrent NEQ "">
						<li class="active">#breadCrumbCurrent#</li>
					</cfif>
				</cfoutput>
			</ul>
			</cfif>

			<cfif showHeaderSlideShow>
				<div id="HeaderSlideShowContainer">
					<div id="HeaderSlideShowImage">
						<img src="/images/slideshows/cat1.jpg" border="0">
					</div>
				</div>
			</cfif>

			<div id="MainContentContainer">
			<cfoutput>#includeContent()#</cfoutput>
			</div>
		</div>
	</body>
</html>