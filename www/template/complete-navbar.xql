<?xml version="1.0"?>

<queryset>
    <fullquery name="select_cat">
        <querytext>
            select count(ci.item_id),
                c.category_id
            from category_object_map c,
                cr_items ci
            where c.object_id = ci.item_id
                and ci.parent_id = :wiki_folder_id
                and ci.content_type = ('::xowiki::PageInstance')
            group by category_id
            order by category_id desc
        </querytext>
    </fullquery>
</queryset>
