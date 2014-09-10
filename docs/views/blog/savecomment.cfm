<cfoutput>
<cfif newComment.hasErrors()>
	#errorMessagesFor("newComment")#
<cfelse>
{"commentId":#newComment.id#}<splithere>
</cfif>
</cfoutput>