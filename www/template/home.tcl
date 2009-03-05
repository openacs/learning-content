ad_page_contract {
    @author byron Haroldo Linares Roman (bhlr@byronLs-Computer.local)
            Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date 2007-06-20
} {
    page_pos:optional
    page_id:optional
    content_id:optional
    category_id:optional
}

if {![string match $page_pos "@page_order@"]} {
    set wiki_url "[ad_conn package_url]"
    set folder_id [::xowiki::Page require_folder -name xowiki \
			-package_id $content_id]
    set item_id [content::revision::item_id -revision_id $page_id]
    if {[exists_and_not_null category_id]} {
            set category_id $category_id
    } else {
        set category_id [category::get_mapped_categories $item_id]
    }

    set show 1
    set unit_id [learning_content::get_unit_id -category_id $category_id]
    set name [learning_content::get_first_tree_item_from_category_id \
		  -category_id $unit_id -folder_id $folder_id]

    set nexturl "${wiki_url}$name"
} else {
    set show 0
}