<queryset>
    <fullquery name="get_form_page_ids">
        <querytext>
            select item_id
            from cr_items
            where parent_id = :folder_id
                and content_type = '::xowiki::FormPage'
                and name like :letter
            order by name
        </querytext>
    </fullquery>

    <fullquery name="get_name">
        <querytext>
            select name
            from cr_items
            where item_id = :item_id
        </querytext>
    </fullquery>

    <fullquery name="get_initials">
        <querytext>
            select distinct substr(name,1,1)
            from cr_items
            where parent_id = :folder_id
                and content_type = '::xowiki::FormPage'
            order by substr(name,1,1)
        </querytext>
    </fullquery>

    <fullquery name="get_form_pages">
        <querytext>
            select instance_attributes
            from xowiki_form_pagei
            where item_id = :item_id
        </querytext>
    </fullquery>

    <fullquery name="get_words_info">
        <querytext>
            select item_id,
                name
            from cr_items 
            where parent_id = :folder_id
                and content_type = '::xowiki::FormPage'
                and name like :letter
            order by name
        </querytext>
    </fullquery>

    <fullquery name="get_term_count">
        <querytext>
            select sum(times_used) as count
            from content_glossary_term_count
            where folder_id = :folder_id
                and term = :name
        </querytext>
    </fullquery>
</queryset>
