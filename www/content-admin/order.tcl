ad_page_contract {
    @author byron Haroldo Linares Roman
    @creation-date 2007-07-04
} {
    page_id:optional
    page_pos:optional
    page_name:optional
    content_id:optional
    status:optional
    dir:optional
    show:optional
    {action 0}
}

if {![string match $page_pos "@page_order@"]} {
    set wiki_folder_id [::xowiki::Page require_folder -name xowiki \
        -package_id $content_id]
    set item_id [content::revision::item_id -revision_id $page_id]
    if {![ permission::permission_p -object_id $item_id -privilege admin]} {
        set show 0
    } else {
        set my_cat_id [category::get_mapped_categories $item_id]
        set count_page [db_string select_count { *SQL* } -default 0]
        if {$count_page > 1} {
            set show 1
        } else {
            set show 0
        }
    }
} else {
    set show 0
}

