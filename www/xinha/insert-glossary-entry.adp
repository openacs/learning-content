<html style="width: 600px; height: 150px">
<head>
  <title>#learning-content.glossary#</title>

  <script type="text/javascript" 
	  src="/resources/acs-templating/xinha-nightly/popups/popup.js">
  </script>
<script type="text/javascript" src="/resources/ajaxhelper/prototype/prototype.js"></script> 
<script type="text/javascript" src="/resources/ajaxhelper/scriptaculous/scriptaculous.js"></script> 
<script type="text/javascript" src="/resources/learning-content/get-glossary-word.js"></script> 

<script type="text/javascript">
	var selector_window;
	window.resizeTo(600, 150);
	
    function Init() {
	  __dlg_init();
    try{
// f_word is the selected text
// edit_mode is used to know when we are inserting a new word or editing an existing one
	  var param = window.dialogArguments;
	  if (param) {
	      document.getElementById("f_word").value = param["f_word"];
	      document.getElementById("f_def").value = param["f_def"];
              document.getElementById("f_href").value = param["f_href"];
              document.getElementById("edit_mode").value = param["edit_mode"];
	  }
        if ( param["edit_mode"] ==  1 ) {
// Show the Unlink button
            document.getElementById("unlink").style.display = 'block';
            document.getElementById("word_name").value = param["f_word"];
// Get the description because we are on edition mode
            new Ajax.Request('@package_url@get-glossary-word?word='+param["f_word"]+'',
                {method: 'get', 
                onSuccess: function (r){ 
                    document.getElementById('f_def').value = r.responseText;  } });
// Get related and other entries of the glossary
            new Ajax.Updater('rel_words','@package_url@get-glossary-word?rels_p=1&selected_id='+param["f_word"]+'&word='+param["f_word"],{method: 'get'});
        } else {
// We are not editing an existing link, but find out if there's a word that matches the selection, if so select it by default
            new Ajax.Request('@package_url@get-glossary-word?exists_p=1&word='+document.getElementById("f_word").value,
                {method: 'get', 
                onSuccess: function (r) {
                    if ( r.responseText != 0 ) {
                        word_id = r.responseText;
                        new Ajax.Request('@package_url@get-glossary-word?word='+param["f_word"],
                            {method: 'get', 
                            onSuccess: function(r){ 
                                document.getElementById("f_def").value = r.responseText; 
                                document.getElementById("word_name").value = param["f_word"].toLowerCase(); 
                                document.getElementById('edit_mode').value = 1; 
                                document.getElementById('word_id').value = word_id;} });
                    } else {
                        document.getElementById("f_word").disabled = ''; 
                    } 
                    new Ajax.Updater('rel_words','@package_url@get-glossary-word?rels_p=1&word='+param["f_word"],{method: 'get'});
                }});
        }
        document.getElementById("f_def").focus();
    } catch (e) {}
    };
	
	function onOK() {
            var required = {
                "f_word": "#learning-content.no_glossary_word#",
                "f_def": "#learning-content.no_glossary_definition#"
            };
            for (var i in required) {
                var el = document.getElementById(i);
                if (!el.value.replace(/^\s\s*/, '')) {
                alert(required[i]);
                el.focus();
                return false;
                }
            }
            if (document.getElementById("edit_mode").value == 0){
                new Ajax.Request('@package_url@get-glossary-word?exists_p=1&word='+document.getElementById("f_word").value,
                    {method: 'get', 
                    onSuccess: function(r) { 
                        if ( r.responseText != 0 ) { 
                            alert('This word already exists!'); 
                            document.getElementById("f_word").focus(); 
                            return false; 
                        } else { 
                            var url = '@package_url@insert-glossary-entry?word=' +escape(encode(document.getElementById("f_word").value))+ '&description=' +escape(encode(document.getElementById("f_def").value));
                            param = {url : url, href : document.getElementById('f_href').value, f_word : document.getElementById('f_word').value, unlink : 0}
                        if (selector_window) {
                            selector_window.close();
                        }
                        __dlg_close(param);
                        return false;
                        } }});
            } else {
                var url = '@package_url@insert-glossary-entry?word_id='+document.getElementById("word_id").value+'&word='+escape(encode(document.getElementById("f_word").value))+'&description=' +escape(encode(document.getElementById("f_def").value));
                param = {url : url, href : document.getElementById('f_href').value, f_word : document.getElementById('f_word').value, unlink : 0}
                if (selector_window) {
                    selector_window.close();
                }
                __dlg_close(param);
                return false;
            }

	};

	function onUnlink() {
          param = { unlink : 1}
	  if (selector_window) {
	    selector_window.close();
	  }
	  __dlg_close(param);
	  return false;
	};
	
	function onCancel() {
	  if (selector_window) {
	    selector_window.close();
	  }
	  __dlg_close(null);
	  return false;
	};

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

