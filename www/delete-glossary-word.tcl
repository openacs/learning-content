ad_page_contract {
    Delete Glossary Word(s) from CR and CONTENT_GLOSSARY
    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date 2008-04-20
} {
  item_id:multiple,integer
  return_url
}

set words $item_id
set p_id [ad_conn package_id]
permission::require_permission -object_id $p_id -privilege admin
set changed_p 0
db_transaction {
    ::xowiki::Package initialize -package_id $p_id 
    set folder_id [content::folder::get_folder_from_package -package_id $p_id]

    db_foreach get_pages { *SQL* } {

        set revision_id [content::item::get_live_revision -item_id $page_id]
        set page [xowiki::Package instantiate_page_from_id -item_id $page_id]
        set instance_attributes [$page set instance_attributes]
        set content [lindex $instance_attributes 1]
        foreach item $words {
            set item_name [db_string get_name { *SQL* } -default ""]
            set reg_exp_var "(.*)(<a( id=\"${item_name}__\[0-9\]+__\"| "
	    append reg_exp_var "class=\"glossary__content__\"| href=\"\[^\"\]*\"| "
	    append reg_exp_var "style=\"\[^\"\]*\")+>)(.*)"
            while {[regexp -nocase $reg_exp_var $content \
                    match lside var2 var3 rside]} {
                if { [regsub -nocase "(.*?)</a>" $rside {\1} result] } {
                    set changed_p 1
                    set content "${lside}${result}"
                }
            }
        }
        if { $changed_p } {
            set new_page [list "contenido" $content]
            $page set instance_attributes $new_page
            $page save
        }
    }
    foreach item $words {
        set item_name [db_string get_name { *SQL* } -default ""]
        $package_id delete -item_id $item -name $item_name
        catch {
            db_dml delete_word { *SQL* }
        } error
    }
}
ad_returnredirect "$return_url"
