<cfparam name="captchaError" type="boolean" default="false">

<cfoutput>
<div id="CommentBlock">
	#errorMessagesFor("NewEntryCommentObject")#

	#startFormTag(action="", name="CommentSave")#
	<fieldset>
		<legend id="NewCommentLegend">New Comment</legend>
	    #textField(	label		= "First Name",
	    			objectName	= "NewEntryCommentObject",
	    			property	= "firstName",
	    			required	= "required",
	    			appendToLabel	= "<span id='NewEntryCommentObject-firstName-error' class='NewEntryCommentObjectError'></span><br />",
	    			append			= "")#

  			<br /><br />

	    #textField(	label		= "Last Name",
	    			objectName	= "NewEntryCommentObject",
	    			property	= "lastName",
	    			required	= "required",
	    			appendToLabel	= "<span id='NewEntryCommentObject-lastName-error' class='NewEntryCommentObjectError'></span><br />",
	    			append			= "")#
	    <br /><br />

		#textField(	label		= "Email",
					objectName	= "NewEntryCommentObject",
					property	= "email",
					required	= "required",
					appendToLabel	= "<span id='NewEntryCommentObject-email-error' class='NewEntryCommentObjectError'></span><br />",
	    			append			= "",
	    			size			= "50")#
	    <br /><br />

		#textArea(	label		= "Comment",
					objectName	= "NewEntryCommentObject",
					property	= "content",
					prepend		= "<span id='NewEntryCommentObject-content-error' class='NewEntryCommentObjectError'></span><br />",
					rows		= "5",
					required	= "required",
					cols		="40")#<br /><br />

		<!--- #showCaptcha(captchaError=captchaError)#<br /> --->

		<!--- <script type="text/javascript"
			src="http://www.google.com/recaptcha/api/challenge?k=#Application.sReCaptcha.publicKey#">
		</script>
		<noscript>
		   <iframe src="http://www.google.com/recaptcha/api/noscript?k=#Application.sReCaptcha.publicKey#"
		       height="300" width="500" frameborder="0"></iframe><br>
		   <textarea name="recaptcha_challenge_field" rows="3" cols="40">
		   </textarea>
		   <input type="hidden" name="recaptcha_response_field"
		       value="manual_challenge">
		</noscript> --->

	    <!--- #select(
	        label="State", objectName="state", property="stateId",
	        options=states
	    )# --->

		#checkBox(	label			= "Email me replies to this thread",
					objectName		= "NewEntryCommentObject",
					property		= "wantsReplies",
					labelPlacement	= "after")#<br /><br />

	   <div>
	        #hiddenField(	objectName	= "NewEntryObject",
	        				property	= "id")#

	        #hiddenField(	objectName	= "NewEntryCommentObject",
	        				property	= "entryDiscussionId",
	        				id			= "entryDiscussionId")#

	        #submitTag(	value	= "Post Comment",
	        			id		= "CommentSubmitButton")#
	    </div>

	</fieldset>
	#endFormTag()#
</div>
<beforeCommentFormDebug>
</cfoutput>