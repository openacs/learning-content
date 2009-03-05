<queryset>
    <fullquery name="get_rel_words">
        <querytext>
            select name,
                item_id
            from cr_items
            where (instr(name,lower(:word)) > 0
                or instr(lower(:word),name) > 0)
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
            where (instr(name,lower(:word)) = 0
                and instr(lower(:word),name) = 0)
                and parent_id = :folder_id
                and content_type = '::xowiki::FormPage'
                order by name
        </querytext>
    </fullquery>
</queryset>
