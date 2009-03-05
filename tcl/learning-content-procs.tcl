ad_library {
    Content package procs

    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date 2008-09-04
}

namespace eval content {}
namespace eval learning_content::category {}
namespace eval learning_content::page {}

ad_proc -public learning_content::create_page {
    {-content ""}
    {-page_title ""}
} {
    set package_id [ad_conn package_id]
    ::xowiki::Package initialize -package_id $package_id
    set folder_id [::xowiki::Page require_folder -name xowiki \
                        -package_id $package_id]
    set page [::xowiki::PageInstance new ]
    set page_index [db_string page_index {*SQL*} -default 0]
    set page_name "en:page_[incr page_index]"
    if {[db_string select_name {*SQL*} -default 0]} {
        set page_name "en:page_[incr page_index]_[format "%0.0f" [expr [random] * 10]]_[format \
            %0.0f [expr [random] * 10]]"
    }
    $page configure -name $page_name -parent_id $folder_id \
        -package_id $package_id

    set max_page_order [learning_content::get_next_page_order]

    db_0or1row select_instance [::xowiki::PageTemplate instance_select_query \
                            -folder_id $folder_id \
                            -select_attributes {name} \
                            -where_clause "name = 'en:content_template'"]

    set template_id $item_id
    $page set page_template $template_id
    $page set page_order $max_page_order
    $page set nls_language "en_US"
    $page set instance_attributes [list "contenido" $content]
    if {![empty_string_p $page_title]} {
        $page set title $page_title
    }
    $page destroy_on_cleanup
    $page initialize_loaded_object
    set page_id [$page save_new]
    return [list $page_id $page_name]
}

ad_proc -public learning_content::update_page {
    {-content ""}
    {-page_title ""}
    {-page_item_id 0}
} {
    set package_id [ad_conn package_id]
    ::xowiki::Package initialize -package_id $package_id
    if { $page_item_id != 0 } {
        set page [::xowiki::Package instantiate_page_from_id -item_id $page_item_id]
        set page_name [$page set name]
        $page destroy_on_cleanup
    
        if { ![empty_string_p $content] } {
            $page set instance_attributes [list "contenido" $content]
        }
        if { ![empty_string_p $page_title]} {
            $page set title $page_title
        }
        set page_id [$page save]
        set result [list $page_id $page_name]
    } else {
        set result [list]
    }
    return $result
}

ad_proc -public learning_content::get_item_category_name {
    {-item_id:required}
} {
    set category_name [db_string get_cat_name {} -default "NOT_FOUND"]
    return $category_name
}

ad_proc -public learning_content::insert_item_into_category {
    {-item_id:required}
    {-category_name:required}
    {-tree_id:required}
} {
    set category_id_list [category::get_id $category_name]
    set this_tree [category_tree::get_tree $tree_id]
    set categories [list]
    foreach category $this_tree {
        set category_id [lindex $category 0]
        lappend categories $category_id
    }
    set added 0
    foreach category_id $category_id_list {
        if {[lsearch -exact $categories $category_id] != -1 } {
        category::map_object -object_id $item_id $category_id
        set added 1
        }
    }
}

ad_proc -public learning_content::insert_items_into_category_by_name {
    {-object_category_list:required}
    {-package_id:required}
} {
    set tree_list [category_tree::get_mapped_trees $package_id]
    set tree_id   [lindex [lindex $tree_list 0] 0]
    set folder_id [::$package_id folder_id]
    foreach {item_name category_name } $object_category_list {
        set item_id [db_string get_item_id {} -default "0"]
        if { $item_id } {
                learning_content::insert_item_into_category \
                     -item_id $item_id \
                    -category_name $category_name \
                    -tree_id $tree_id
        }
    }
}

