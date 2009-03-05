<if @activity_p@ eq 0>
    <b>@msg;noquote@</b>
</if>
<else>
    <if @activity_id@ gt -1>
        <if @activity_id@ eq 0>
            <b>#learning-content.activity_not_available#</b>
        </if><else>
            <a href="/o/@activity_id@">#learning-content.go_to_activity#</a>
        </else>
    </if>
</else>