<queryset>

  <fullquery name="get_view">
    <querytext>
        select count(*) as unique_views
        from acs_users_all aa, views_views vv,
                dotlrn_member_rels_approved dm
        where dm.community_id = :community_id
        and dm.user_id = aa.user_id
        and dm.role in ('member','student')
        and vv.viewer_id = dm.user_id
        and vv.object_id = :item_id
    </querytext>
  </fullquery>

</queryset>
