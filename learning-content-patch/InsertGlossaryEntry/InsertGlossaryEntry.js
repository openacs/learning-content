// Insert Glossary Content Plugin for xinha
// Developed in Viaro Networks
// www.viaro.net
//
// Authors: Alvaro Rodriguez, alvaro@viaro.net
//

function InsertGlossaryEntry(editor) {
    var args = arguments;
    this.editor = editor;
    var ArgsString = args[1].toString();
    var additionalArgs = ArgsString.split(",");
    InsertGlossaryEntry.script_dir    = this.editor.script_dir;
    InsertGlossaryEntry.package_id    = this.editor.config.package_id;

    var cfg = editor.config;
    var tt = InsertGlossaryEntry.I18N;
    var bl = InsertGlossaryEntry.btnList;
    var self = this;

    // register the toolbar buttons provided by this plugin
    for (var i = 0; i < bl.length; ++i) {
	var btn = bl[i];
	var id = "LW-" + btn[0];

	cfg.registerButton(id, HTMLArea._lc(btn[1], "InsertGlossaryEntry"), editor.imgURL(btn[0] + ".gif", "InsertGlossaryEntry"), false,
			   function(editor, id) {
			       // dispatch button press event
			       self.show();
			   });
		
	switch (id) {
	case "LW-insert-glossary-entry":
	    cfg.addToolbarElement(id, "insertglossaryentry", +1);
	    break;
	}
    }

    cfg.hideSomeButtons(" insertimage ");
    cfg.pageStyle = "@import url(" + _editor_url + 
	"plugins/InsertGlossaryEntry/insert-glossary-entry.css) screen; "
};

InsertGlossaryEntry._pluginInfo = {
    name          : "InsertGlossaryEntry",
    version       : "0.1",
    developer     : "Alvaro Rodriguez",
    developer_url : "http://www.viaro.net",
    c_owner       : "Alvaro Rodriguez",
    sponsor       : "Viaro Networks",
    sponsor_url   : "http://www.viaro.net",
    license       : "htmlArea"
};

InsertGlossaryEntry.prototype._lc = function(string) {
    return Xinha._lc(string, 'InsertGlossaryEntry');
};

InsertGlossaryEntry.btnList = [
		  ["insert-glossary-entry", "Insert Glossary Entry"]
		  ];

InsertGlossaryEntry.prototype.onGenerateOnce = function()
{
	this._prepareDialog();
};

InsertGlossaryEntry.prototype._prepareDialog = function()
{
  var self = this;
  var editor = this.editor;

  if(!this.html)
  {
    Xinha._getback(Xinha.getPluginDir("InsertGlossaryEntry") + '/dialog.html', function(getback) { self.html = getback; self._prepareDialog(); });
    return;
  }
  
  // Now we have everything we need, so we can build the dialog.
  this.dialog = new Xinha.Dialog(editor, this.html, 'InsertGlossaryEntry',{width:700});
  
  this.dialog.getElementById('ok').onclick = function() {self.apply();}
  this.dialog.getElementById('cancel').onclick = function() { self.dialog.hide()};
  this.dialog.getElementById('unlink').onclick = function() { self.unlink()};
	
  this.ready = true;
};

