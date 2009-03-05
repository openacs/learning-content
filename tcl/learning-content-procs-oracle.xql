<?xml version="1.0"?>
<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="learning_content::get_item_category_name.get_cat_name">
        <querytext>
            select  o.title as category_name
            from categories c,
                acs_objects o,
                category_object_map m
            where c.category_id = o.object_id
                and m.category_id = c.category_id
                and m.object_id = :item_id
                and rownum <= 1
        </querytext>
    </fullquery>

    <fullquery name="learning_content::get_first_item_from_category_id.get_first_item">
        <querytext>
            select name
            from (
                select ci.name
                from category_object_map c,
                    cr_items ci,
                    xowiki_page p
                where c.object_id = ci.item_id
                    and ci.parent_id = :folder_id
                    and ci.content_type = '::xowiki::PageInstance'
                    and category_id = :category_id
                    and p.page_id = ci.live_revision
                order by to_number(p.page_order)
            ) where rownum <= 1
        </querytext>
    </fullquery>

    <fullquery name="learning_content::delete_p.check_mapped_objects">
        <querytext>
            select case when count(*) = 0 then 0 else 1 end
            from category_object_map
            where category_id = :my_category_id
        </querytext>
    </fullquery>

    <fullquery name="learning_content::get_next_page_order.select_order">
        <querytext>
            select p.page_order
            from cr_items ci,
                xowiki_page p
            where ci.parent_id = :folder_id
                and ci.content_type = '::xowiki::PageInstance'
                and p.page_id = ci.live_revision
                and p.page_order is not null
            order by to_number(p.page_order) desc
        </querytext>
    </fullquery>

</queryset>



