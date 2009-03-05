<queryset>
    <fullquery name="update_activity">
        <querytext>
            update content_activities
            set activity_id = :activity_id
            where item_id = :page_item_id
        </querytext>
    </fullquery>

    <fullquery name="insert_activity">
        <querytext>
            insert into content_activities
                (item_id,activity_id)
            values
                (:item_id,:activity_id)
        </querytext>
    </fullquery>

    <fullquery name="page_index">
        <querytext>
            select count(p.page_id)
            from cr_items ci,
                xowiki_page p
            where ci.parent_id = :folder_id
                and ci.content_type = '::xowiki::PageInstance'
                and p.page_id = ci.live_revision
        </querytext>
    </fullquery>

    <fullquery name="select_order">
        <querytext>
            select p.page_order
            from cr_items ci,
                cr_revisions r,
                xowiki_page p
            where ci.parent_id = :folder_id
                and ci.content_type not in ('::xowiki::PageTemplate')
                and r.revision_id = ci.live_revision
                and p.page_id = r.revision_id
                and p.page_order is not null
            order by p.page_order desc
        </querytext>
    </fullquery>

    <fullquery name="select_name">
        <querytext>
            select 1 from cr_items
            where name = :page_name
                and parent_id = :folder_id
        </querytext>
    </fullquery>
</queryset>