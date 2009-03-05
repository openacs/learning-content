::xowiki::Package initialize -ad_doc {
  Views details for a page in content

  @author Alvaro Rodriguez (alvaro@viaro.net)
  @creation-date 2008-10-10
} -parameter {
  {-object_id}
  {-return_url:optional ""}
  {-orderby:optional "views"}
}

set title [_ learning-content.page_views]
set context   [list [list ./ [_ learning-content.admin]] $title]
permission::require_permission -object_id $package_id -privilege admin

set revision_id [content::item::get_best_revision -item_id $object_id]
set page_name [db_string get_page_name {} -default ""]
set community_id [dotlrn_community::get_community_id]

TableWidget t1 -volatile \
    -columns {
        AnchorField user -label [_ learning-content.user_name]
        Field views -label [_ learning-content.total_views] -orderby views -html {align center style "padding: 2px;"}
        Field last_viewed -label [_ learning-content.last_viewed] -orderby last_viewed -html {align center style "padding: 2px;"}
    }

foreach {att order} [split $orderby ,] break
t1 orderby -order [expr {$order eq "asc" ? "increasing" : "decreasing"}] $att
t1 no_data "[_ learning-content.no_visits]"

db_foreach views_info { *SQL* } {

    acs_user::get -user_id $viewer_id -array user
    set user_name $user(name)

    t1 add \
        -user $user_name \
        -last_viewed $last_viewed \
        -views $views
}

set t1 [t1 asHTML]

