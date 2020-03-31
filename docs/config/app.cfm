<cfscript>
	// Use this file to set variables for the Application.cfc's "this" scope.

	// Examples:
	// this.name = "MyAppName";
	// this.sessionTimeout = CreateTimeSpan(0,0,5,0);

	// Just to make our test suite pass for now.
 	// this.disableEngineCheck = true;

	this.name = "AdventuresOfCarlos";
	this.ClientManagement = true;
	this.ClientStorage = "mybloginsert";
	THIS.SessionManagement = true; // Session variables need to be on for captcha to work
</cfscript>
