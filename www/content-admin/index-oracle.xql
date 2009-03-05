<?xml version="1.0"?>

<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

  <fullquery name="get_communities">
    <querytext>
        select dotlrn_communities_all.pretty_name as community_name,
            dotlrn_communities_all.package_id as community_package_id,
            dotlrn_communities_all.community_id as dst_community_id,
            dotlrn_community.url(dotlrn_communities_all.community_id) as community_url
        from dotlrn_communities_all,
            dotlrn_member_rels_approved
        where dotlrn_communities_all.community_id = dotlrn_member_rels_approved.community_id
            and dotlrn_member_rels_approved.user_id = :user_id
            and decode(dotlrn_community_admin_p(dotlrn_communities_all.community_id, dotlrn_member_rels_approved.user_id),'f',0,1) = 1
        order by community_name
    </querytext>
  </fullquery>

</queryset>
