<queryset>

  <fullquery name="views_info">
    <querytext>
        select views_count as views, viewer_id, 
            to_char(last_viewed,'YYYY-MM-DD HH24:MI:SS') as last_viewed
        from acs_users_all aa, views_views vv,
                dotlrn_member_rels_approved dm
        where dm.community_id = :community_id
        and dm.user_id = aa.user_id
        and dm.role in ('member','student')
        and vv.viewer_id = dm.user_id
        and vv.object_id = :object_id
    </querytext>
  </fullquery>

  <fullquery name="get_page_name">
    <querytext>
    select title 
    from cr_revisions 
    where revision_id = :revision_id
    </querytext>
  </fullquery>

</queryset>
