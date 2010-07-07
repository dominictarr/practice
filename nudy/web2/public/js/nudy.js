$(function(){
//add a log for debugging to bottom of screen.
$('body').append("<div id='log'></div>")
function log(string){
	$('#log').append(string + '<br>')
}
function assign(id1,value){
	var data = {}
	data[id1] = value
	log(id1 + "=" + value)
	$.get("update", data,
	   function(xml){
		//log(data)
		log('ajax1')
		$(xml).find("item").each(function(){
			ID = this.id
			//$(this).attr('id')
			log('ajax:' + ID + ' = ' + $(this).text())
			$('#field_' + ID).attr('value',$(this).text())
		});
	});
}

//when nudy_editable is updated, push changes to the server.
$('.nudy_editable').change(function() {
	form_id = $(this).parent().attr('id')
	log ('(' + form_id + ')' + this.name + ' = ' + this.value)
	assign(form_id,this.value)
});

var dragClass = '.nudy'// + ',.nudy_form'
var dragObject = null
$('body').append("<div id='log'></div>")

document.onMouseMove = mouseMove; 
$(dragClass).mousedown(function(){
	log("mouse down" + this.id + "<br>")
	log('nudy_id==' + $(this).attr('nudy_id'))

	dragObject = this
//	return false;
});
$(dragClass).mouseup(function(ev) {
	assign(this.id,dragObject.id)
	$('#log').append("mouse up -- " + dragObject.id + ' onto ' + this.id + "<br>")
});

function mouseUp(ev){ 
	dragObject = null
}

function mouseMove(ev){ 
	ev = ev || window.event; 
        return false; 
	} 


});


