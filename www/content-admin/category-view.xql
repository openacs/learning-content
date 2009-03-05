<?xml version="1.0"?>

<queryset>

    <fullquery name="get_childrens">
        <querytext>
            select category_id
            from categories
            where parent_id = :category_id
            order by category_id
        </querytext>
    </fullquery>

    <fullquery name="get_subchildrens">
        <querytext>
            select category_id
            from categories
            where parent_id = :subcategory_id
            order by category_id
        </querytext>
    </fullquery>

</queryset>
