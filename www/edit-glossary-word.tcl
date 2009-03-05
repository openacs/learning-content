ad_page_contract {
    Edit a glossary word
    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date 2008-04-20
} {
    {word_id 0}
    {return_url ""}
}

if { $word_id == 0 } {
    set page_title [_ learning-content.new_word]
    set context [list \
        [list "$return_url" [_ learning-content.glossary]] \
            "[_ learning-content.new_word]"]
    set disabled ""
} else {
    set page_title [_ learning-content.edit_word]
    set context [list [list "$return_url" [_ learning-content.glossary]] \
        "[_ learning-content.edit_word]"]
    set disabled "disabled disabled"
}

set package_id [ad_conn package_id]
set folder_id [content::folder::get_folder_from_package \
    -package_id $package_id]
permission::require_permission -object_id $package_id -privilege admin

set revision_id [content::item::get_live_revision -item_id $word_id]
set data [db_string get_data {} -default ""]
if { [llength $data] > 0 } {
    set word [lindex $data 3]
    set description [lindex $data 1]
} else {
    set word ""
    set description ""
}


ad_form -name glossary -export { {word_name $word} } \
-form {
    {word:text(text),optional    {label "[_ learning-content.word]"}
        {html {id "word" value "$word" size 44 $disabled}}}
    {word_id:text(hidden),optional {html {id "word_id" value "$word_id"}}}
    {description:text(textarea),optional 
        {label "[_ learning-content.definition]"} {value "$description"}
        {html {id "description" rows 20 cols 50}}}
    {return_url:text(hidden),optional
        {html {id "return_url" value "$return_url"}}}
} -validate {
    {word
        {![db_string check_if_exists {} -default 0]}
        "[_ learning-content.word_already_exist]"
    }
    {word
        { ![empty_string_p $word] || $word_id != 0}
        "[_ learning-content.word_not_blank]"
    }
} -on_submit {
    if { [empty_string_p $word] } {
        set word $word_name
    }
    set exp_vars [export_vars -base "insert-glossary-entry" \
        {return_url word_id word description}]
    ad_returnredirect $exp_vars
}