ad_page_contract {
    @author byron Haroldo Linares Roman (bhlr@byronLs-Computer.local)
            Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date 2007-09-06
} {
    page_pos:optional
    page_id:optional
    content_id:optional
    index:optional
    category_id:optional
}

set show 0
set wiki_url "[ad_conn package_url]"
if {![string match $page_id "@revision_id@"]} {
    set show 1
    set form_tree_list [list]
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

    set tree_list [learning_content::category::get_tree_levels -only_level 1 \
                        -tree_id $tree_id]
    set categories_objects [db_list_of_lists select_cat {*SQL*}]
    foreach tree_level $categories_objects {
        set unit_parent [learning_content::category::category_parent \
                            -category_id [lindex $tree_level 1] \
                            -tree_id $tree_id]
        set unit_index [lsearch -regexp $tree_list $unit_parent]

        if {$unit_index >= 0 \
                && [lsearch -regexp $form_tree_list $unit_parent] < 0} {

            lappend form_tree_list \
                [list [lindex [lindex $tree_list $unit_index] 1] \
                    [lindex [lindex $tree_list $unit_index] 0]]
        }
    }

    ad_form -name unidad -export { wiki_folder_id } -form {
        {category:integer(select)
            {label "Chapter"}
            {options $form_tree_list}
            {value $my_parent_id}
            {html {onChange document.unidad.submit() class "options"}}
        }
    } -on_submit {
	set first_page [learning_content::get_first_tree_item_from_category_id \
			    -category_id $category -folder_id $wiki_folder_id]
        ad_returnredirect ${wiki_url}${first_page}
    }
}