ad_page_contract {
    Insert Word into Content Glossary
    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date 2008-04-19
} {
    {word ""}
    {description ""}
    {word_id 0}
    {return_url ""}
}

set package_id [ad_conn package_id]
set folder_id [content::folder::get_folder_from_package \
                    -package_id $package_id]

permission::require_permission -object_id $package_id -privilege admin

::xowiki::Package initialize -package_id $package_id
if { $word_id == 0 } {
    set page_template [content::item::get_id_by_name \
                            -name "en:glossary" -parent_id $folder_id]
    set f [::xowiki::FormPage new -destroy_on_cleanup \
            -package_id $package_id \
            -parent_id $folder_id \
            -publish_status "production" \
            -page_template $page_template]
    set word [string tolower [string trim $word]]
    set description [string trim $description]
    set atts [list "description" $description "word" $word]
    $f set name $word
    $f set instance_attributes $atts
    set word_id [$f save_new]
    set result $word
} else {
    set word [string trim $word]
    if { $word_id != 0 } {
        set item_id $word_id
    } else {
        set item_id [db_string get_item_id {} -default 0]
    }
    set page [xowiki::Package instantiate_page_from_id \
                -item_id $item_id]
    set word [string tolower [string trim $word]]
    set description [string trim $description]
    set atts [list "description" $description "word" $word]
    $page set instance_attributes $atts
    $page set name $word
    $page save
    ns_cache flush xotcl_object_cache ::$item_id
    set result $word
}
if { ![empty_string_p $return_url] } {
    ad_returnredirect $return_url
}