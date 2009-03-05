<queryset>
    <fullquery name="get_as_title">
        <querytext>
            select title
            from cr_revisions
            where revision_id = :as_revision_id
        </querytext>
    </fullquery>

    <fullquery name="get_as_item">
        <querytext>
            select item_id,
                latest_revision as as_revision_id
            from cr_items
            where parent_id = :folder_id
                and content_type = :activity
                and latest_revision is not null
        </querytext>
    </fullquery>

    <fullquery name="get_forums_with_no_messages">
        <querytext>
            select forum_id, name
            from forums_forums ff
            where package_id = :package_id
                and enabled_p = 't'
                and not exists ( select forum_id
                                from forums_messages fm
                                where fm.forum_id = ff.forum_id)
            order by forum_id
        </querytext>
    </fullquery>

    <fullquery name="get_forums_and_messages">
        <querytext>
            select fm.message_id,
                fm.subject,
                ff.name,
                ff.forum_id
            from forums_messages fm,
                (select forum_id, name
                from forums_forums
                where package_id = :package_id
                    and enabled_p = 't') ff
            where fm.forum_id = ff.forum_id
                and fm.parent_id is null
            order by forum_id
        </querytext>
    </fullquery>

    <fullquery name="get_grades_with_info">
        <querytext>
            select et.task_name,
                et.task_id,
                et.task_item_id,
                eg.grade_plural_name,
                eg.grade_id,
                eg.grade_item_id
            from cr_revisions cr,
                evaluation_tasksi et,
                cr_items cri,
                cr_mime_types crmt,
                (select eg.grade_plural_name,
                    eg.grade_id,
                    eg.grade_item_id
                from evaluation_grades eg,
                    acs_objects ao,
                    cr_items cri
                where cri.live_revision = eg.grade_id
                    and eg.grade_item_id = ao.object_id
                    and ao.context_id = :package_id
                order by grade_plural_name desc) eg
            where cr.revision_id = et.revision_id
                and et.grade_item_id = eg.grade_item_id
                and cri.live_revision = et.task_id
                and et.mime_type = crmt.mime_type
        </querytext>
    </fullquery>

    <fullquery name="get_grades_without_info">
        <querytext>
            select grade_plural_name as grade_name,
                grade_id
            from evaluation_grades eg,
                acs_objects ao,
                cr_items cri
            where cri.live_revision = eg.grade_id
                and eg.grade_item_id = ao.object_id
                and ao.context_id = :package_id
                and not exists (select grade_item_id
                                from evaluation_tasksi et
                                where eg.grade_item_id = et.grade_item_id)
            order by grade_plural_name desc
        </querytext>
    </fullquery>

    <fullquery name="get_chat_rooms">
        <querytext>
            select object_id as room_id,
                (select pretty_name
                from chat_rooms
                where room_id = ao.object_id) as name
            from acs_objects ao
            where context_id = :package_id
        </querytext>
    </fullquery>
</queryset>
