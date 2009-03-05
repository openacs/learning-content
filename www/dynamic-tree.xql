<queryset>
    <fullquery name="get_name">
        <querytext>
            select title
            from xowiki_page_instancei
            where object_id = (
                select live_revision
                from cr_items
                where item_id = $object)
        </querytext>
    </fullquery>
</queryset>
