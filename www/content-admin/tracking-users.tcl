::xowiki::Package initialize -ad_doc {
  Views details for all users in content

  @author Alvaro Rodriguez (alvaro@viaro.net)
  @creation-date 2008-10-10
} -parameter {
  {-return_url:optional ""}
  {-orderby:optional "views"}
}

set title [_ learning-content.users_visits]
set context   [list [list ./ [_ learning-content.admin]] $title]
permission::require_permission -object_id $package_id -privilege admin

set folder_id [::$package_id folder_id]
set community_id [dotlrn_community::get_community_id]
if {[empty_string_p return_url]} {
    set return_url [ad_url]
}

TableWidget t1 -volatile \
    -columns {
        AnchorField user -label [_ learning-content.user_name] -orderby user
        Field views -label [_ learning-content.total_of_pages_visited] -orderby views -html {align center style "padding: 2px;"}
        AnchorField view_details -label [_ learning-content.view_details] -html {align center style "padding: 2px;"}
    }

foreach {att order} [split $orderby ,] break
t1 orderby -order [expr {$order eq "asc" ? "increasing" : "decreasing"}] $att
t1 no_data "[_ learning-content.no_users]"

db_foreach users_info { *SQL* } {

    set view_links "[export_vars -base view-user-details {{user_id $user_id} return_url}] "
    t1 add \
        -user $user_name \
        -views $views \
        -view_details \#learning-content.view_details\# \
        -view_details.href $view_links 

}

set t1 [t1 asHTML]

