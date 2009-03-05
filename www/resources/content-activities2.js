
var load_img = document.createElement('img');
// Used to save the current selection of activity id before submit
var temp = 0;
// Used to save the current selection of activity type before submit
var temp2 = '';
load_img.id = 'indicator';
load_img.src = '/resources/learning-content/indicator.gif';

//Called when click on activity type
function show_activities(url,tag) {
    if ( temp == 0 ){
        //This is the case when editing a page or coming back from step 2, temp is empty so temp = activity_id
        temp = document.getElementById('activity_id').value;
        if ( temp == 0 ){
            //If coming from step 2 and choice was a new activity we get the value from another variable
            temp = document.getElementById('new_activity_id').value;
        }
    }
    // container = selected option ; loading = space where we show the loading image ; ok = space where we show the ok image
    var container = document.getElementById(tag);
    var loading = document.getElementById(tag+'_loading');
    var ok = document.getElementById(tag+'_ok');
    try {
        if( temp2 != '') {
            // If we choose an activity type, clear the last selection
            document.getElementById(temp2).style.background = '';
            document.getElementById(temp2+'_ok').style.background = '';
        }
    } catch(e){}
    temp2 = tag;
    // Get the information about the selected activity type
    new Ajax.Request(url,{method: 'get', onLoading:  function() { 
                                                    container.style.background = '#D8E0E6'; 
                                                    ok.style.background = '#D8E0E6 url(/resources/learning-content/images/apply.gif) no-repeat scroll center'; 
                                                    loading.appendChild(load_img); }, 
                                        onComplete: function(){ 
                                                    loading.removeChild(load_img); }, 
                                        onSuccess: function(r) {
                                                    // Display the result
                                                    document.getElementById('show_activities').innerHTML = r.responseText; 
                                                    Effect.Appear('select_activity'); 
                                                    document.getElementById('activity_type').value = tag; 
                                                    //If we had selected an activity_id from the choosen activity type, show it selected, if not remove the submit 
                                                    if (temp > 0){
                                                        try{
                                                            document.getElementById('activity_'+temp).style.background = '#D8E0E6 url(/resources/learning-content/images/apply.gif) no-repeat scroll right'; 
                                                            Effect.Appear('ok_submit');
                                                        } catch (e) {
                                                            Effect.Fade('ok_submit', {duration: 0.3});
                                                        }
                                                    } }
                            });
}

//Called when click on activity id
function select_activity(redirect_url, activity_id, activity_name, new_p) {
    //If there was a selected activity remove the visual selection, inside a try for the case when activity selected is not in the choosed activity type
    try {
        document.getElementById('activity_'+temp).style.background = '';
    } catch(err) { }
    if ( new_p == 1 ) {
        //If there was a selection and the new selection is a new activity, clear the activity id
        document.getElementById('activity_id').value = 0;
        document.getElementById('new_activity_id').value = activity_id;
    } else {
        document.getElementById('activity_id').value = activity_id; 
    }
    Effect.Pulsate('activity_'+activity_id,{ pulses: 1, duration: 0.3});
    //Save the current selection id
    temp = activity_id;
    var tag = document.getElementById('activity_'+temp);
    //Apply the visual selection
    tag.style.background = '#D8E0E6 url(/resources/learning-content/images/apply.gif) no-repeat scroll right';
    var tag2 = document.getElementById('show_activities');
    Effect.Appear('ok_submit');
    document.getElementById('redirect_url').value = redirect_url;
    document.getElementById('activity_name').value = activity_name;
}

