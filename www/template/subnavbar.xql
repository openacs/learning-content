<?xml version="1.0"?>
<queryset>
    <fullquery name="select_content">
        <querytext>
            select ci.item_id,
                p.page_order,
                ci.name
            from category_object_map c,
                cr_items ci,
                xowiki_page p
            where c.object_id = ci.item_id
                and ci.parent_id = :wiki_folder_id
                and ci.content_type = ('::xowiki::PageInstance')
                and p.page_id = ci.live_revision
                and category_id in ([join $cat_id ","])
            order by p.page_order
        </querytext>
    </fullquery>
</queryset>
