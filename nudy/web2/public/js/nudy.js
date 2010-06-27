$(function(){
//jQuery document ready.
	window.status = 'HELLO STATUS BAR!'
$('body').append("<div id='log'></div>")
function log(string){
	$('#log').append(string + '<br>')

}
//when nudy_editable is updated, push changes to the server.
$('.nudy_editable').change(function() {
	form_id = $(this).parents('.nudy_form').attr('id')
	//.attr('background-color','red')
	//.parent('.nudy_form').attr('id')
	var data = {ID: form_id}
	data[this.name] = this.value
	log ('(' + form_id + ').' + this.name + ' = ' + this.value)
	window.status = data
$.get("update", 
	data,
   function(data){
	window.status = data;
   });
});

});
