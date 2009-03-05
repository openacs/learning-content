ad_page_contract {
    Get a glossary word by name or id
    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date 2008-04-25
} {
    {word_id 0}
    {rels_p 0}
    {word ""}
    {def_p 0}
    {selected_id 0}
    {exists_p 0}
}

set content " "
set new_content " "
set new_p 0
set scolor "#AE9C9C"
set new_style "background: $scolor ;"
set package_id [ad_conn package_id]
set package_url [apm_package_url_from_id $package_id]
set folder_id [content::folder::get_folder_from_package -package_id $package_id]
if { $exists_p == 1 } {
    set exists_p [db_string check_if_exists {} -default 0]
    set content $exists_p
} elseif { $rels_p } {
    set word [string tolower [string trim $word]]
    db_multirow -extend { style } related_words get_rel_words { *SQL* } {
        if { $selected_id != "" && [string tolower $word] == $name } {
            set revision_id [content::item::get_live_revision \
                -item_id $item_id]
            set atts [db_string get_attributes {} -default ""]
            set desc [lindex $atts 1]
            set style "background: $scolor ;"
            set new_style ""
        } else {
            set style ""
        }
    }
    db_multirow other_words get_other_words { *SQL* } { }
} else {
    if { $word_id == 0 } {
        set item_id [db_string get_item_id {} -default 0]
    } else {
        set item_id $word_id
    }
    set revision_id [content::item::get_live_revision -item_id $item_id]
    set atts [db_string get_attributes {} -default ""]
    if  { $def_p } {
        set content [lindex $atts 3]
    } else {
        set content [lindex $atts 1]
    }
}

