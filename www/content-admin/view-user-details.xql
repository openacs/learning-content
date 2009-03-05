<queryset>

  <fullquery name="views_info">
    <querytext>
        select cr.title, views_count as views,
                to_char(last_viewed,'YYYY-MM-DD HH24:MI:SS') as last_viewed
        from cr_items ci, cr_revisions cr, views_views vv
        where ci.content_type = '::xowiki::PageInstance' and 
        coalesce(ci.live_revision,ci.latest_revision) = cr.revision_id and 
        ci.parent_id = :folder_id and vv.object_id = ci.item_id and 
        viewer_id = :user_id
        order by cr.title
    </querytext>
  </fullquery>

</queryset>
