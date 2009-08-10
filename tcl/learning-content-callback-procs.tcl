ad_library {

    Callback Procedures offered by the Content package

    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date 2008-10-01
}

ad_proc -callback learning_content::extend_form {
    {-name:required}
    {-page_instance_id:required}
} {
    Do the extend to the ad_form for each activity package
    (currently: assessment, evaluation, forum)
} -

ad_proc -callback learning_content::insert_object {
    {-name:required}
    {-item_id:required}
    {-activity_id:required}
} {
    Insert an activity from the create interface of the external activity 
} -


ad_proc -public -callback search::url -impl category {} {

    @author alvaro@viaro.net
    @creation_date 2008-10-01

    returns a url for a category of content to the search package

} {
    set category_id $object_id
    set tree_id [category::get_tree $category_id]
    set objects [db_list get_objects { *SQL* }]
    foreach object_id $objects {
        set object_type [acs_object_type $object_id]
        if { [string equal $object_type "apm_package"] } {
            set wiki_url [apm_package_url_from_id $object_id]
            set wiki_folder_id \
                [content::folder::get_folder_from_package_not_cached \
                    -package_id $object_id]
            set name [learning_content::get_first_tree_item_from_category_id \
                -category_id $category_id \
                -folder_id $wiki_folder_id]
            set nexturl "${wiki_url}${name}"
            return $nexturl
        }
    }
    return ""
}

ad_proc -public -callback planner::edit_url -impl category {} {

    @author alvaro@viaro.net
    @creation_date 2008-10-01

    returns a url for the edit action of a content category

} {
    set category_id $object_id
    set tree_id [category::get_tree $category_id]
    set objects [db_list get_objects { *SQL* }]
    foreach object_id $objects {
        set object_type [acs_object_type $object_id]
        if { [string equal $object_type "apm_package"] } {
            set package_url [apm_package_url_from_id $object_id]
            return "${package_url}admin/category-view"
        }
    }
    return ""
}

ad_proc -public -callback learning_content::extend_form -impl content {} {
    Do the extend to the ad_form for each activity package
    (currently: assessment, evaluation, forum)
} {
    if { [exists_and_not_null page_instance_id] && $page_instance_id != 0 } {
        ad_form -extend -name $name \
            -form {{page_instance_id:text(hidden) {value $page_instance_id}}}
    }
}

ad_proc -public -callback learning_content::insert_object -impl content {} {
    Insert an activity from the create interface of the external activity 
} {
    if { [exists_and_not_null item_id] && $item_id != 0 } {
        set insert_p [learning_content::activity_exists_p -item_id $item_id]
        if { $insert_p } {
            learning_content::activity_edit -item_id $item_id -activity_id $activity_id
        } else {
            learning_content::activity_new -item_id $item_id -activity_id $activity_id
        }
        set page [::xowiki::Package instantiate_page_from_id -item_id $item_id]
        $page destroy_on_cleanup
        $page set title $name
        $page save

        set content_url [apm_package_url_from_id [$page set package_id]]
        append content_url [$page set name]
        ad_set_cookie content_alert_message "[_ learning-content.content_new_object_alert_message]"
        ns_cache flush xotcl_object_cache ::$item_id
    }
}
