<queryset>

  <fullquery name="users_info">
    <querytext>
        select dm.user_id, aa.first_names || ' ' || aa.last_name as user_name, 
                (select count(*)
                    from cr_items ci, cr_revisions cr, views_views vv
                    where ci.content_type = '::xowiki::PageInstance' and 
                    coalesce(ci.live_revision,ci.latest_revision) = cr.revision_id and 
                    ci.parent_id = :folder_id and vv.object_id = ci.item_id and 
                    viewer_id = dm.user_id) as views
            from acs_users_all aa,
                 dotlrn_member_rels_approved dm
            where dm.community_id = :community_id
            and dm.user_id = aa.user_id
            and dm.role in ('member','student')
    </querytext>
  </fullquery>

</queryset>
