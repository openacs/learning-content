<queryset>
    <fullquery name="get_data">
        <querytext>
            select instance_attributes
            from xowiki_form_pagei
            where revision_id = :revision_id
        </querytext>
    </fullquery>

    <fullquery name="check_if_exists">
        <querytext>
            select 1
            from cr_items
            where name = lower(:word)
                and parent_id = :folder_id
        </querytext>
    </fullquery>
</queryset>
