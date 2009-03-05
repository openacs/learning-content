<queryset>
    <fullquery name="get_pages">
        <querytext>
            select distinct item_id as page_id
            from xowiki_page_instancei
            where item_id in (select item_id
                            from cr_items
                            where parent_id = :folder_id
                                and content_type = '::xowiki::PageInstance')
        </querytext>
    </fullquery>

    <fullquery name="get_name">
        <querytext>
            select name
            from cr_items
            where item_id = :item
        </querytext>
    </fullquery>

    <fullquery name="delete_word">
        <querytext>
            delete from content_glossary_term_count
            where folder_id = :folder_id
                and term = :item_name
        </querytext>
    </fullquery>
</queryset>