</script>

<style type="text/css">
	html, body {
	  background: ButtonFace;
	  color: ButtonText;
	  font: 11px Tahoma,Verdana,sans-serif;
	  margin: 0px;
	  padding: 0px;
	}
	body { padding: 5px; }
	table {
	  font: 11px Tahoma,Verdana,sans-serif;
	}
	form p {
	  margin-top: 5px;
	  margin-bottom: 5px;
	}
	.fl { width: 9em; float: left; padding: 2px 5px; text-align: right; }
	.fr { width: 6em; float: left; padding: 2px 5px; text-align: right; }
	fieldset { padding: 0px 10px 5px 5px; }
	select, input, button { font: 11px Tahoma,Verdana,sans-serif; }
	.space { padding: 2px; }
	
	.title { background: #ddf; color: #000; font-weight: bold; font-size: 120%; padding: 3px 10px; margin-bottom: 10px;
	border-bottom: 1px solid black; letter-spacing: 2px;
	}
	form { padding: 0px; margin: 0px; }
        .glossary_options {
            margin-left: -20px;
            list-style-type: disc;
        }
</style>
<!--[if IE]>
<style>
    .glossary_options {
        list-style-type: disc;
        margin-left: 5px;
        margin-top: 5px;
        margin-bottom: 5px;
    }
    .glossary_options li {
        list-style-type: disc;
    }
</style>
<![endif]-->


</head>

<body onload="Init()">

<div class="title"></div>

<form action="" method="get" name="glossaryprops">
<input type="hidden" name="f_name" id="f_name" />
<input type="hidden" name="f_href" id="f_href" />
<input type="hidden" id="edit_mode" name="edit_mode" />
<div>
	<table border="0" style="width: 100%; margin: 0 auto; text-align: left;padding: 0px;">
	  <tbody>
	  <tr>
            <td valign="top" style="width:30%;">
                <div style="overflow: scroll; height: 175px; max-height: 175px;">
                <table style="border: 1px solid gray; width: 100%; height: 155px;">
                <tr>
                    <td id="rel_words" style="color: #235C96; overflow: scroll; text-align: left; max-height: 175px;" valign="top">
                    </td>
                </tr>
                </table>
                </div>
            </td>
            <td valign="top" style="width: 70%;">
                <table style="width: 100%;"><tr>
                    <td>#learning-content.word#</td></tr>
                    <tr><td><input type="text" disabled="true" onChange="" name="url" id="f_word" style="width:100%" title="#learning-content.wordToolTip#" /></td>
                </tr>
                <tr>
                    <td>#learning-content.definition#</td></tr>
                    <tr><td><textarea name="alt" id="f_def" rows="6" style="width:100%" title="#learning-content.definitionToolTip#" ></textarea></td>
                </tr>
                </table>
            </td>
            </tr>
	  </tbody>
	</table>
        <input type="hidden" name="word_name" id="word_name" />
        <input type="hidden" name="word_id" id="word_id" />
</div>

<table width="100%" style="margin-bottom: 0.2em">
 <tr>
 <td valign="top" style="text-align: left;">
    <button id="unlink" type="button" name="cancel" onclick="return onUnlink();" style="display: none;">#learning-content.remove_link#</button>
 </td>
  <td valign="bottom" style="text-align: right;">
    <button type="button" name="ok" onclick="return onOK();">OK</button><br/>
    <button type="button" name="cancel" onclick="return onCancel();">#learning-content.cancel#</button>
  </td>
 </tr>
</table>
</form>

</body>
</html>
