<?xml version="1.0"?>

<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="select_page">
        <querytext>
            select ci.item_id as tmp_item_id,
                ci.live_revision as revision_id,
                ci.name,
                p.page_order,
                ci.publish_status
            from cr_items ci,
                xowiki_page p
            where ci.parent_id = :wiki_folder_id
                and ci.content_type = '::xowiki::PageInstance'
                and p.page_id = ci.live_revision
            order by to_number(p.page_order)
        </querytext>
    </fullquery>

</queryset>
