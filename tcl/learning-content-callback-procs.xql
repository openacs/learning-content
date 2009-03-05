<?xml version="1.0"?>

<queryset>
    <fullquery name="callback::search::url::impl::category.get_objects">
        <querytext>
            select object_id
            from category_tree_map
            where tree_id = :tree_id
        </querytext>
    </fullquery>

    <fullquery
       name="callback::dotlrn::blocks::edit_url::impl::category.get_objects">

        <querytext>
            select object_id
            from category_tree_map
            where tree_id = :tree_id
        </querytext>
    </fullquery>
</queryset>
