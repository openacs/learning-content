ad_page_contract {
    @author byron Haroldo Linares Roman (bhlr@byronLs-Computer.local)
            Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date 2007-06-20
} {
    page_pos:optional
    page_id:optional
    content_id:optional
    wiki_folder_id:optional
    dir:optional
}
set page_list [list]
set show 0
set next_list [list]
set wiki_url "[ad_conn package_url]"
if {![string match $page_pos "@page_order@"]} {
    set show 1
    set wiki_folder_id [::xowiki::Page require_folder -name xowiki \
                            -package_id $content_id]
    set item_id [content::revision::item_id -revision_id $page_id]
    set cat_id [category::get_mapped_categories $item_id]
    set tree_id [category::get_tree $cat_id]
    set my_parent_id [learning_content::category::category_parent \
                        -category_id $cat_id\
                        -tree_id $tree_id]
    set my_parent_id1 [learning_content::category::category_parent \
                        -category_id $cat_id\
                        -level 1 \
                        -tree_id $tree_id]
    set tree_list [learning_content::category::get_tree_levels \
                        -subtree_id $my_parent_id \
                        -to_level 1 \
                        -tree_id $tree_id]

    if {[llength $tree_list] < 1} {
        set show 0
        ad_return_template
    }

    set cat_index [lsearch -regexp $tree_list $cat_id]

    if {$cat_index < 0} {
        set cat_index [expr [lsearch -regexp $tree_list $my_parent_id1] + 0]
    }

    db_foreach select_page { *SQL* } {
        lappend page_list [list $item_id $page_order $name $revision_id]
    }

    set order_page [lsort -$dir -command learning_content::compare $page_list]

    set count 0
    foreach pages $order_page {
        set current_pos [lsearch -exact $pages $page_id]
        if {$current_pos >= 0} {
            incr count
            set next_list [lindex $order_page $count]
            break
        }
        incr count
    }

    if {[llength $next_list] > 0} {
        set nexturl "${wiki_url}[lindex $next_list 2]"
    } else {
## If there's not an adjacent page make the navigation continue
        set next_item 0
        switch $dir {
            "decreasing" {
                set order "desc"
                if { $next_item == 0 } {
                    while { $cat_id != 0 } {
                        set parent_id [category::get_parent -category_id $cat_id]
                        set subcategories [learning_content::category::get_under_categories \
                                            -category_id $cat_id -parent_id $parent_id]
                        foreach subcategory $subcategories {
                            set category_id $subcategory
                            set next_item [db_string get_next_item {*SQL*} \
                                -default 0]
                            if { $next_item == 0 } {
                                set in_subcategories \
                                    [category::get_children \
                                        -category_id $category_id]
                                set in_subcategories [lsort \
                                    -decreasing $in_subcategories]
                                foreach in_subcategory $in_subcategories {
                                    set category_id $in_subcategory
                                    set next_item \
                                        [db_string get_next_item {*SQL*} \
                                            -default 0]
                                    if {$next_item > 0} {
                                        break
                                    }
                                }
                            }
                            if { $next_item != 0 } break
                        }
                        if { $next_item != 0 } break
                        set cat_id $parent_id
                    }
                }
            }
            "increasing" {
                set order "asc"
                while {$cat_id != 0} {
                    set parent_id [category::get_parent -category_id $cat_id]
                    set subcategories [learning_content::category::get_over_categories                              -category_id $cat_id -parent_id $parent_id]
                    foreach subcategory $subcategories {
                        set in_subcategories [category::get_children \
                                                -category_id $subcategory]
                        set in_subcategories [lsort -increasing $in_subcategories]
                        foreach in_subcategory $in_subcategories {
                            set category_id $in_subcategory
                            set next_item [db_string get_next_item { *SQL* } \
                                -default 0]
                            if { $next_item != 0 } {
                                break
                            }
                        }
                        if { $next_item == 0 } {
                            set category_id $subcategory
                            set next_item [db_string get_next_item {*SQL*} \
                                -default 0]
                        }
                        if { $next_item != 0 } break
                    }
                    if { $next_item == 0 } {
                        set category_id $parent_id
                        set next_item [db_string get_next_item {*SQL*} \
                            -default 0]
                    }
                    if { $next_item != 0 } break
                    set cat_id $parent_id
                }
            }
        }
        if { $next_item == 0 } {
            set show 0
        } else {
            set nexturl "${wiki_url}${next_item}"
        }
    }
    switch $dir {
        "decreasing" {
            set img_name "prev"
            set alt [_ learning-content.back]
        }
        "increasing" {
            set img_name "next"
            set alt [_ learning-content.next]
        }
    }
} else {
    set show 0
}


