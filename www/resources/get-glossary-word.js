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