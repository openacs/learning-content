::xowiki::Package initialize -ad_doc {
    Changes the publication state of a content item
    @author Byron Linares (bhlr@galileo.edu)
    @creation-date Feb. 8, 2008
    
} -parameter {
    {-action ""}
}

set title [_ learning-content.unit_publish]
set action_txt ""
if {![empty_string_p $action]} {
    if { $action == "ready" } {
	set action [_ learning-content.published]
    } else {
	set action [_ learning-content.unpublished]
    }
    set action_txt "[_ learning-content.you_have_changed_unit_publish_state]"
}
set folder_id [::$package_id folder_id]

category_tree::get_mapped_trees $package_id
set tree_id [lindex [lindex [category_tree::get_mapped_trees $package_id] 0] 0]
set tree_list [learning_content::category::get_tree_levels -to_level 1 -tree_id $tree_id]
multirow create tree_state category_id category_name production ready state_url


template::list::create \
    -name tree_state \
    -multirow tree_state \
    -pass_properties {folder_id tree_id} \
    -elements {
	category_name {
	    label "[_ learning-content.unit_name]"
	    html "align center"
	}
	production {
	    label "[_ learning-content.unit_publish_state]"
	    display_template {<if @tree_state.production@ true><b>[_ learning-content.published]</b><a href="@tree_state.state_url;noquote@">( [_ learning-content.do_not_publish] )</a></if><else><b>[_ learning-content.unpublished]</b><a href="@tree_state.state_url;noquote@">( [_ learning-content.do_publish])</a></else>}
	    link_html {title "[_ learning-content.change_state]"}
	    html {align center}
	}
    }

foreach one_category $tree_list {
    set category_id [lindex $one_category 0]
    set sub_tree_list [learning_content::category::get_tree_levels -subtree_id $category_id -tree_id $tree_id]
    set my_state 0
    foreach sub_category $sub_tree_list {
	
	if {$my_state} {
	    continue
	}
	set sub_category_id [lindex $sub_category 0]

	set my_state [db_string select_state {
	    select count(ci.item_id)
	    from category_object_map c, cr_items ci, cr_revisions r, xowiki_page p
	    where c.object_id = ci.item_id and ci.parent_id = :folder_id
	    and ci.content_type not in ('::xowiki::PageTemplate')
	    and ci.name not in ('en:header_page','en:index','en:indexe')
	    and r.revision_id = ci.live_revision
	    and p.page_id = r.revision_id
	    and ci.publish_status = 'production'
	    and category_id = :sub_category_id} -default 0]
    }
    
    if { $my_state } {
	set state_url [export_vars -base change-category-state {tree_id folder_id category_id {state ready}}]
    } else {
	set state_url [export_vars -base change-category-state {tree_id folder_id category_id {state production}}]
    }

    multirow append tree_state $category_id [lindex $one_category 1] "[expr !$my_state]" $my_state $state_url
    set global_state 0
    
}