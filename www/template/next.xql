<?xml version="1.0"?>
<queryset>
    <fullquery name="select_page">
        <querytext>
            select ci.item_id,
                ci.name,
	        ci.live_revision as revision_id,
                p.page_order
            from category_object_map c,
                cr_items ci,
                xowiki_page p
            where c.object_id = ci.item_id
                and ci.parent_id = :wiki_folder_id
                and ci.content_type  = '::xowiki::PageInstance'
                and p.page_id = ci.live_revision
                and category_id = :cat_id
            order by p.page_order
        </querytext>
    </fullquery>

    <fullquery name="get_parent_id">
        <querytext>
            select parent_id
            from categories
            where category_id = :cat_id
        </querytext>
    </fullquery>

    <fullquery name="get_inside_categories">
        <querytext>
            select category_id
            from categories
            where parent_id = :cat_id
            order by category_id desc
        </querytext>
    </fullquery>

    <fullquery name="get_under_categories">
        <querytext>
            select category_id
            from categories
            where parent_id = :parent_id
                and category_id < :cat_id
            order by category_id desc
        </querytext>
    </fullquery>

    <fullquery name="get_parent_id">
        <querytext>
            select parent_id
            from categories
            where category_id = :cat_id
        </querytext>
    </fullquery>

    <fullquery name="get_over_categories">
        <querytext>
            select category_id
            from categories
            where parent_id = :parent_id
                and category_id > :cat_id
            order by category_id
        </querytext>
    </fullquery>

    <fullquery name="get_childrens">
        <querytext>
            select category_id
            from categories
            where parent_id = :subcategory
            order by category_id
        </querytext>
    </fullquery>
</queryset>
