
var load_img = document.createElement('img');
var temp = 0;
var temp2 = '';
load_img.id = 'indicator';
load_img.src = '/resources/learning-content/indicator.gif';

function findPosX(obj)
  {
    var curleft = 0;
    if(obj.offsetParent)
        while(1) 
        {
          curleft += obj.offsetLeft;
          if(!obj.offsetParent)
            break;
          obj = obj.offsetParent;
        }
    else if(obj.x)
        curleft += obj.x;
    return curleft;
  }

  function findPosY(obj)
  {
    var curtop = 0;
    if(obj.offsetParent)
        while(1)
        {
          curtop += obj.offsetTop;
          if(!obj.offsetParent)
            break;
          obj = obj.offsetParent;
        }
    else if(obj.y)
        curtop += obj.y;
    return curtop;
  }

function show_activities(url,tag) {
    if ( temp == 0 ){
        temp = document.getElementById('activity_id').value;
    }
    var container = document.getElementById(tag);
    if( temp2 != '') {
        document.getElementById(temp2).style.background = '';
    }
    temp2 = tag;
    new Ajax.Request(url,{method: 'get', onLoading:  function(){ container.style.background = '#D8E0E6'; container.appendChild(load_img); }, onComplete: function(){ container.removeChild(load_img); }, onSuccess: function(r) {  document.getElementById('show_activities').innerHTML = r.responseText; Effect.Appear('show_activities');  if (temp > 0){ document.getElementById('activity_'+temp).style.background = '#D8E0E6'; } var arrow_img = document.getElementById('activity_arrow'); arrow_img.style.top = findPosY(document.getElementById('activity_'+temp))-8+'px'; arrow_img.style.left = findPosX(document.getElementById('show_activities'))+300+'px'; } });
}

function select_activity(redirect_url, activity_id, activity_name, new_p) {
    try { 
        document.getElementById('activity_'+temp).style.background = '';
    } catch(err) { } 
    if ( new_p == 1 ) {
        document.getElementById('activity_id').value = 0;
    } else {
        document.getElementById('activity_id').value = activity_id; 
    }
    Effect.Pulsate('activity_'+activity_id,{ pulses: 1, duration: 0.3});
    temp = activity_id;
    var tag = document.getElementById('activity_'+temp);
    tag.style.background = '#D8E0E6';
    var tag2 = document.getElementById('show_activities');
    var arrow_img = document.getElementById('activity_arrow');
    arrow_img.style.top = findPosY(tag)-8+'px';
    arrow_img.style.left = findPosX(tag2)+300+'px';
    Effect.Appear('optional_text_editor');
    document.getElementById('redirect_url').value = redirect_url;
    document.getElementById('activity_name').value = activity_name;
}

