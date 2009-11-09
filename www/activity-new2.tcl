ad_page_contract {
    Interface for creating a new activity for content
    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date 2008-04-10
} {
    {item_id 0}
    {page_item_id 0}
    {activity_id 0}
    {redirect_url ""}
    {activity_name ""}
    {category_id 0}
    {activity_type ""}
    {new_activity_id 0}
    {return_url "./"}
}

if { $page_item_id == 0 } {
    set page_title [_ learning-content.new_activity]
    set context [list "[_ learning-content.new_activity]"]
} else {
    set page_title [_ learning-content.edit_activity]
    set context [list "[_ learning-content.edit_activity]"]
}

set package_id [ad_conn package_id]
set parent_id [site_node::get_parent_id \
        -node_id [site_node::get_node_id_from_object_id \
            -object_id $package_id]]

set trees [category_tree::get_mapped_trees $package_id id]
set tree [lindex $trees 0]
set tree_id [lindex $tree 0]

permission::require_permission -object_id $package_id -privilege admin

set activities_category 0
set back_url [export_vars -base "activity-new" {
        {item_id $page_item_id}
        activity_id
        redirect_url
        activity_name
        category_id
        activity_type
        
}]

set categories [category::get_children -category_id $category_id]
foreach category $categories {
    if {[ string equal [category::get_name $category] "Actividades"]} {
        set activities_category $category
    }
}
switch $activity_type {
    as_assessments {
        set activity_type_name "[_ assessment.Assessment]"
    }
    forums_message {
        set activity_type_name "[_ forums.Forum]"
    }
    evaluation_tasks {
        set activity_type_name "[_ dotlrn-evaluation.Evaluation_]"
    }
    chat_room {
        set activity_type_name "[_ chat.chat_rooms]"
    }
    default {
        set activity_type_name ""
    }
}

if { $page_item_id != 0 } {
    set revision_id [content::item::get_live_revision -item_id $page_item_id]
    set page [::xowiki::Package instantiate_page_from_id \
                -item_id $page_item_id -revision_id $revision_id]
    set optional_text [lindex [$page set instance_attributes] 1]
} else {
    set optional_text ""
    set category_trees [category_tree::get_mapped_trees $package_id]
    foreach tree $category_trees {
        set cat_name "__category__ad_form__category_[lindex $tree 0]"
    }
}

ad_form -name activities

category::ad_form::add_widgets -container_object_id $package_id \
    -form_name activities \
    -element_name category \
    -categorized_object_id $page_item_id

ad_form -extend -name activities \
    -has_submit { 1 } \
    -form {
        {optional_text:richtext(richtext),optional
          {label "#learning-content.optional_description#"}
          {options {
              editor xinha plugins
              {GetHtml
                  ContextMenu ListType EditTag
                  Stylist OacsFs InsertGlossaryEntry}
              }}
          {value "$optional_text"}
          {html {id "optional_text" rows 20 cols 100}}}
        {activity_id:text(text),optional {label ""}
          {html {id "activity_id" value $activity_id style "display: none;"}}}
        {activity_name:text(hidden),optional
          {html {id "activity_name" value "$activity_name"}}}
        {redirect_url:text(hidden),optional
          {html {id "redirect_url" value "$redirect_url"}}}
        {page_item_id:text(hidden),optional
          {html {id "page_item_id" value $page_item_id}}}
        {ok_submit:text(submit) {label "[_ learning-content.ok]"}}
        {cancel_submit:text(submit) {label "[_ learning-content.cancel]"}
          {html
            {onclick "document.getElementById('action').value = 'cancel';"}}}
        {action:text(hidden) {html {id "action"}} {value ""}}
    } -on_submit {
        if { [string equal $action "cancel"] } {
                ad_returnredirect $return_url
        }
        set category_trees [category_tree::get_mapped_trees $package_id]
        foreach tree $category_trees {
            set cat_name "__category__ad_form__category_[lindex $tree 0]"
            set category_id [ns_queryget "$cat_name"]
        }

        if { $page_item_id == 0} {
            set data [learning_content::create_page -content $optional_text \
                        -page_title $activity_name]
            set item_id [lindex $data 0]
        } else {
            set data [learning_content::update_page -content $optional_text -page_title \
                        $activity_name -page_item_id $page_item_id]
            set item_id $page_item_id
        }
        set page_name [lindex $data 1]

        if { $category_id != 0 } {
            category::map_object -remove_old -object_id $item_id $category_id
        }

        if { $activity_id != 0 } {
            if { $page_item_id != 0 } {
                learning_content::activity_edit -item_id $page_item_id -activity_id $activity_id
            } else {
                learning_content::activity_new -item_id $item_id -activity_id $activity_id
            }
        } elseif { ![empty_string_p $redirect_url] } {
            if {![learning_content::activity_exists_p -item_id $item_id]} {
                    learning_content::activity_new \
                        -item_id $item_id -activity_id 0
            }
            set redirect_url [lindex $redirect_url 0]
            ad_returnredirect [export_vars \
                -base $redirect_url {{page_instance_id $item_id}}]
        }
        set package_id [ad_conn package_id]
        set package_url [apm_package_url_from_id $package_id]
        ad_returnredirect "${package_url}$page_name"
    }
