ad_page_contract {
    Get a glossary word for the tooltip
    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date 2008-04-28
} {
    {word ""}
}

set package_id [ad_conn package_id]
set folder_id [content::folder::get_folder_from_package -package_id $package_id]
set item_id [db_string get_item_id {} -default 0]
set revision_id [content::item::get_live_revision -item_id $item_id]
set atts [db_string get_attributes {} -default ""]
set word [lindex $atts 3]
set desc [lindex $atts 1]
