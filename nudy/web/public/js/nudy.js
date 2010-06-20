$(function(){
//jQuery document ready.
	window.status = 'HELLO STATUS BAR!'
//when nudy_editable is updated, push changes to the server.
$('.nudy_editable').change(function() {
	//var d = this.name + ' => ' + this.value +'\n' + this.form.id
	
	//alert (d)
	var data = {ID: this.form.id}
	data[this.name] = this.value
	window.status = data
$.get("update", 
	data,
   function(data){
	window.status = data;
   });
});

});