ad_proc -public learning_content::create_target_category_tree_and_map_source_category_tree  {
    {-original_categories:required}
    {-package_id:required}
} {
    set tree_list [category_tree::get_mapped_trees $package_id]
    set tree_id   [lindex [lindex $tree_list 0] 0]
    category_tree::unmap -tree_id $tree_id -object_id $package_id
    set orig_new_category_map [list]
    set new_tree_id [category_tree::add  \
                        -name "\#learning-content.choose_location\#"  \
                        -context_id $package_id ]
    foreach orig_cat $original_categories {
        set original_category_id [lindex $orig_cat 0]
        set original_category_name [lindex $orig_cat 1]
        set original_category_level [lindex $orig_cat 2]
        set original_category_parent [lindex $orig_cat 3]
        set new_category_id [category::add \
                        -tree_id $new_tree_id\
                        -parent_id [learning_content::get_mapped_category \
                            -category_map $orig_new_category_map \
                            -query_orig_category_id $original_category_parent]\
                        -name $original_category_name]
        lappend orig_new_category_map [list $original_category_id \
            $new_category_id]
    }
    category_tree::map -tree_id $new_tree_id -object_id $package_id -widget ""
    return $orig_new_category_map
}

ad_proc -public learning_content::get_mapped_category {
    {-category_map:required}
    {-query_orig_category_id:required}
    } {
    if {$query_orig_category_id == 0 } {
        return ""
    }

    foreach category_pair $category_map {
        set original_category_id [lindex $category_pair 0]
        set new_category_id [lindex $category_pair 1]
        if {$original_category_id ==  $query_orig_category_id } {
            return $new_category_id
        }
    }
    return ""
}

ad_proc -public learning_content::map_objects_to_categories {
    {-categories_map:required}
    {-object_category_map:required}
    {-package_id:required}
    {-folder_id:required}
} {
    foreach object_category $object_category_map {
        set object_name [lindex $object_category 0]
        set orig_category_id [lindex $object_category 1]
        if {![empty_string_p $orig_category_id]} {
            set new_category_id [learning_content::get_mapped_category \
                                    -category_map $categories_map \
                                    -query_orig_category_id $orig_category_id]

            set object_id [db_string get_item_id_in_context {} -default "0"]
            if {$object_id} {
                category::map_object -remove_old \
                    -object_id $object_id $new_category_id
            }  else {
                set error_msg "object_id = $object_id for "
                append error_msg "object_name = $object_name"
                ns_log error $error_msg
            }
        }
    }
}

ad_proc -public learning_content::map_activity_objects {
    {-src_folder_id:required}
    {-dst_folder_id:required}
} {

    With the id of every page copied check if it's an activity, if so insert
   a new entry with the new page_id and empty activity_id in the activities table

} {
    set objects_map [db_list_of_lists get_objects { *SQL* }]
    foreach object $objects_map {
        set item_id [lindex $object [expr [llength $object] - 1]]
        set item_name [lindex $object 0]
        if { [learning_content::activity_exists_p -item_id $item_id] } { 
            set new_item_id [db_string get_new_item_id { *SQL* } -default 0]
            learning_content::activity_new -item_id $new_item_id -activity_id 0
        }
    }
}

ad_proc -public learning_content::copy_glossary_words_count {
    {-src_folder_id:required}
    {-dst_folder_id:required}
} {
    Copy the words count from the source instance of content 
    to a target instance
} {
    db_foreach get_words_count { *SQL* } {
        if {[db_string check_word {} -default 0]} {
            db_dml update_word { *SQL* }
        } else {
            db_dml insert_word { *SQL* }
        }
    }
}

ad_proc -public learning_content::parse_all_instance {
    {-original_package_id:required}
    {-new_package_id:required}
} {
    set wiki_folder_id [::xowiki::Page require_folder \
        -name xowiki -package_id $new_package_id]
    foreach page [::xowiki::PageInstance allinstances] {
        set new_content [learning_content::parse_for_fs \
            -page_content "[$page set instance_attributes] "\
            -original_package_id $original_package_id \
            -new_package_id $new_package_id]
        $page set instance_attributes " $new_content "
    }
}

