<queryset>
    <fullquery name="get_item_id">
        <querytext>
            select item_id
            from cr_items
            where name = :word
            and parent_id = :folder_id
        </querytext>
    </fullquery>
</queryset>
