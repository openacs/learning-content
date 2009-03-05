<?xml version="1.0"?>

<queryset>

    <fullquery name="select_page">
        <querytext>
            select ci.item_id as tmp_item_id,
                ci.live_revision as revision_id,
                ci.name,
                p.page_order,
                ci.publish_status
            from category_object_map c,
                cr_items ci,
                xowiki_page p
            where c.object_id = ci.item_id 
                and ci.parent_id = :wiki_folder_id
                and ci.content_type = '::xowiki::PageInstance'
                and p.page_id = ci.live_revision
                and category_id = :cat_id
            order by p.page_order::integer
        </querytext>
    </fullquery>

</queryset>
