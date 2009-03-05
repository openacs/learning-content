::xowiki::Package initialize -ad_doc {
  Views details for a user in content

  @author Alvaro Rodriguez (alvaro@viaro.net)
  @creation-date 2008-10-10
} -parameter {
  {-user_id}
  {-return_url:optional ""}
  {-orderby:optional "views"}
}

set title [_ learning-content.user_views]
set context   [list [list ./ [_ learning-content.admin]] $title]
permission::require_permission -object_id $package_id -privilege admin

set folder_id [::$package_id folder_id]
acs_user::get -user_id $user_id -array user
set user_name $user(name)

TableWidget t1 -volatile \
    -columns {
        AnchorField title -label [_ xowiki.Page-title] -orderby title
        Field views -label [_ learning-content.total_views] -orderby views -html {align center style "padding: 2px;"}
        Field last_viewed -label [_ learning-content.last_viewed] -orderby last_viewed -html {align center style "padding: 2px;"}
    }

foreach {att order} [split $orderby ,] break
t1 orderby -order [expr {$order eq "asc" ? "increasing" : "decreasing"}] $att
t1 no_data "[_ learning-content.no_visits_user]"

db_foreach views_info { *SQL* } {

    t1 add \
        -title $title \
        -last_viewed $last_viewed \
        -views $views
}

set t1 [t1 asHTML]