var word_id;
// Called when the user clicks on "InsertLink" button.  If the link is already
// there, it will just modify it's properties.
InsertGlossaryEntry.prototype.show = function() {
    var editor = InsertGlossaryEntry.editor;
    var outparam = null;

    var editor = this.editor;
    this.selectedHTML = editor.getSelectedHTML();
    var sel  = editor.getSelection();
    var range  = editor.createRange(sel);
    this.a = editor.activeElement(sel);

// Try to get the parent node of the selection
    if(!(this.a != null && this.a.tagName.toLowerCase() == 'a'))
    {
        this.a = editor._getFirstAncestor(sel, 'a');
    }

  if (!(this.a != null && this.a.tagName.toLowerCase() == 'a')){
// If there is no link
    var compare = 0;
    if (HTMLArea.is_ie) {
      if(sel.type == "Control")
      {
        compare = range.length;
      }
      else
      {
        compare = range.compareEndPoints("StartToEnd", range);
      }
    } else {
      compare = range.compareBoundaryPoints(range.START_TO_END, range);
    }
    if (compare == 0) {
      alert(this._lc("You need to select some text before creating a link"));
      return;
    }

    var input_text = editor.getSelectedHTML();
    input_text = input_text.replace('&nbsp;','');
// If there's a link tag in the selection throws an error
    var link_exp = new RegExp('.*<a.*>.*|.*</a.*>.*');
    if (input_text.match(link_exp)){
      alert(this._lc("Your text should not have link tags"));
      return;
    }
// Replace all html tags of the selection
    var link_exp = new RegExp('</*([A-Za-z]+)[^>]*>(.*)</*\\1[^>]*>');
    while (input_text.match(link_exp)){
      input_text = input_text.replace(link_exp,'$2');
    }
// Replace all special chars '<','>'
    var tag = new RegExp('.*<.*>.*');
    if (input_text.match(tag)){
        alert(this._lc("You must select only a text in the same line to add the glossary entry"));
        return;
    }
// Send the word to the glossary interface
    inputs = {
      f_word     : input_text,
      f_def      : '',
      f_href     : '',
      f_def      : '',
      edit_mode    : '0'
    };
// Init
try {

// We are not editing an existing link, but find out if there's a word that matches the selection, if so select it by default
    this.dialog.show(inputs);
    new Ajax.Request('get-glossary-word?exists_p=1&word='+input_text,
        {method: 'get', 
        onSuccess: function (r) {
            if ( r.responseText != 0 ) {
                word_id = r.responseText;
                new Ajax.Request('get-glossary-word?word='+input_text,
                    {method: 'get', 
                    onSuccess: function(r){ 
                        document.getElementById("f_def").value = r.responseText; 
                        document.getElementById("word_name").value = input_text.toLowerCase(); 
                        document.getElementById("edit_mode").value = 1; 
                        document.getElementById("word_id").value = word_id;} });
            } else {
                document.getElementById("f_word").disabled = ''; 
            }
            document.getElementById("f_def").focus();
            new Ajax.Request('get-glossary-word?rels_p=1&word='+input_text,{method: 'get', onSuccess: function (r) { document.getElementById("rel_words").innerHTML = r.responseText }});
        }});
} catch (e) {}

// !Init
  } else {
// If there is already a link
    var att = HTMLArea.is_ie ? "className" : "class";
//Check if it's a glossary link, if not return an error
    if (this.a.getAttribute(att) != 'glossary__content__'){
        alert(this._lc("You cannot add a link to another link"));
        return;
    } else {
// Send the information to the glossary interface
        var id = HTMLArea.is_ie ? editor.stripBaseURL(this.a.id) : this.a.getAttribute("id");
        var re = new RegExp('__[0-9]+__');
        var new_word = id.replace(re,'');
        inputs = {
        f_word     : new_word,
        f_href     : HTMLArea.is_ie ? editor.stripBaseURL(this.a.href) : this.a.getAttribute("href"),
        f_def      : '',
        edit_mode    : '1'
        };
// Init
    try {
    // Show the Unlink button
            this.dialog.show(inputs);
            document.getElementById("unlink_container").style.display = 'block';
            document.getElementById("word_name").value = new_word;
    // Get the description because we are on edition mode
            new Ajax.Request('get-glossary-word?word='+new_word+'',
                {method: 'get', 
                onSuccess: function (r){ 
                    document.getElementById('f_def').value = r.responseText;  } });
    // Get related and other entries of the glossary
            new Ajax.Request('get-glossary-word?rels_p=1&selected_id='+new_word+'&word='+new_word,{method: 'get', onSuccess: function (r) { document.getElementById('rel_words').innerHTML = r.responseText }});
    } catch (e) {}
    }

  }
};

