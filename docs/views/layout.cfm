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
						<script data-ad-client="ca-pub-5924586772427688" async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
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
					<a href="/blog/category/Random-Ramblings">Random&nbsp;Stuff</a>
					<a href="/blog/category/Website-Development">Website Development</a>
					<a href="/blog/category/Portfolio">Portfolio</a>
					<span class="ExternalLinks">
						<a href="https://github.com/cvazquez" target="Github-cvazquez">Github <svg class="octicon octicon-mark-github" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" d="M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27.68 0 1.36.09 2 .27 1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.013 8.013 0 0016 8c0-4.42-3.58-8-8-8z"></path></svg></a>| <a href="https://www.linkedin.com/in/carlos-vazquez-a5067bb" target="carlos-vazquez-a5067bb">LinkedIn</a></span>
				</div>
			</div>

			<div id="HeaderAdLinkUnit">
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