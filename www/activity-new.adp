<master>
  <property name="title">@page_title;noquote@</property>
  <property name="context">@context;noquote@</property>
<link media="all" type="text/css" href="/resources/learning-content/fix-xowiki-edit.css" rel="stylesheet"/>
<link media="all" type="text/css" href="/resources/learning-content/activities.css" rel="stylesheet"/>
<link media="all" href="/resources/learning-content/select-activity.css" type="text/css" rel="stylesheet"/>
<!--[if IE 6]>
<link media="all" href="/resources/learning-content/select-activity-ie6.css" type="text/css" rel="stylesheet"/>
<![endif]-->
<script type="text/javascript" src="/resources/ajaxhelper/prototype/prototype.js"></script>
<script type="text/javascript" src="/resources/ajaxhelper/scriptaculous/scriptaculous.js"></script>
<script src="/resources/learning-content/content-activities2.js" type="text/javascript"></script>
<center>
    <table style="height: 30px; width: 50%; border-collapse: collapse; margin-top: 10px; min-width: 400px;">
        <tr>
            <td style="width: 28px; background: url(/resources/learning-content/images/sel_left.gif)"></td>
            <td style="text-align: center; background-color: #D8E0E6;"><b>1. #learning-content.choose_activity#</b></td>
            <td style="width: 28px; background: url(/resources/learning-content/images/sel_middle.gif);"></td>
            <td style="text-align: center; background-color: #F2F2F2;">2. #learning-content.choose_location#</td>
            <td style="width: 28px; background: url(/resources/learning-content/images/sel_right.gif)"></td>
        </tr>
    </table>
<table id="activities-select-table">
<tr>
    <td id="activities-left" valign="top">
        <div class="portlet-wrapper">
            <div class="bportlet_head_text">
                1. #learning-content.select_type_of_activity#
            </div>
            <div class="bcontslide"><br />
                <center>
                    <table class="activities" style="width: 100%; border-collapse: collapse;">
                    <tr id="forums_message">
                        <td id="forums_message_loading" class="icon-spot"></td>
                        <td><a href="#" onclick="show_activities('get-activities?activity=forums_message&parent_id=@parent_id@','forums_message');">#forums.Forum#</a></td>
                        <td id="forums_message_ok" class="icon-spot"></td>
                    </tr>
                    <tr id="as_assessments">
                        <td id="as_assessments_loading" class="icon-spot"></td>
                        <td><a href="#" onclick="show_activities('get-activities?activity=as_assessments&parent_id=@parent_id@','as_assessments');">#assessment.Assessment#</a></td>
                        <td id="as_assessments_ok" class="icon-spot"></td>
                    </tr>
                    <tr id="evaluation_tasks">
                        <td id="evaluation_tasks_loading" class="icon-spot"></td>
                        <td><a href="#" onclick="show_activities('get-activities?activity=evaluation_tasks&parent_id=@parent_id@','evaluation_tasks');">#dotlrn-evaluation.Evaluation_#</a></td>
                        <td id="evaluation_tasks_ok" class="icon-spot"></td>
                    </tr>
                    <if @chat_is_mounted@ eq 1>
                        <tr id="chat_room">
                            <td id="chat_room_loading" class="icon-spot"></td>
                            <td><a href="#" onclick="show_activities('get-activities?activity=chat_room&parent_id=@parent_id@','chat_room');">#learning-content.chat_room#</a></td>
                            <td id="chat_room_ok" class="icon-spot"></td>
                        </tr>
                    </if>
                    </table>
                </center>
            </div>
        </div>
        <center><a href="@return_url;noquote@" class="button">#learning-content.cancel#</a></center>
    </td>
    <td valign="top" style="width: 45%;">
    <div id="select_activity" style="display: none;">
        <table style="width: 100%;"><tr><td valign="top" class="arrow-td">
            <img src="/resources/learning-content/images/grey_arrow.gif"/>
        </td><td>
            <div class="portlet-wrapper">
                <div class="bportlet_head_text">
                    2. #learning-content.choose_activity#
                </div>
                <div class="bcontslide" id="show_activities">
                </div>
            </div>
        </td></tr>
        </table>
    </div>
    </td>
    <td id="activities-right" valign="top">
     <div id="ok_submit" style="display: none;">
        <table style="width: 100%;"><tr><td valign="top" class="arrow-td">
            <img src="/resources/learning-content/images/grey_arrow.gif"/>
        </td><td>
            <div class="portlet-wrapper">
                <div class="bportlet_head_text">
                    3. #learning-content.confirm#
                </div>
                <div class="bcontslide">
                    <center>
                    <formtemplate id="activities">
		    </formtemplate>
                    </center><br>
                </div>
            </div>
        </td></tr>
        </table>
    </div>
    </td>
</tr>
</table>
</center>

<if @activity_id_o@ ne 0 or @activity_type@ ne "">
    <script>
        show_activities('get-activities?activity=@activity_type@&parent_id=@parent_id@','@activity_type@');
    </script>
</if>

