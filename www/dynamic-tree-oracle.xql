<queryset>
    <fullquery name="get_items_id">
        <querytext>
            select ci.item_id
            from category_object_map c,
                cr_items ci,
                xowiki_page p
            where c.object_id = ci.item_id
                and ci.parent_id = :folder_id
                and ci.content_type = '::xowiki::PageInstance'
                and category_id = :category_id
                and p.page_id = ci.live_revision
            order by to_number(page_order)
        </querytext>
    </fullquery>
</queryset>
