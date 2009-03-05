// Insert Glossary Content Plugin for xinha
// Developed in the Learn@WU Project of the
// Vienna University of Economics and Business Administration
// www.wu-wien.ac.at
//
// Authors: G�nter Ernst guenter.ernst@wu-wien.ac.at
// Modified by: Alvaro Rodríguez, alvaro@viaro.net
//
// Distributed under the same terms as HTMLArea itself.
// This notice MUST stay intact for use (see license.txt).
//

InsertGlossaryEntry._pluginInfo = {
    name          : "InsertGlossaryEntry",
    version       : "0.1",
    developer     : "Alvaro Rodriguez",
    developer_url : "http://www.viaro.net",
    sponsor       : "Viaro Networks",
    sponsor_url   : "http://www.viaro.net",
    license       : "htmlArea"
};

function InsertGlossaryEntry(editor) {
    var args = arguments;
    this.editor = editor;
    var ArgsString = args[1].toString();
    var additionalArgs = ArgsString.split(",");
    InsertGlossaryEntry.script_dir    = this.editor.script_dir;
    InsertGlossaryEntry.package_id    = this.editor.config.package_id;

    if (typeof InsertGlossaryEntry.script_dir == "undefined") {
      // InsertGlossaryEntry.script_dir = ".";
      InsertGlossaryEntry.script_dir = "/learning-content";
    }
	
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
			       self.buttonPress(editor, id);
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

InsertGlossaryEntry.btnList = [
		  ["insert-glossary-entry", "Insert Glossary Entry"]
		  ];

InsertGlossaryEntry.prototype.buttonPress = function(editor, id) {
    InsertGlossaryEntry.editor = editor;
    switch (id) {
    case "LW-insert-glossary-entry":
	this.insertEntry();
	break;
    }
};

// Called when the user clicks on "InsertLink" button.  If the link is already
// there, it will just modify it's properties.
InsertGlossaryEntry.prototype.insertEntry = function(link) {
    var editor = InsertGlossaryEntry.editor;
    var outparam = null;

// Try to get the parent node of the selection
  if (typeof link == "undefined") {
    link = editor.getParentElement();
    if (link) {
      while (link && !/^a$/i.test(link.tagName))
        link = link.parentNode;
    }
  }
  if (!link) {
// If there is no link
    var sel = editor._getSelection();
    var range = editor._createRange(sel);
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
      alert(HTMLArea._lc("You need to select some text before creating a link"));
      return;
    }

    var input_text = editor.getSelectedHTML();
    input_text = input_text.replace('&nbsp;','');
// If there's a link tag in the selection throws an error
    var link_exp = new RegExp('.*<a.*>.*|.*</a.*>.*');
    if (input_text.match(link_exp)){
      alert(HTMLArea._lc("Your text should not have link tags\nTip: Select only text without links."));
      return;
    }
// Replace all html tags of the selection
    var link_exp = new RegExp('</*([a-z]+)[^>]*>(.*)</*\\1[^>]*>');
    while (input_text.match(link_exp)){
      input_text = input_text.replace(link_exp,'$2');
    }
// Replace all special chars '<','>'
    var tag = new RegExp('.*<.*>.*');
    if (input_text.match(tag)){
        input_text = '';
    }
// Send the word to the glossary interface
    outparam = {
      f_word     : input_text,
      f_href     : '',
      f_def      : '',
      edit_mode    : '0'
    };
  } else {
// If there is already a link
    var att = HTMLArea.is_ie ? "className" : "class";
//Check if it's a glossary link, if not return an error
    if (link.getAttribute(att) != 'glossary__content__'){
        alert(HTMLArea._lc("You cannot add a link to another link"));
        return;
    } else {
// Send the information to the glossary interface
        var id = HTMLArea.is_ie ? editor.stripBaseURL(link.id) : link.getAttribute("id");
        var re = new RegExp('__[0-9]+__');
        var new_word = id.replace(re,'');
        outparam = {
        f_word     : new_word,
        f_href     : HTMLArea.is_ie ? editor.stripBaseURL(link.href) : link.getAttribute("href"),
        f_def      : '',
        edit_mode    : '1'
        };
    }
  }
    var PopupUrl = InsertGlossaryEntry.script_dir + "/xinha/insert-glossary-entry";
	PopupUrl = PopupUrl + "?package_id=" + InsertGlossaryEntry.package_id;
	
    Dialog(PopupUrl, function(param) {
	       if (!param) {	// user must have pressed Cancel
		   return false;
	       }
// Create a random number, to append it with the id of the link in case the same word is used more than once in the same page
                var pos = Math.floor(Math.random()*1000001);
                var a = link;
                if (!a) try {
                    new Ajax.Request(param.url,{method: 'get', onSuccess: function (r) {
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
                        a.className = 'glossary__content__';
                        a.id = r.responseText+'__'+pos+'__';
                    } });
                } catch(e) {}
                else {
// If there was a link, check if the action is to take it off
                    if (param.unlink == 1) {
                        editor.selectNodeContents(a);
                        editor._doc.execCommand("unlink", false, null);
                        editor.updateToolbar();
                        return false;
                    } else {
// Update the current glossary link
                    new Ajax.Request(param.url,{method: 'get', onSuccess: function (r) {
                                    var href = 'glossary-list#glossary_'+escape(encode(r.responseText)); var id = r.responseText; 
                        editor.selectNodeContents(a);
                        a.href = href;
                        a.id = r.responseText+'__'+pos+'__';
                        }});
                    }
                }
                if (!(a && /^a$/i.test(a.tagName)))
                return false;
                editor.selectNodeContents(a);
                editor.updateToolbar();

	   }, outparam);
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
