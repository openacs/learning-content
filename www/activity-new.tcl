ad_page_contract {
    Interface for creating a new activity for content
    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date 2008-04-15
} {
    {item_id 0}
    {category_id 0}
    {activity_id 0}
    {activity_name ""}
    {redirect_url ""}
    {activity_type ""}
    {new_activity_id 0}
    {return_url ""}
}

if { $item_id == 0 } {
    set page_title [_ learning-content.new_activity]
    set context [list "[_ learning-content.new_activity]"]
} else {
    set page_title [_ learning-content.edit_activity]
    set context [list "[_ learning-content.edit_activity]"]
}

set package_parent_id [site_node::get_parent_id -node_id [ad_conn node_id]]
set package_community_id [site_node::get_object_id \
    -node_id $package_parent_id]
set community_id [dotlrn_community::get_community_id \
    -package_id $package_community_id]
set community_url [dotlrn_community::get_community_url $community_id]
set url "${community_url}chat"

if {[site_node::exists_p -url $url]} {
    set chat_is_mounted 1
} else {
    set chat_is_mounted 0
}

set forward_url ""
if { $item_id != 0 || $activity_id != 0 } {

    if { $activity_id == 0 } {
        set activity_id_o [learning_content::get_activity_id -item_id $item_id]
    } else {
        set activity_id_o $activity_id
    }
    if { $activity_id_o != 0 } {
        set object_type [acs_object_type $activity_id_o]
    } else {
        set object_type ""
    }

    if {![empty_string_p $object_type]} {
        if {[string eq $object_type content_item]} {
            set object_type [::xo::db::CrClass get_object_type \
                -item_id $activity_id_o]
        }
        set activity_type $object_type
        if { $item_id != 0 } {
            set revision_id [content::item::get_live_revision \
                -item_id $item_id]
            set page [::xowiki::Package instantiate_page_from_id -item_id $item_id \
                -revision_id $revision_id]
            set activity_name_o [$page set title]
        } else {
            set activity_name_o $activity_name
        }
    } else {
        set activity_id_o 0
        set activity_name_o ""
    }

} else {
    set object_type ""
    set activity_id_o 0
    set activity_name_o ""
}

set package_id [ad_conn package_id]
set parent_id [site_node::get_parent_id \
    -node_id [site_node::get_node_id_from_object_id \
        -object_id $package_id]]

permission::require_permission -object_id $package_id -privilege admin

ad_form -name activities \
    -has_submit { 1 } \
    -form {
        {activity_id:text(text),optional {label ""}
            {html
                {id "activity_id"
                value "$activity_id_o"
                style "display: none;"}}}
        {activity_name:text(hidden),optional 
            {html
                {id "activity_name"
                value "$activity_name_o"}}}
        {redirect_url:text(hidden),optional
            {html
                {id "redirect_url"
                value "$redirect_url"}}}
        {page_item_id:text(hidden),optional
            {html
                {id "page_item_id"
                value "$item_id"}}}
        {category_id:text(hidden),optional
            {html
                {id "category_id"
                value "$category_id"}}}
        {activity_type:text(hidden),optional
            {html
                {id "activity_type"
                value "$object_type"}}}
        {new_activity_id:text(hidden),optional
            {html
                {id "new_activity_id"
                value "$new_activity_id"}}}
        {return_url:text(hidden),optional
            {html
                {id "return_url"
                value "$return_url"}}}
        {ok_submit:text(submit) {label "[_ learning-content.ok]"}}
    } -on_submit {
        if { ![empty_string_p $redirect_url] } {
            ad_returnredirect [export_vars -base "activity-new2" \
                {activity_id
                redirect_url
                page_item_id
                category_id
                activity_type
                new_activity_id
                return_url}]
        } else {
            ad_returnredirect [export_vars -base "activity-new2" \
                {activity_id
                activity_name
                page_item_id
                category_id
                activity_type
                new_activity_id
                return_url}]
        }
    }
