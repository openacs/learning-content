var tree;
var current_object_id = 0;
var dynamic_tree_url = "dynamic-tree";
var load_img = document.createElement('img');
load_img.id = 'indicator';
load_img.src = '/resources/learning-content/indicator.gif';

function treeInit(root_name, root_id) {
   tree = new YAHOO.widget.TreeView("dynamic_tree_div");
   tree.setDynamicLoad(loadDataForNode);

   var root = tree.getRoot();
   var myobj = { label: root_name, id:root_id } ;
   var tmpNode = new YAHOO.widget.TextNode(myobj, root, true);
   tree.draw();

}

function newUnit(tree_id) {
    new Ajax.Request('category-add-edit?tree_id='+tree_id+'&name=unit&mode=3',{method: 'get', onSuccess: function(){ document.location.reload();  } });
}

function addNode(tree_id, parent_id) { 
    new Ajax.Request('category-add-edit?tree_id='+tree_id+'&parent_id='+parent_id+'&mode=2&name=Nueva_Seccion',{method: 'get', onSuccess: function(response){ window.location.reload();}});
}

function removeMyNode(node_id, tree_id, category_id, category_delete_alert_msg) {
    var tag = document.getElementById('form_'+node_id);
    new Ajax.Request('category-delete?tree_id=' + tree_id + '&category_id=' + category_id,{method: 'get', onLoading: function(){ tag.appendChild(load_img); }, onComplete: function () { }, onSuccess: function(r){ tag.innerHTML = ''; if (r.responseText == 1) { tree.removeNode(tree.getNodeByProperty('id',node_id),true); } else { alert(category_delete_alert_msg); } }});

}
function addEditor(id, tree_id, category_id) {
    var tag_id = 'input_'+id;
    var tmp_input = document.createElement('input');
    tmp_input.id = tag_id;
    var tag = document.getElementById('form_'+id);
    tag.innerHTML = '';
    tag.appendChild(tmp_input);
    tmp_input.focus();
    var save = document.createElement('input');
    save.setAttribute('type','submit');
    save.setAttribute('style','font-size: 10px;');
    save.onclick = function () {
    var url = 'category-add-edit?tree_id='+tree_id+'&category_id='+category_id+'&name='+encodeURIComponent(tmp_input.value);
    new Ajax.Request(url,{method: 'get', onLoading: function () { tag.appendChild(load_img); }, onComplete: function () { tag.removeChild(load_img); tag.innerHTML = ''; }, onSuccess: function(response){
		tree.getNodeByProperty('id',id).getLabelEl().innerHTML = tmp_input.value+' '; document.getElementById('form_'+id).innerHTML = ''}
	} ); }
    save.value = save_msg;
    tag.appendChild(document.createTextNode('  '));
    tag.appendChild(save);
    var cancel = document.createElement('input');
    cancel.setAttribute('type','submit');
    cancel.setAttribute('style','font-size: 10px;');
    cancel.value = cancel_msg;
    cancel.onclick = function () { tag.innerHTML = ''; }
    tag.appendChild(document.createTextNode('  '));
    tag.appendChild(cancel);
}

function addRequest (url, name, id) {
    new Ajax.Request( url+name, {method: 'get', onSuccess: function(){
    window.location.reload(); } });
}

var tree_folders_array = new Array();

function loadDataForNode(node, onCompleteCallback) {

    var id= node.data.id;

    if  (typeof( window[ 'folder_id' ] ) != "undefined" ) {
        tree_Url = dynamic_tree_url+"?category_id="+id+"&folder_id="+folder_id;
    } else {
        tree_Url = dynamic_tree_url+"?category_id="+id;
    }

    var handleSuccess = function(o)  {
        if(o.responseText !== undefined) { 
            if (o.responseText.length == 0 ) {
                document.writeln("<script>new Ajax.InPlaceEditor('form_'+id,'/');</script>");
                onCompleteCallback();
            }
            var name_id_pairs = o.responseText.split(';');

            if (name_id_pairs !== undefined ) {
                for (var i =0; i < name_id_pairs.length ; i++) {
                    var fdata = name_id_pairs[i].split(',');
                    var fname = fdata[0];
                    var fid = fdata[1];
                    var is_cat = fdata[2];
                    var existe = tree.getNodeByProperty('id',fid);

                    if (fid !== undefined) {					
                        if (existe == undefined) {
                            var myobj = { label: fname, id:fid } ;
                            if (is_cat == "true") {
                                var tmpNode = new YAHOO.widget.TextNode(myobj, node, false);
                            } else {
                                var object_url = fdata[3];
                                if (current_object_id == fid) {
                                    var link_text = "<a href="+object_url+" > <b>" + fname + "</b></a>";
                                } else {
                                    var link_text = "<a href="+object_url+" > " + fname + "</a>";
                                }
                                var tmpNode = new YAHOO.widget.HTMLNode(link_text, node, false, false);
                            }	
                        }
                    }
                }
            }
        // Be sure to notify the TreeView component when the data load is complete
            onCompleteCallback();
        }
    }
    var handleFailure = function(o) {
        if(o.responseText !== undefined) {
            onCompleteCallback();
        }
    }

    var callback = {
        success:handleSuccess,
        failure: handleFailure
    };
    var transaction = YAHOO.util.Connect.asyncRequest('GET', tree_Url, callback, null);

}
    function encode(string) {
        string = string.replace(/\r\n/g,"\n");
        var utftext = "";

        for (var n = 0; n < string.length; n++) {

            var c = string.charCodeAt(n);

            if (c < 128) {
                utftext += String.fromCharCode(c);
            }
            else if((c > 127) && (c < 2048)) {
                utftext += String.fromCharCode((c >> 6) | 192);
                utftext += String.fromCharCode((c & 63) | 128);
            }
            else {
                utftext += String.fromCharCode((c >> 12) | 224);
                utftext += String.fromCharCode(((c >> 6) & 63) | 128);
                utftext += String.fromCharCode((c & 63) | 128);
            }
        }
        return utftext;
    }