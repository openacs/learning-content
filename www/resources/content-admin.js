var load_img = document.createElement('img');
load_img.id = 'indicator';
load_img.src = '/resources/learning-content/indicator.gif';
var copy_content_tag;
var new_link;
var copy_success_msg;

function copy_request(src_cid,dst_cid,dst_url,tag,copy_msg,error_msg,success_msg) {
    copy_content_tag = tag;
    copy_success_msg = success_msg;
    var container = document.getElementById(tag);
    new_link = document.createElement('a');
    new_link.innerHTML = copy_msg;
    new_link.target = '_blank';
    new Ajax.Request('copy_content?src_community_id='+src_cid+'&dst_community_id='+dst_cid,
		     {method: 'get',
			     onLoading:  function(){ container.removeChild(container.lastChild); container.appendChild(load_img); },
			     onComplete: function(){ },
			     onSuccess:  function(r){
			     if ( r.responseText == "1") {
				 new_link.href = dst_url+'learning-content/';
				 setTimeout("handleSuccess()", 4000);
			     } else {
				 container.removeChild(load_img);
				 alert(error_msg);
			     }}
		     });

}

function handleSuccess() {
    var container = document.getElementById(copy_content_tag);
    container.removeChild(load_img);
    container.appendChild(new_link);
    alert(copy_success_msg);
}