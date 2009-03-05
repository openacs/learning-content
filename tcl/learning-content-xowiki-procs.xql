<?xml version="1.0"?>

<queryset>
    <fullquery name="learning_content::return_page.get_activity_id">
        <querytext>
            select 1
            from content_activities
            where item_id = :item_id
        </querytext>
    </fullquery>
</queryset>
