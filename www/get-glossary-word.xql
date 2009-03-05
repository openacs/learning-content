<queryset>
    <fullquery name="check_if_exists">
        <querytext>
            select item_id
            from cr_items
            where name = lower(:word)
                and parent_id = :folder_id
        </querytext>
    </fullquery>

    <fullquery name="get_item_id">
        <querytext>
            select item_id
            from cr_items
            where name = lower(:word)
                and parent_id = :folder_id
        </querytext>
    </fullquery>

    <fullquery name="get_attributes">
        <querytext>
            select instance_attributes
            from xowiki_form_pagei
            where item_id = :item_id
                and revision_id = :revision_id
        </querytext>
    </fullquery>

    <fullquery name="get_all_words">
        <querytext>
            select name,
                item_id
            from cr_items
            where parent_id = :folder_id
                and content_type = '::xowiki::FormPage'
                order by name
        </querytext>
    </fullquery>
</queryset>