ad_proc -public learning_content::parse_for_fs {
    {-page_content:required}
    {-original_package_id:required}
    {-new_package_id:required}
} {
    set match_list [list]
    set list_of_expressions [split $page_content ">"]
    foreach expression $list_of_expressions {
        if {[regexp \
            /dotlrn(.*)file-storage(.*)(\\.)(...|....)(\") \
            $expression one_match]} {
            set one_match [string trimright $one_match "\""]
            set this_match [list $one_match [learning_content::replace_path \
                -original_path $one_match \
                -original_package_id $original_package_id \
                -new_package_id $new_package_id ] ]	
            lappend match_list $this_match
        }
    }
    foreach match_pair $match_list {
        regsub [lindex $match_pair 0] $page_content [lindex $match_pair 1]\
            page_content
    }
    return $page_content
}

ad_proc -public learning_content::replace_path {
    {-original_path:required}
    {-original_package_id:required}
    {-new_package_id:required}
} {
    set fs_view "file-storage/view"
    set view_start [string last $fs_view $original_path]
    if { $view_start == -1} {
            return $original_path
    }
    set view_start [expr $view_start + [string length $fs_view]]
    set fs_url [string range $original_path \
        [string first "/dotlrn" $original_path] \
        [expr $view_start - [string length "/view"]] ]
    array set  orig_fs_node_info [site_node::get_from_url -url $fs_url]
    set orig_fs_package_id $orig_fs_node_info(package_id)
    set new_node_id [site_node::get_node_id_from_object_id \
     -object_id $new_package_id]
    set new_parent_id [site_node::get_parent_id -node_id $new_node_id]
    set new_package_id  [site_node::get_object_id -node_id $new_parent_id]
    set new_fs_url [site_node::get_url_from_object_id \
        -object_id $new_package_id]
    append new_fs_url "file-storage/"
    array set  new_fs_node_info [ site_node::get_from_url -url $new_fs_url ]
    set new_fs_package_id $new_fs_node_info(package_id)
    set orig_root_folder [fs_get_root_folder  -package_id $orig_fs_package_id ]
    set new_root_folder [fs_get_root_folder  -package_id $new_fs_package_id ]
    set fs_view_path [string range $original_path $view_start end] 
    set fs_view_path [ns_urldecode $fs_view_path]
    set file_id [::content::item::get_id -item_path " $fs_view_path " \
                    -root_folder_id $orig_root_folder \
                    -resolve_index "t"]
    if [empty_string_p $file_id] {
        return $original_path
    }
    set final_fs_view_path $fs_view_path
    set fs_view_path [string range $fs_view_path 1 \
        [string last "/" $fs_view_path]]
    set fs_view_path [string trimright $fs_view_path "/" ]
    set folder_list [split $fs_view_path "/"]
    set root_folder $new_root_folder
    foreach folder $folder_list {
        set folder [ns_urldecode $folder] 
        set folder_id [fs::get_folder -name "$folder" -parent_id $root_folder]
        if { [empty_string_p $folder_id ] } {
            set root_folder [fs::new_folder -name "$folder" \
                -pretty_name "$folder" -parent_id $root_folder]
        } else {
            set root_folder $folder_id
        }
    }
    set new_file_id [fs::file_copy -file_id $file_id \
        -target_folder_id $root_folder]
    set new_file_path $new_fs_url
    append new_file_path "view"
    append new_file_path $final_fs_view_path
    return $new_file_path
}

ad_proc -public learning_content::get_categories {
    {-tree_id:required}
} {
    Get Categories from Tree Id
} {
    set locale "en_US"
    set result [list]
    set result [db_list get_categories ""]
    return $result
}

ad_proc -public learning_content::get_category_name {
    {-category_id:required}
} {
    Get Category Name from Id
} {
    set locale "en_US"
    if { [catch { array set cat_lang \
    [lindex [nsv_get categories $category_id] 1] }] } {
        return {}
    }
    if { ![catch { set name $cat_lang($locale) }] } {
        # exact match: found name for this locale
        return $name
    }
    if {![catch { set name $cat_lang( [ad_parameter DefaultLocale \
    acs-lang "en_US"] )}]} {
        return $name
    }

}

ad_proc -public learning_content::get_first_page {
    {-package_id:required}
} {
    Get the first visible page in the content tree, if any
} {
    set trees [category_tree::get_mapped_trees $package_id]
    set tree [lindex $trees 0]
    set tree_id [lindex $tree 0]
    set units [category_tree::get_categories -tree_id $tree_id]
    set units [lsort -increasing $units]
    if { [llength $units] > 0 } {
        foreach unit $units {
            set categories [category::get_children -category_id $unit]
            set categories [lsort -increasing $categories]
            if { [llength $categories] > 0 } {
                foreach category $categories {
                    set subcategories [category::get_children \
                        -category_id $category]
                    set subcategories [lsort -increasing $subcategories]
                    foreach subcategory $subcategories {
                        set objects [category::get_objects \
                            -category_id $subcategory]
                        if {[llength $objects] > 0} {
                            set object_id [lindex $objects 0]
                            set page_name [db_string get_page_name {} \
                                -default ""]
                            return $page_name
                        }
                    }
                    set objects [category::get_objects -category_id $category]
                    if {[llength $objects] > 0} {
                        set object_id [lindex $objects 0]
                        set page_name [db_string get_page_name {} -default ""]
                        return $page_name
                    }
                }
            }
            set objects [category::get_objects -category_id $unit]
            if {[llength $objects] > 0} {
                set object_id [lindex $objects 0]
                set page_name [db_string get_page_name {} -default ""]
                return $page_name
            }
        }
    }
    return ""
}

ad_proc -public learning_content::get_first_item_from_category_id {
    {-category_id:required}
    {-folder_id:required}
} {
    Get the first item mapped to the category
} {
    set name [db_string get_first_item {} -default ""]
    return $name
}

ad_proc -public learning_content::get_first_tree_item_from_category_id {
    {-category_id:required}
    {-folder_id:required}
} {
    Get the first visible item in the tree below the category
} {
    set categories [category::get_children -category_id $category_id]
    set categories [lsort -increasing $categories]
    foreach category $categories {
        set subcategories [category::get_children -category_id $category]
        set subcategories [lsort -increasing $subcategories]
        foreach subcategory $subcategories {
            set name [learning_content::get_first_item_from_category_id \
                -category_id $subcategory -folder_id $folder_id]
            if { ![empty_string_p $name] } {
                return $name
            }
        }
        set name [learning_content::get_first_item_from_category_id \
            -category_id $category -folder_id $folder_id]
        if { ![empty_string_p $name] } {
            return $name
        }
    }
    set name [learning_content::get_first_item_from_category_id \
        -category_id $category_id -folder_id $folder_id]
    return $name
}

ad_proc -public learning_content::get_unit_id {
    {-category_id:required}
} {
    Get the unit id of the category
} {
    if {![empty_string_p $category_id]} {
        set parent_id [category::get_parent -category_id $category_id]
        while { $parent_id != 0 && $category_id != $parent_id} {
            set category_id $parent_id
            set parent_id [category::get_parent -category_id $parent_id]
        }
    }
    return $category_id
}

ad_proc -public learning_content::get_activity_id {
    {-item_id:required}
} {
    Get the activity_id related to the item_id
} {
    set result [db_string activity_id { *SQL* } -default 0]
    return $result
}

ad_proc -public learning_content::activity_exists_p {
    {-item_id:required}
} {
    Check if there is an activity_id related to the item_id
} {
    set result [db_string activity_exists { *SQL* } -default 0]
    return $result
}

ad_proc -public learning_content::activity_new {
    {-item_id:required}
    {-activity_id:required}
} {
    Insert a new activity
} {
    if { [exists_and_not_null item_id] && $item_id != 0 } {
        if {![learning_content::activity_exists_p -item_id $item_id]} {
            db_dml insert_activity { *SQL* }
        }
    }
}

ad_proc -public learning_content::activity_edit {
    {-item_id:required}
    {-activity_id:required}
} {
    Edit an existing activity
} {
    db_dml update_activity { *SQL* }
}

ad_proc -public learning_content::copy {
    {-src_community_id:required}
    {-dst_community_id:required}
} {
    Copy Content information from current community into another community.
} {

    set src_package_id [db_string get_src_package_id "" -default 0]
    set dst_package_id [db_string get_dst_package_id "" -default 0]

    if { $dst_package_id == 0 } {
        dotlrn_community::add_applet_to_community \
            $dst_community_id dotlrn_learning_content
        set dst_package_id [db_string get_dst_package_id "" -default 0]
	$dst_package_id destroy
    }

    ::xowiki::Package initialize -parameter {
        {-object_type ::xowiki::Page}
        {-objects ""}
    } -package_id $src_package_id

    set folder_id [::$package_id folder_id]

    if {$objects eq ""} {
        set sql [$object_type instance_select_query -folder_id $folder_id \
        -with_subtypes true]
        db_foreach instance_select $sql { lappend item_ids $item_id }
    } else {
        foreach o $objects {
            if {[set id [CrItem lookup -name $o -parent_id $folder_id]] != 0} {
                lappend item_ids $id
            }
        }
    }

    set content ""

    append content "set  object_name_category_id_map \[list\] " \n
    append content "set  objects_list \[list\] " \n
    append content "set  original_package_id  $src_package_id " \n

    foreach item_id $item_ids {

        ::xowiki::Package instantiate_page_from_id -item_id $item_id
        #
        # if the page belongs to an Form/PageTemplate, include it as well
        #
        if {[$item_id istype ::xowiki::PageInstance]} {
            set template_id [$item_id page_template]
            if {[lsearch $item_ids $template_id] == -1 \
                && ![info exists included($template_id)]} {
                ::xowiki::Package instantiate_page_from_id -item_id $template_id
                append content "[$template_id marshall]" \n
                set included($template_id) 1
            }
        }

        lappend item_category_list [list $item_id \
            [learning_content::get_item_category_name -item_id $item_id]]
        append content "[$item_id marshall]" \n
        append content "lappend object_name_category_id_map {  \
            [$item_id set name] \
            [category::get_mapped_categories $item_id] }" \n
        append content "lappend objects_list { \
            [$item_id set name] [$item_id item_id] }" \n
    }
    foreach item_id $item_ids {
	$item_id destroy
    }

    #getting the content categories
    set categories [list]
    set original_categories [list]

    foreach tree [category_tree::get_mapped_trees $package_id] {
        foreach { tree_id tree_name } $tree {
            if { [string equal $tree_name \
                "\#learning-content.choose_location\#"] } {

                foreach category_info [category_tree::get_tree $tree_id] {
                    foreach {cid category_label deprecated_p level} \
                       $category_info {break}
                    lappend categories $cid
                    lappend categories [category::get_name  $cid]
                    set category_parent [category::get_parent \
                        -category_id $cid]
                    set one_category [list $cid $category_label $level \
                        $category_parent]
                    lappend original_categories $one_category
                }
            }
        }
    }
    append content "set this_package_id $dst_package_id" \n
    append content "set this_folder_id \[\$this_package_id folder_id\]" \n
    append content "set category_map \
        \[learning_content::create_target_category_tree_and_map_source_category_tree \
        -original_categories \[list $original_categories \] -package_id \
         $dst_package_id \]\n"
    ## Check for activities and insert them into the new instance
    append content "learning_content::parse_all_instance \
        -original_package_id \$original_package_id \
        -new_package_id \$this_package_id\n"
    append content "ad_schedule_proc -once t 5 \
         learning_content::map_objects_to_categories \
        -categories_map \$category_map \
        -object_category_map \$object_name_category_id_map \
        -package_id $dst_package_id \
        -folder_id \$this_folder_id\n"

    set src_folder_id $folder_id
    set package_url [apm_package_url_from_id $dst_package_id]
    $package_id destroy
    ::xowiki::Package initialize -package_id $dst_package_id
    set dst_folder_id [::$package_id folder_id]
    foreach o [::xowiki::Page allinstances] {
        set preexists($o) 1
    }

    if {[catch {namespace eval ::xo::import $content} error]} {
        set msg "Error: $error"
        set result 0
    } else {
        set objects [list]
        foreach o [::xowiki::Page allinstances] {
            if {![info exists preexists($o)]} {lappend objects $o}
        }
        set msg [$package_id import -objects $objects -replace 0]
        # map all the new activity pages after creating them
        learning_content::map_activity_objects -src_folder_id $src_folder_id \
            -dst_folder_id $dst_folder_id
        learning_content::copy_glossary_words_count -src_folder_id $src_folder_id \
            -dst_folder_id $dst_folder_id
        set result 1
    }
    namespace delete ::xo::import
    $package_id destroy
    return $result
}


ad_proc -public learning_content::category::delete_p {
    {-tree_id:required}
    {-category_id:required}
} {
    set tree_list [learning_content::category::get_tree_levels \
                        -subtree_id $category_id -tree_id $tree_id]
    set tree_list [linsert $tree_list 0 $category_id]
    foreach category $tree_list {
        set my_category_id [lindex $category 0]
        if {[db_string check_mapped_objects {}] eq 1} {
            return 0
        }
    }
    return 1
}

ad_proc -public learning_content::category::page_order {
    {-tree_id:required}
    {-category_id:required}
    {-wiki_folder_id:required}
} {
    set tree_list [learning_content::category::get_tree_levels \
        -subtree_id $category_id \
        -tree_id $tree_id]
    set tree_list [linsert $tree_list 0 $category_id]
    foreach cat_tree $tree_list {
        set cat_id [lindex $cat_tree 0]
        set page_list [db_list_of_lists select_content {}]
        if {[llength $page_list] > 0} {
            break
        }
    }
    return $page_list
}

ad_proc -public learning_content::get_next_page_order {
} {
    set folder_id [content::folder::get_folder_from_package \
                      -package_id [ad_conn package_id]]
    set list_page_order [db_list select_order ""]
    set max_page_order [lindex [lsort -decreasing \
        -command learning_content::simple_compare $list_page_order] 0]
    if {[llength $list_page_order] < 1} {
        set max_page_order 0
    }
    incr max_page_order
    return $max_page_order
}

ad_proc -public learning_content::category::category_childs {
    {-tree_id:required}
    {-category_id:required}
    {-wiki_folder_id:required}
} {
    set tree_list [learning_content::category::get_tree_levels \
        -subtree_id $category_id -tree_id $tree_id]
    set tree_list [linsert $tree_list 0 [list $category_id "n"]]
    foreach category $tree_list {
        set cat_id [lindex $category 0]
        set count [db_string select_cat {*SQL*} -default 0]
        if {$count > 0} {
            return 1
        }
    }
    return 0
}

ad_proc -public learning_content::category::delete {
    {-tree_id:required}
    {-category_ids:required}
    {-locale ""}
} {
    set user_id [auth::get_user_id]
    permission::require_permission \
        -object_id $tree_id \
        -privilege category_tree_write
    set result 1
    db_transaction {
        foreach category_id [db_list order_categories_for_delete ""] {
            category::delete $category_id
        }
        category_tree::flush_cache $tree_id
    } on_error {
        set result 0
    }
    return $result
}

ad_proc -private learning_content::category::valid_level_and_count {
    {-tree_id:required}
    {-category_id:required}
} {
    set tree_list [learning_content::category::get_tree_levels -tree_id $tree_id]
    set my_level [lindex \
                    [lindex $tree_list \
                        [lsearch -regexp \
                                $tree_list $category_id]] \
                    3]
    if {$my_level > 2} {
        return 0
    }
    set sub_tree_list [learning_content::category::get_tree_levels -only_level 1 \
                        -subtree_id $category_id -tree_id $tree_id]

    if {[llength $sub_tree_list] >= 5} {
        return 0
    }
    return 1
}


ad_proc -private learning_content::category::map_new_tree {
    {-object_id:required}
    {-tree_name:required}
    {-user_id ""}
} {

    if {[empty_string_p $user_id]} {
        set user_id [ad_conn user_id]
    }

    db_transaction {
        set tree_id [category_tree::add -name $tree_name -user_id $user_id]
        learning_content::category::new_subtree -tree_id $tree_id -user_id $user_id
        category_tree::map -tree_id $tree_id \
            -object_id $object_id \
            -assign_single_p t \
            -require_category_p t \
            -widget ""
    }
    return $tree_id
}

ad_proc -private learning_content::category::new_subtree {
    {-tree_id:required}
    {-language "en_US"}
    {-user_id ""}
} {

    if {[empty_string_p $user_id]} {
        set user_id [ad_conn user_id]
    }
    set description "New unit for content"
    set parent_id [db_null]
    set unit_id [category::add -tree_id $tree_id \
                    -parent_id $parent_id \
                    -locale $language \
                    -name "Unidad N" \
                    -user_id $user_id \
                    -description $description]

    category::add -tree_id $tree_id \
        -parent_id $unit_id \
        -locale $language \
        -name "Introduccion" -description $description

    category::add -tree_id $tree_id \
        -parent_id $unit_id \
        -locale $language \
        -name "Contenido" \
        -user_id $user_id \
        -description $description

    category::add -tree_id $tree_id \
        -parent_id $unit_id \
        -locale $language \
        -name "Actividades" \
        -user_id $user_id \
        -description $description

    category::add -tree_id $tree_id \
        -parent_id $unit_id \
        -locale $language \
        -name "Anexo" \
        -user_id $user_id \
        -description $description
    return $unit_id
}

ad_proc -private learning_content::category::category_parent {
    -category_id
    -tree_id
    {-level 0}
} {
    if {[db_0or1row select_parent {*SQL*}]} {
        if {![empty_string_p $parent_id] && $level eq 0} {
            return [learning_content::category::category_parent -category_id $parent_id \
                -tree_id $tree_id]
        } elseif {![empty_string_p $parent_id] && $level ne 0} {
            return $parent_id
        } else {
            return $category
        }
    }
}

ad_proc -public learning_content::value_compare {
    {-def:required}
    x
    y
} {
    set xp [string first . $x]
    set yp [string first . $y]
    if {$xp == -1 && $yp == -1} {
        if {$x < $y} {
            return -1
        } elseif {$x > $y} {
            return 1
        } else {
            return $def
        }
    } elseif {$xp == -1} {
        set yh [string range $y 0 [expr {$yp-1}]]
        return [value_compare -def -1 $x $yh]
    } elseif {$yp == -1} {
        set xh [string range $x 0 [expr {$xp-1}]]
        return [value_compare -def 1 $xh $y]
    } else {
        set xh [string range $x 0 $xp]
        set yh [string range $y 0 $yp]
        if {$xh < $yh} {
            return -1
        } elseif {$xh > $yh} {
            return 1
        } else {
            incr xp
            incr yp
            return [value_compare -def $def [string range $x $xp end] \
                [string range $y $yp end]]
        }
    }
}

ad_proc -public learning_content::compare {
    a
    b
} {
    set x [lindex $a 1]
    set y [lindex $b 1]
    return [learning_content::value_compare -def 0 $x $y]
}

ad_proc -public learning_content::simple_compare {
    a
    b
} {
    return [learning_content::value_compare -def 0 $a $b]
}

ad_proc -public learning_content::category::get_tree_levels {
    {-all:boolean}
    {-subtree_id ""}
    {-to_level 0}
    {-only_level 0}
    {-tree_id:required}
    {-locale ""}
} {
    Get all categories of a category tree from the cache.

    @option all Indicates that phased_out categories should be included.
    @option subtree_id Return only categories of the given subtree.
    @param tree_id category tree to get the categories of.
    @param locale language in which to get the categories. [ad_conn locale]
    used by default.
    @return tcl list of lists: category_id category_name deprecated_p level
} {
    if {[catch {set tree [nsv_get category_trees $tree_id]}]} {
        return
    }
    if {$to_level ne 0 && $only_level ne 0} {
        set only_level 0
    }
    set result ""
    if {[empty_string_p $subtree_id]} {
        foreach category $tree {
            util_unlist $category category_id deprecated_p level
            if {$all_p || $deprecated_p == "f"} {
                if {$to_level < $level && $to_level ne 0} {
                    continue
                }
                if {$only_level ne $level && $only_level ne 0} {
                    continue
                }
                lappend result [list $category_id \
                    [category::get_name $category_id $locale] \
                    $deprecated_p $level]
            }
        }
    } else {
        set in_subtree_p 0
        set subtree_level 0
        foreach category $tree {
            util_unlist $category category_id deprecated_p level
            if {$level == $subtree_level || $level < $subtree_level} {
                set in_subtree_p 0
            }
            if {$in_subtree_p && $deprecated_p == "f"} {
                if {$to_level < [expr $level - $subtree_level] \
                    && $to_level ne 0} {
                    continue
                }

                if {$only_level ne [expr $level - $subtree_level] \
                    && $only_level ne 0} {
                    continue
                }

                lappend result [list $category_id [category::get_name \
                     $category_id $locale] $deprecated_p \
                    [expr $level - $subtree_level]]
            }
            if {$category_id == $subtree_id} {
                set in_subtree_p 1
                set subtree_level $level
            }
        }
    }
    return $result
}

ad_proc -public learning_content::category::get_under_categories {
    {-category_id:required}
    {-parent_id:required}
} {
    Get the categories under the specified category
} {
    set categories [db_list get_under_categories {*SQL*}]
    return $categories
}

ad_proc -public learning_content::category::get_over_categories {
    {-category_id:required}
    {-parent_id:required}
} {
    Get the categories over the specified category
} {
    set categories [db_list get_over_categories {*SQL*}]
    return $categories
}
