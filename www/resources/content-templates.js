var templates = document.getElementsByTagName('img');
var myarray = new Array();

for (var i=0; i<templates.length; i++){
    var template = templates[i];
    if ( template.getAttribute("rel") == "content_templates"){
        myarray.push(template);
        template.onmouseover = function() { showTooltip(this);}
        template.onmouseout = function() { hideTooltip(this);}
    }
}
var myTooltip = new YAHOO.widget.Tooltip("myTooltip", {context: myarray, autodismissdelay: 10000} );
function showTooltip( obj ){
    try{
        var tooltip_img = document.createElement('img');
        tooltip_img.src = obj.src;
        myTooltip.cfg.setProperty("text",tooltip_img);
    } catch(e) {}
}
function hideTooltip(){
    try{
    myTooltip.cfg.setProperty("text","");
    } catch(e) {}
}
