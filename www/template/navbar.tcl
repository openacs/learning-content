ad_page_contract {
    @author byron Haroldo Linares Roman (bhlr@byronLs-Computer.local)
            Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date 2007-06-20
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
set styleb ""
set stylec ""
set cat_id 0
set list_categories [list]

set wiki_url "[ad_conn package_url]"
if {![string match $page_pos "@page_order@"]} {
    set show 1
set wiki_folder_id [::xowiki::Page require_folder -name xowiki \
                            -package_id $content_id]
    set item_id [content::revision::item_id -revision_id $page_id]
    if {[exists_and_not_null category_id]} {
        set my_cat_id $category_id
        set stylec "class=\"current\""
    } else {
        set my_cat_id [category::get_mapped_categories $item_id]
    }
    set tree_id [category::get_tree $my_cat_id]
    set parent_id [learning_content::category::category_parent \
                        -category_id $my_cat_id \
                        -tree_id $tree_id]
    set parent_id1 [learning_content::category::category_parent \
                            -category_id $my_cat_id \
                            -level 1 \
                            -tree_id $tree_id]
    set tree_list [learning_content::category::get_tree_levels \
                        -subtree_id $parent_id \
                        -to_level 1 \
                        -tree_id $tree_id]

    if {[llength $tree_list] < 1} {
        set show 0
        ad_return_template
    }

    set bar_category [lindex $tree_list [expr $index - 1]]
    set cat_name [lindex $bar_category 1]

    set cat_id [lindex $bar_category 0]

    if {[empty_string_p $cat_id]} {
        set cat_id 0
    }

    set page_list [learning_content::category::page_order -tree_id $tree_id \
                    -category_id $cat_id \
                    -wiki_folder_id $wiki_folder_id]
    if {[llength $page_list] > 0} {
	set name [learning_content::get_first_tree_item_from_category_id \
		     -category_id $cat_id -folder_id $wiki_folder_id]
        set nexturl "${wiki_url}${name}\#cont1"
        if {($cat_id eq $my_cat_id) \
                || ($parent_id1 eq $cat_id)} {
            set styleb "class=\"current\""
        }
    } else {
        set show 0
    }
} else {
    set show 0
}


