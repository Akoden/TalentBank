<script type="text/javascript">
    //function to load content from url (surl) and display it in div(scontent)
	display = function(surl,scontent) 
	{

		$.ajax
		( 
		{
			type :"GET",
			url :surl,
			data :"",
			success : function(msg) {

				$(scontent).html(msg);
		}
		}
		);

	};
</script>
<h1></h1>
<center>

<div id="tabs1">
<ul>
	<li><a href="#content1">accept message</a></li>
	<li><a href="#content2">reject message</a></li>
	<li><a href="#content3">Job categories</a></li>
	

</ul>
<div id="content1">
    <iframe src="accept.jsp" width="100%"  height="500" style="border: none;"></iframe>
</div>
<div id="content2">
<iframe src="reject.jsp" width="100%" height="500" style="border: none;"></iframe>
</div>
<div id="content3">
<div id="div_jobs"></div>

<script type="text/javascript">
   display("jobs.html.jsp","#div_jobs");
</script></div>
</div>


<script type="text/javascript">
//jquery maggic tabs script
var target = jQuery('div#tabs1'); 
target.tabs({event:'click'});
</script>
</center>
