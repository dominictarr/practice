$(function(){
//jQuery document ready.
	window.status = 'HELLO STATUS BAR!'
$('body').append("<div id='log'></div>")
function log(string){
	$('#log').append(string + '<br>')

}
//when nudy_editable is updated, push changes to the server.
$('.nudy_editable').change(function() {
	var data = {ID: this.form.id}
	data[this.name] = this.value
	log (this.name + ' = ' this.value)
	window.status = data
$.get("update", 
	data,
   function(data){
	window.status = data;
   });
});

});
