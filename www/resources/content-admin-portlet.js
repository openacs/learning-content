
var load_img = document.createElement('img');
load_img.id = 'indicator';
load_img.src = '/resources/learning-content/indicator.gif';


function copy_request(src_cid,dst_cid,dst_url,tag,copy_msg) {

	var container = document.getElementById(tag);
	var new_link = document.createElement('a');
	new_link.innerHTML = copy_msg;
	new_link.target = '_blank';
	new Ajax.Request('content/admin/copy_content?src_community_id='+src_cid+'&dst_community_id='+dst_cid, 
		{method: 'get', 
		onLoading:  function(){ container.appendChild(load_img); }, 
		onComplete: function(){ container.removeChild(load_img); }, 
		onSuccess:  function(){ new_link.href = dst_url+'content/'; container.removeChild(container.lastChild.previousSibling); container.appendChild(new_link); } 
		});

}