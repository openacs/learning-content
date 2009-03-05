<?xml version="1.0"?>

<queryset>

    <fullquery name="update_page">
        <querytext>
            update xowiki_page
            set page_order = :page_pos
            where page_id = :tmp_page_id
        </querytext>
    </fullquery>

    <fullquery name="update_page2">
        <querytext>
            update xowiki_page 
            set page_order = :tmp_order where page_id = :page_id
        </querytext>
    </fullquery>

</queryset>

