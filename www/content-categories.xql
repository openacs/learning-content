<queryset>
    <fullquery name="get_unit_id1">
        <querytext>
            select parent_id as open_unit_id1
            from categories
            where category_id = :open_category_id
        </querytext>
    </fullquery>

    <fullquery name="get_unit_id2">
        <querytext>
            select parent_id as open_unit_id2
            from categories
            where category_id = :open_unit_id1
        </querytext>
    </fullquery>

    <fullquery name="get_childrens">
        <querytext>
            select category_id
            from categories
            where parent_id = :category_id
            order by category_id
        </querytext>
    </fullquery>
</queryset>
