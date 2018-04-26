ad_page_contract {
    Display all words from the glossary in alphabetical order
    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date 2008-04-29
} {
    {letter ""}
} -properties {
    context:onevalue
    page_title:onevalue
}

set page_title [_ learning-content.glossary]
set context [list $page_title]
set package_id [ad_conn package_id]
set admin_p [permission::permission_p -object_id $package_id \
    -privilege admin -party_id [ad_conn user_id]]
set folder_id [content::folder::get_folder_from_package \
    -package_id $package_id]
set return_url [ad_return_url]
set category_id [ns_queryget "category_id"]
set glossary_url "[ad_conn url]?category_id=$category_id"
set content ""

if {[string equal $letter ""]} {
    set filter "|  <b>[_ learning-content.All]</b>  |"
} else {
    set letter [string tolower $letter]
    set filter "|  <a href=\"${glossary_url}\">[_ learning-content.All]</a>  |"
}
set initials [db_list get_initials {}]
foreach initial $initials {
    if {[string equal $initial $letter]} {
        append filter "  <b>[string toupper $initial]</b>  |"
    } else {
        append filter "  <a href=\"${glossary_url}&letter=${initial}\">"
        append filter "[string toupper $initial]</a>  |"
    }
}
append letter "%"
set form_page_ids [db_list get_form_page_ids {}]

set elements {}
if { $admin_p } {
    lappend elements edit {
        label "[_ learning-content.edit]"
        html {style "width: 15px; text-align: center;"}
        link_url_col edit_url
        link_html { title "[_ learning-content.edit]" }
        display_template "<img src=\"/resources/acs-subsite/Edit16.gif\" />"
    }
}

lappend elements word {
    label "[_ learning-content.word] / [_ learning-content.definition]"
    display_template "<div id=\"glossary_@get_words.name@\"><b>@get_words.name@</b></div><br /> \
        <div id=\"def__@get_words.item_id@__\">@get_words.definition@</div>"
}

if { $admin_p } {
    lappend elements count {
        label "[_ learning-content.appearances]"
        html {style "width: 25px; text-align: center;"}
        display_template "@get_words.count@"
    }
    lappend elements delete {
        label "[_ learning-content.delete]"
        html {style "width: 15px; text-align: center;"
            onclick "return(confirm('Are you sure?'));"}
        link_url_col delete_url
        link_html { title "[_ learning-content.delete]" }
        display_template "<img src=\"/resources/acs-subsite/Delete16.gif\" />"
    }
}

db_multirow -extend { definition edit_url delete_url count } \
    get_words get_words_info {} {

    set atts [db_list get_form_pages {}]
    set definition [lindex [lindex $atts 0] 1]
    set edit_url [export_vars -base "edit-glossary-word" {{word_id $item_id} \
        return_url}]
    set delete_url [export_vars -base "delete-glossary-word" \
        {item_id return_url}]
    set times_used [db_string get_term_count {} -default 0]
    if { [empty_string_p $times_used] } {
        set count 0
    } else {
        set count $times_used
    }
}

set bulk_action_vars {}
set bulk_actions {}
if { $admin_p } {
    lappend bulk_action_vars return_url
    lappend bulk_actions "[_ learning-content.delete]" "delete-glossary-word"\
 "[_ learning-content.delete]"
}

list::create -name glossary_words \
    -multirow get_words \
    -key item_id \
    -no_data "[_ learning-content.there_are_no_words]"\
    -bulk_action_export_vars $bulk_action_vars \
    -bulk_actions $bulk_actions \
    -html { style "width: 100%;" } \
    -elements $elements \
    -main_class { mylist }
