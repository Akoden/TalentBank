/**
 * function to show a confirmation message box
 * @param textMessage : the content to display in the box
 * @param yesFunction : the function to execute when click on yes
 * notice that you should have a div with ID=ConfirmDialog in the page and include jquery,jquery ui javascript
 * and ixedit sample css file
 */
showConfirm=function(textMessage,yesFunction)
{
	
	//alert(yesFunction);
	
	$('#divConfirmDialog').removeClass("invisible");
	$('#divConfirmDialog').html(textMessage);
	var target = jQuery('div#divConfirmDialog');
	
	if (!target.dialog('isOpen')) {
		target.dialog( {
			autoOpen :false,
			bgiframe :true,
			modal :true,
			resizable :false,
			width :200,
			height :100,
			minHeight:100,
			position : [ 'center', 'center' ],
			draggable :true,
			buttons:
			{
			"yes" :yesFunction,
			"no" :function()
				 {
				$(this).dialog("close");
				 }
			}

		})
	}
	;
	target.show();
	target.dialog('open');
}


/**
 * function to show a waiting message when a lenghty operation is laucnhed
 */
showWaiting=function(event, ui) 
{
	$('#waiting_message').removeClass("invisible");
	var target = jQuery('div#waiting_message');
	target.show();
	if (!target.dialog('isOpen')) 
	{
		target.dialog
	  ( 
	  {
			autoOpen :false,
			bgiframe :true,
			modal :true,
			resizable :false,
			width :200,
			height :200,
			position : [ 'center', 'center' ],
			draggable :true,

	 })
   }
	;
	target.dialog('open');
};

//close the waiting message
closeWaiting=function(event, ui) 
{
	    	var target = jQuery('div#waiting_message');
	    	target.dialog('close');
			
}

/**
 * function to show a message box
 * @param widthP : width of the box
 * @param heightP:height of the box
 * @param message : message to display in the box
 */
showPopup=function(withdP,heightP,delay,message)
		{
			$('#popMessage').removeClass("invisible");
			$('#popMessage').html(message);
			var target = jQuery('div#popMessage');
			target.show();
			if (!target.dialog('isOpen')) 
			{
				target.dialog(
				{
					autoOpen :false,
					bgiframe :true,
					modal :true,
					resizable :false,
					width :withdP,
					height :heightP,
					minHeight:heightP,
					position : [ 'center', 'center' ],
					draggable :true,

				})
			}
			;
			target.dialog('open');
			
		}

//close a popup
closePopUp=function(delay)
{
			
	$("#popMessage").fadeOut
	(delay,
	    function()
		{
		  var target = jQuery('div#popMessage');
		  target.dialog('close');
		}
	);
			
}