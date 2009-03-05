::xowiki::Package initialize -ad_doc {
  Views details for all pages of content

  @author Alvaro Rodriguez (alvaro@viaro.net)
  @creation-date 2008-10-10
} -parameter {
  {-object_type:optional}
  {-orderby:optional "unique_views,title"}
}

set title [_ learning-content.pages_visits]
set context   [list [list ./ [_ learning-content.admin]] $title]
permission::require_permission -object_id $package_id -privilege admin

set object_type "::xowiki::PageInstance"
set community_id [dotlrn_community::get_community_id]
# if object_type is specified, only list entries of this type;
# otherwise show types and subtypes of $supertype
if {![info exists object_type]} {
  set per_type 0
  set supertype ::xowiki::PageInstance
  set object_types [$supertype object_types]
  set title "List of all kind of [$supertype set pretty_plural]"
  set with_subtypes true
  set object_type $supertype
} else {
  set per_type 1
  set object_types [list $object_type]
  set title "Index of [$object_type set pretty_plural]"
  set with_subtypes false
}

set return_url [expr {$per_type ? [export_vars -base [::$package_id url] object_type] :
                      [::$package_id url]}]
# set up categories
set category_map_url [export_vars -base \
              [site_node::get_package_url -package_key categories]cadmin/one-object \
                          { { object_id $package_id } }]

set actions ""


set ::individual_permissions [expr {[$package_id set policy] eq "::xowiki::policy3"}]
set ::with_publish_status 1

TableWidget t1 -volatile \
    -actions $actions \
    -columns {
        AnchorField title -label [_ xowiki.Page-title] -orderby title
        Field unique_views -label [_ learning-content.total_users] -orderby unique_views -html {align center style "padding: 2px;"}
        AnchorField view_details -label [_ learning-content.view_details] -html {align center style "padding: 2px;"}

    }

foreach {att order} [split $orderby ,] break
t1 orderby -order [expr {$order eq "asc" ? "increasing" : "decreasing"}] $att

set attributes [list ci.item_id revision_id content_length creation_user title]
 
if {[::xo::db::has_ltree]} {
  lappend attributes page_order
}

set folder_id [::$package_id folder_id]

db_foreach instance_select \
    [$object_type instance_select_query \
         -folder_id $folder_id \
         -with_subtypes $with_subtypes \
         -from_clause ", xowiki_page p" \
         -where_clause "p.page_id = bt.revision_id" \
         -select_attributes $attributes \
         -orderby ci.name \
        ] {
          
          set page_link [::$package_id pretty_link $name]
          #Here we get the total views per page          
	  #views::get -object_id $item_id
            set views 0
            set last_viewed "-"
            set unique_views "-"
	  db_0or1row get_view { *SQL* }
 
	  set view_links "[export_vars -base view-details {{object_id $item_id} return_url}] "
          if { $views != 1 } {
	      set views [expr $views]
	  }
          t1 add \
              -title $title \
              -title.href $page_link \
              -unique_views $unique_views  \
              -view_details \#learning-content.view_details\# \
              -view_details.href $view_links \

          if {$::individual_permissions} {
            [t1 last_child] set permissions.href \
                [export_vars -base permissions {item_id return_url}] 
          }
          if {$::with_publish_status} {
            # TODO: this should get some architectural support
	    if {$publish_status eq "ready"} {
	      set image active.png
	      set state "production"
	    } else {
	      set image inactive.png
	      set state "ready"
	    }
            [t1 last_child] set publish_status.src /resources/xowiki/$image
	    [t1 last_child] set publish_status.href \
		[export_vars -base [$package_id package_url]admin/set-publish-state \
		     {state revision_id return_url}]
          }
          if {[::xo::db::has_ltree]} {
	    [t1 last_child] set page_order $page_order
          }
        }

t1 no_data "[_ learning-content.no_pages]"
set t1 [t1 asHTML]

