<?xml version="1.0"?>

<queryset>
    <fullquery name="get_object_id">
        <querytext>
            select activity_id
            from content_activities
            where item_id = (
                select item_id
                from cr_items
                where live_revision = :object_id)
        </querytext>
    </fullquery>

    <fullquery name="object_data">
        <querytext>
            select o.object_type,
                o.title,
                o.package_id
            from acs_objects o
            where o.object_id = :object_id
        </querytext>
    </fullquery>

    <fullquery name="item_data">
        <querytext>
            select o.object_type,
                o.object_id,
                o.package_id,
                i.item_id
            from acs_objects o,
                cr_items i
            where i.item_id = :object_id
                and o.object_id = coalesce (
                    i.live_revision,
                    i.latest_revision,
                    i.item_id)
        </querytext>
    </fullquery>

    <fullquery name="get_assessment_status">
        <querytext>
            select 1
            from cr_items
            where item_id = :object_id
                and publish_status is not null
        </querytext>
    </fullquery>

    <fullquery name="get_forum_id">
        <querytext>
            select forum_id
            from forums_messages
            where message_id = :object_id
        </querytext>
    </fullquery>

    <fullquery name="get_forum_status">
        <querytext>
            select enabled_p
            from forums_forums
            where forum_id = :forum_id
        </querytext>
    </fullquery>
</queryset>