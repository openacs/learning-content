ad_page_contract {
    @author byron Haroldo Linares Roman (bhlr@byronLs-Computer.local)
            Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date 2007-07-04
} {
    page_pos:optional
    page_id:optional
    content_id:optional
    type:optional
    index:optional
    category_id:optional
}

set title "navbar"
set cat_index [list]
set index1 100
set index2 100
set index3 100
set index4 100
set index5 100
set index6 100
set wiki_url "[ad_conn package_url]"
if {![string match $page_pos "@page_order@"]} {
    set show 1
    set wiki_folder_id [::xowiki::Page require_folder -name xowiki \
                            -package_id $content_id]
    set item_id [content::revision::item_id -revision_id $page_id]
    if {[exists_and_not_null category_id]} {
        set my_cat_id $category_id
    } else {
        set my_cat_id [category::get_mapped_categories $item_id]
    }
    set tree_id [category::get_tree $my_cat_id]
    set my_parent_id [learning_content::category::category_parent \
                            -category_id $my_cat_id \
                            -tree_id $tree_id]
    set tree_list [learning_content::category::get_tree_levels \
        -subtree_id $my_parent_id -to_level 1 -tree_id $tree_id]

    if {[llength $tree_list] < 1} {
        set show 0
        ad_return_template
    }

    set my_cat_index [expr [lsearch -regexp $tree_list $my_cat_id] + 1]

    set categories_objects [db_list_of_lists select_cat {*SQL*}]

    for {set i [expr [llength $tree_list] -1]} {$i >= 0} {incr i -1} {
        set category [lindex $tree_list $i]
        if {[learning_content::category::category_childs \
                -tree_id $tree_id \
                -category_id [lindex $category 0] \
                -wiki_folder_id $wiki_folder_id]} {
            lappend cat_index [lsearch -regexp $tree_list [lindex $category 1]]
        }
    }

    if {[llength $cat_index] < 1} {
        set show 0
    }

    for {set i 0} {$i < 6} {incr i} {
        set adp_index [expr $i + 1]
        if {$i < [llength $cat_index]} {
            set index$adp_index [expr [lindex $cat_index $i] + 1]
        } elseif {$i eq [llength $cat_index]} {
            set index$adp_index 0
        } else {
            set index$adp_index 100
        }
    }

} else {
    set show 0
}

