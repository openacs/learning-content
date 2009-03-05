ad_page_contract {
    @author byron Haroldo Linares Roman (bhlr@byronLs-Computer.local)
            Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date 2007-09-03
} {
    page_pos:optional
    page_id:optional
    content_id:optional
    type:optional
    index:optional
    category_id:optional
}


set page_list [list]
set next_list [list]
set show 0
set width 76
set cat_id 0
set styles ""
set list_categories [list]

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
    set my_parent_id1 [learning_content::category::category_parent \
        -category_id $my_cat_id \
        -level 1 \
        -tree_id $tree_id]

    set tree_list [learning_content::category::get_tree_levels -subtree_id $my_cat_id \
        -to_level 1 -tree_id $tree_id]
    set level_2_list [learning_content::category::get_tree_levels -only_level 2 \
        -tree_id $tree_id]
    set level_3_list [learning_content::category::get_tree_levels -only_level 3 \
        -tree_id $tree_id]

    if {[llength $level_3_list] < 1 \
            || ([lsearch -regexp $level_2_list $my_cat_id] < 0 \
            && [lsearch -regexp $level_3_list $my_cat_id] < 0)} {
        set show 0
        ad_return_template
    } elseif {[lsearch -regexp $level_3_list $my_cat_id] >= 0} {
        set tree_list [learning_content::category::get_tree_levels \
            -subtree_id $my_parent_id1 \
            -to_level 1 -tree_id $tree_id]
    }

    if {[llength $tree_list] < 1} {
        set show 0
        ad_return_template
    }

    set parent_tree_list [learning_content::category::get_tree_levels \
        -subtree_id $my_parent_id \
        -to_level 1 -tree_id $tree_id]
    if {[llength $parent_tree_list] < 1} {
        set show 0
        ad_return_template
    }

    set parent_cat_index [expr [lsearch -regexp $parent_tree_list $my_cat_id] \
                                + 1]
    if {$parent_cat_index eq 0} {
        set parent_cat_index [expr [lsearch -regexp $parent_tree_list \
                                 $my_parent_id1] + 1]
    }

    set bar_category [lindex $tree_list [expr $index - 1]]
    set cat_name [lindex $bar_category 1]
    set cat_id [lindex $bar_category 0]
    if {[empty_string_p $cat_id]} {
        set cat_id 0
    }

    set page_list [db_list_of_lists select_content {*SQL*}]

    set order_page [lsort -increasing \
        -command learning_content::compare $page_list]

    if {[llength $order_page] > 0} {  
        set next_list [lindex $order_page 0]
        set nexturl "${wiki_url}[lindex $next_list 2]\#cont1"
        if {([lindex $next_list 5] eq $page_id) \
                || ($cat_id eq $my_cat_id) \
                || ($my_parent_id1 eq $my_cat_id)} {

            append parent_cat_index "_"
            set styles "class=\"selected\""
            set img_name "arrow2.gif"

        } else {
            set styles "class=\"not_selected\""
            set img_name "arrow.gif"
        }

    } else {
        set nexturl "0"
        set show 0
    }
}