<queryset>
    <fullquery name="get_rel_words">
        <querytext>
            select name,
                item_id
            from cr_items
            where name like '%'||:word||'%'
                and parent_id = :folder_id
                and content_type = '::xowiki::FormPage'
            order by name
        </querytext>
    </fullquery>

    <fullquery name="get_other_words">
        <querytext>
            select name,
                item_id
            from cr_items
            where name not like '%'||:word||'%'
                and parent_id = :folder_id
                and content_type = '::xowiki::FormPage'
                order by name
        </querytext>
    </fullquery>
</queryset>
