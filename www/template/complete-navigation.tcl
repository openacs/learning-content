ad_page_contract {
    @author byron Haroldo Linares Roman (bhlr@byronLs-Computer.local)
            Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date 2007-07-18
} {
    page_pos:optional
    page_id:optional
    content_id:optional
    type:optional
    category_id:optional
}

set title "title bar"
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
    set cat_name [category::get_name $my_cat_id]
    set tree_id [category::get_tree $my_cat_id]
    set my_parent_id [learning_content::category::category_parent \
                            -category_id $my_cat_id\
                            -tree_id $tree_id]
    set my_parent_id1 [learning_content::category::category_parent \
                            -category_id $my_cat_id \
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

} else {
    set show 0
}
