/*
 * All Code Written by Carlos Vazquez for carlosvazquez.org
 * You may copy any or all code without written consent, but referencing my site and I would be nice
 */

var debug = false;

if (document.domain == "www.carlosvazquez.org") debug = false;

function DisplayComment(DiscussionId, thisComment)
{
	// Refresh all comments by Hiding all Cancel text, then show all reply texts
	$(".BlogCommentUserCommentCancelText").hide();
	$(".BlogCommentUserCommentReplyText").hide();


	// Move the comment box from its current position to the Reply text just clicked on
	$(thisComment).next(".BlogCommentUserAddCommentBlock").append($("#CommentBlock"));

	// Set the DiscussionId for this comment
	$("#entryDiscussionId").attr(	{
										"value"	: DiscussionId
									});

	// Hide the current Reply text
	$(thisComment).hide();

	// Show the Cancel Reply text, that is before the select comment
	$(thisComment).prev(".BlogCommentUserCommentCancelText").show();


	$("#NewCommentLegend").text("Add Reply");

	$("#CommentSubmitButton").attr(	{	"value" : "Reply"	}	);
}


// When a comment or reply to a comment is submitted, the entire comments section is refreshed with the new comment included
function RefreshComments(formEntryId, discussionId)
{
		$.ajax({
		  		url:	'/blog/refresh-comments',
		  		type:	"POST",
		  		data:	{	id	: formEntryId },
		  		success:	function(data)
		  					{
		    					$('#DiscussionBlock').html(data.split("<beforeDebug>")[0]);

		    					window.location.hash="DiscussionId" + discussionId;
		  					}
		});


	$.ajax({
		  		url:	'/blog/refresh-comment-form',
		  		type:	"POST",
		  		data:	{	id	: formEntryId },
		  		success:	function(data)
		  					{
		    					$('#CommentBlockContainer').html(data.split("<beforeCommentFormDebug>")[0]);
		  					}
		});

}



$(function()
{
  $("#CommentSubmitButton").click(function(e) {
		e.preventDefault();

  		var formEntryId				= document.getElementById("NewEntryObject-id").value;
	  		//Captcha
  			/* formRecaptchaResponseField = document.getElementById("recaptcha_response_field").value,
  			formRecaptchaChallengeField = document.getElementById("recaptcha_challenge_field").value; */

		if (debug) alert("id of recaptcha_response_field = " + document.getElementById("recaptcha_response_field").value)

		$.ajax({
		  		url:	'/blog/save-comment',//?format=json
		  		type:	"POST",
		  		data:	{
		  					NewEntryCommentObject:	{
		  												content				: document.getElementById("NewEntryCommentObject-content").value,
		  												firstName			: document.getElementById("NewEntryCommentObject-firstName").value,
		  												lastName			: document.getElementById("NewEntryCommentObject-lastName").value,
		  												email				: document.getElementById("NewEntryCommentObject-email").value,
		  												entryDiscussionId	: document.getElementById("entryDiscussionId").value,
														wantsReplies		: document.getElementById("NewEntryCommentObject-wantsReplies").value
		  											},
		  					NewEntryObject	:	{
		  											id	: formEntryId
			  									},
							authenticityToken	: document.getElementById("authenticityToken").value
							/* ,
		  					recaptcha_response_field	:     formRecaptchaResponseField,
		  					recaptcha_challenge_field	:     formRecaptchaChallengeField */
		  				},

		  		success:	function(data)
		  					{

								if ( eval(data) )
								{
									var returnObject	= data,
										x				= 0,
										errorMessage	= "";



									if(returnObject.id)
									{
										// If returnObject.id exists, then the comment was successfully submitted and a valid comment id was returned

										// Put this in an overlay
										alert("Your comment is successfully saved, but I have sent you a confirmation email. If you DO NOT click on the email's link to confirm you are who you say you are, then this comment will deactivate in 24 hours.");

										RefreshComments(formEntryId, returnObject.id);

										//Remove the comment form fields values
										$("[id^='NewEntryCommentObject-']").each(function(index)
											{
												$(this).val("");
											}
										);

										//Recaptcha.reload();

									}
									/* else if (returnObject.captchaError)
									{
										if (debug) alert(returnObject.captchaError);
										alert("Captcha Failed. Try again");
									} */
									else if ( returnObject[0].property )
									{
										// If returnObject[0].property exists, then errors were returned

										//Clear any existing error messages next to fields
										$(".NewEntryCommentObjectError").each(function(index)
											{
												$(this).text("");
											}
										);

										for (x = 0; x < returnObject.length; x++)
										{
											errorMessage = errorMessage + "* " + returnObject[x].message + "\n";


											// Display error messages next to fields
											if( $("#NewEntryCommentObject-" + returnObject[x].property + "-error") && $("#NewEntryCommentObject-" + returnObject[x].property + "-error").text() == "" )
											{
												$("#NewEntryCommentObject-" + returnObject[x].property + "-error").text(" " + returnObject[x].message);
											}
										}

										// Eventually put this in an overlay
										alert("Your are missing the following:\n\n" + errorMessage);
									}
								}

		  					}
		});
  });



// Toggle the moving of the comment box from commenting on the blog or replying to an existing blog comment.
  $(".BlogCommentUserCommentCancelText").click(function(e) {

  		// Move the comment form back to the bottom of the discussions list
		$("#CommentBlockContainer").append($("#CommentBlock"));


		// Remove the discussion id, since this is not a new comment that isn't replying to another comment
		$("#entryDiscussionId").attr(	{
											"value"	: ''
										});

		// Show all the Reply to links again
		$(".BlogCommentUserCommentReplyText").show();

		// Hide any canceled comment text within previous replies
		$(".BlogCommentUserCommentCancelText").hide();

		// Change the Legend title from Add Reply
		$("#NewCommentLegend").text("New Comment");

  });

  	// When a thumbnail on a blog entry is clicked, replace the regular size image with that thumbnail's regular size image
	$(".SlideShowThumbNail").click(function(e)
	{

		if (debug)
		{
			console.dir(this);
			console.dir(this.attributes.imagethumbnailid.value);
			console.dir(this.attributes.ImageRegularSrc.value);
		}

		// Setting the <img> attributes for the new Regular image
		imageRegularSrc = this.attributes.ImageRegularSrc.value;
		imageRegularAlt = this.attributes.ImageRegularAlt.value;
		imageRegularHeight = this.attributes.ImageRegularHeight.value;
		imageRegularWidth = this.attributes.ImageRegularWidth.value;

		// Create the new Regular image tag, with the attributes from the thumbnail clicked
		var tempImage = '<img id="ImageRegular" src="' + imageRegularSrc + '" alt="' + imageRegularAlt + '" title="' + imageRegularAlt + '" height="' + imageRegularHeight+ '" width="' + imageRegularWidth + '">';

		if (debug) console.dir(tempImage);

		// Pre- load the image
		$(tempImage).load();

		// Replace the current image with this one
		$("#ImageRegular").replaceWith(tempImage);


		$("#ImageTitle").text(imageRegularAlt);

	});

});