var thisGlossary;
var load_img = document.createElement('img');
load_img.id = 'indicator';
load_img.src = '/resources/content-portlet/indicator.gif';
InsertGlossaryEntry.prototype.apply = function ()
{
    if (document.getElementById('edit_mode').value == 0) {
    thisGlossary = this;
    new Ajax.Request('get-glossary-word?exists_p=1&word='+document.getElementById("f_word").value,
        {method: 'get',
        onLoading: function() { document.getElementById('controls_container').appendChild(load_img); },
        onComplete: function() { document.getElementById('controls_container').removeChild(load_img); },
        onSuccess: function(r) {
            if ( r.responseText != 0 ) {
                alert(thisGlossary._lc("That word already exists"));
                document.getElementById("f_word").focus();
                return false;
            } else {
                var url = 'insert-glossary-entry?word=' +escape(encode(document.getElementById("f_word").value))+ '&description=' +escape(encode(document.getElementById("f_def").value));
                thisGlossary.insertWord(url);
            } 
        }});
    } else {
        var url = 'insert-glossary-entry?word_id='+document.getElementById("word_id").value+'&word='+escape(encode(document.getElementById("f_word").value))+'&description='+escape(encode(document.getElementById("f_def").value));
        this.insertWord(url);
    }
};

InsertGlossaryEntry.prototype.insertWord = function (url)
{
    var editor = this.editor;
    this.dialog.hide();
    var a = this.a;
    try {
        var pos = Math.floor(Math.random()*1000001);
        if (!a){
            new Ajax.Request(url,{method: 'get', onSuccess: function (r) {
                editor._doc.execCommand("createlink", false, 'glossary-list#glossary_'+escape(encode(r.responseText)));
                a = editor.getParentElement();
                var sel = editor._getSelection();
                var range = editor._createRange(sel);
                if (!HTMLArea.is_ie) {
                    a = range.startContainer;
                    if (!/^a$/i.test(a.tagName)) {
                    a = a.nextSibling;
                    if (a == null)
                        a = range.startContainer.parentNode;
                    }
                }
                while (a && !/^a$/i.test(a.tagName))
                    a = a.parentNode;
                editor.selectNodeContents(a);
                a.id = r.responseText+'__'+pos+'__';
                a.className = 'glossary__content__';
            }});
        } else {
            // Update the current glossary link
            new Ajax.Request(url,{method: 'get', onSuccess: function (r) {
                var href = 'glossary-list#glossary_'+escape(encode(r.responseText));
                var id = r.responseText; 
                a.href = href;
                a.id = r.responseText+'__'+pos+'__';
                }});
        }
    }
    catch (e) { }
    this.dialog.getElementById("rel_words").innerHTML = "";
};

InsertGlossaryEntry.prototype.unlink = function ()
{
    var editor = this.editor;
    var a = this.a;
    this.dialog.hide();
    editor.selectNodeContents(a);
    editor._doc.execCommand("unlink", false, null);
    editor.updateToolbar();
    return false;
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

function select_word(package_url, name, scolor, word_id) {
    new Ajax.Request(package_url+'get-glossary-word?word='+name,{method: 'get',
        onSuccess: function (r) {
                    var w_id = document.getElementById('word_name').value;
                    if ( w_id != '') document.getElementById('rel_'+w_id).style.background = '';
                    document.getElementById('f_def').value = r.responseText;
                    document.getElementById('word_name').value = name;
                    document.getElementById('edit_mode').value = 1;
                    document.getElementById('word_id').value = word_id;
                    document.getElementById('f_word').value = name;
                    document.getElementById('rel_'+name).style.background = scolor;
                    document.getElementById('f_word').disabled = 'true';
                    document.getElementById('new_entry').style.background = '';} });
}

function select_new_word (scolor) {
    var w_id = document.getElementById('word_name').value;
    var word = '';
    var def = '';
    document.getElementById('f_word').value = word;
    document.getElementById('f_def').value = def;
    try { document.getElementById('rel_'+w_id).style.background = '';}
    catch (e) {}
    document.getElementById('word_name').value = '';
    document.getElementById('word_id').value = 0;
    document.getElementById('edit_mode').value = 0;
    document.getElementById('f_word').disabled = '';
    document.getElementById('new_entry').style.background = scolor;
}
