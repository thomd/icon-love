$(function(){
    
    // add click event on 'Add Icon' link to open form below
    $("#add-icon a").click(function(ev){
        ev.preventDefault();
        $(this).addClass("selected");
        if($("#add").length == 0){
            $(this).parent().append("<div id='add'></div>")
            $("#add").append("<img src='img/loader.gif' />").load("/add");
        } 
    });
    
    
});
