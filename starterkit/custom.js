 $(function() {

//jQuery(document).ready(function() {
	// do something here
   $("#orderedlist").addClass("red");

   $("li").hover(function() {
     $(this).addClass("green");
   },function(){
     $(this).removeClass("green");
   });

   $("#orderedlist2").find("li").each(function(i) {
     $(this).append( " BAM! " + i );
   });

   $("li").not(":has(ul)").css("border", "1px solid black"); 

   $("a[name]").css("background", "#aaa" );

   $("a[href*=starter]").hover(function() {
	$(this).addClass("blue");
	//alert("hello")
     // do something with all links that point somewhere to /content/gallery
   });
 
   $('#faq').find('dd').hide().end().find('dt').click(function() {
     $(this).next().slideToggle("fast");
   });


   $("a").hover(function(){
     $(this).parents("p").addClass("highlight");
   },function(){
     $(this).parents("p").removeClass("highlight");
   });
 });

