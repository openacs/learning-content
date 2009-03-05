<table class="activities" style="width: 100%; text-align: left;">
<if @activity@ eq "forums_message">
    <if @forums:rowcount@ eq 0 and @empty_forums:rowcount@ eq 0><tr><td> #learning-content.forums_admin_link# </td></tr></if>
    <multiple name="forums">
        <if @forums.changed_p@ eq 1>
            <tr id="activity_@forums.forum_id@">
                <th><a onclick="Effect.toggle('activities_@forums.forum_id@','blind')">(+)</a><b>@forums.name@  </b>
                    <a class="button" onclick="select_activity('@community_url@forums/message-post?forum_id=@forums.forum_id@',@forums.forum_id@,'',1);">#learning-content.New#</a></th>
            </tr>
        </if>
        <tr id="activity_@forums.message_id@">
            <td><a onclick="select_activity('','@forums.message_id@','@forums.subject@',0); ">@forums.subject@</a></td>
        </tr>
    </multiple>
    <multiple name="empty_forums">
        <tr id="activity_@empty_forums.forum_id@">
            <th><a>(+)</a><b>@empty_forums.name@  </b>
                <a class="button" onclick="select_activity('@community_url@forums/message-post?forum_id=@empty_forums.forum_id@',@empty_forums.forum_id@,'',1);">new</a></th>
        </tr>
    </multiple>
</if>
<if @activity@ eq "as_assessments">
    <tr id="activity_00001">
        <th><a class="button" onclick="select_activity('@community_url@assessment/asm-admin/assessment-form?type=test','00001','',1);">#learning-content.New#</a></th>
    </tr>
    <if @assessments:rowcount@ eq 0><tr><td> #learning-content.there_are_no_activities_for_type# </td></tr></if>
    <multiple name="assessments">
        <tr id="activity_@assessments.item_id@"><td><a onclick="select_activity('','@assessments.item_id@','@assessments.as_title@',0);">@assessments.as_title@</a></td></tr>
    </multiple>
</if>
<if @activity@ eq "evaluation_tasks">
    <if @evaluations:rowcount@ eq 0 and @empty_evaluations:rowcount@ eq 0><tr><td> #learning-content.there_are_no_activities_for_type# </td></tr></if>
    <multiple name="evaluations">
        <if @evaluations.changed_p@ eq 1>
            <tr id="activity_@evaluations.grade_id@">
                <th>@evaluations.grade_plural_name@ <a class="button" onclick="select_activity('@community_url@evaluation/admin/tasks/task-add-edit?grade_id=@evaluations.grade_id@&return_url=@community_url@evaluation/admin?grade_id=@evaluations.grade_id@',@evaluations.grade_id@,'',1);">#learning-content.New#</a></th>
            </tr>
        </if>
        <tr id="activity_@evaluations.task_item_id@">
            <td style="padding: 0 20px;">
                <a onclick="select_activity('','@evaluations.task_item_id@','@evaluations.task_name@',0);">@evaluations.task_name@</a>
            </td>
        </tr>
    </multiple>
    <multiple name="empty_evaluations">
        <tr id="activity_@empty_evaluations.grade_id@">
            <th><a>(+)</a>@empty_evaluations.grade_name@
            <a class="button" onclick="select_activity('@community_url@evaluation/admin/tasks/task-add-edit?grade_id=@empty_evaluations.grade_id@&return_url=@community_url@evaluation/admin?grade_id=@empty_evaluations.grade_id@',@empty_evaluations.grade_id@,'',1);">#learning-content.New#</a></th>
        </tr>
    </multiple>
</if>
<if @activity@ eq "chat_room">
    <tr id="activity_00002">
        <th><a class="button" onclick="select_activity('@community_url@chat/room-edit','00002','',1);">#learning-content.New#</a></th>
    </tr>
    <if @chat_room:rowcount@ eq 0><tr><td> #learning-content.there_are_no_activities_for_type# </td></tr></if>
    <multiple name="chat_room">
        <tr id="activity_@chat_room.room_id@">
            <td><a onclick="select_activity('','@chat_room.room_id@','@chat_room.name@',0);">@chat_room.name@</a></td>
        </tr>
    </multiple>
</if>
</table>
