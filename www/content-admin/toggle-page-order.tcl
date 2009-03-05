ad_page_contract {
    @author byron Haroldo Linares Roman
    @creation-date 2007-06-25
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

set page_list [list]
set next_list [list]
if {![string match $page_pos "@page_order@"]} {
    set wiki_url "[ad_conn package_url]$page_name"
    set wiki_folder_id [::xowiki::Page require_folder -name xowiki \
        -package_id $content_id]
    set item_id [content::revision::item_id -revision_id $page_id]
    set cat_id [category::get_mapped_categories $item_id]

    if {![ permission::permission_p -object_id $item_id -privilege admin]} {
        set show 0
    } else {
        db_foreach select_page {*SQL*} {
            lappend page_list [list $tmp_item_id \
                $page_order \
                $name \
                $revision_id \
                $publish_status]
        }
        set order_page [lsort -$dir -command learning_content::compare $page_list]
        set count 0
        foreach pages $order_page {
            set current_pos [lsearch -exact $pages $page_id]
            if {$current_pos >= 0} {
                incr count
                set next_list [lindex $order_page $count]
                break
            }
            incr count
        }

        if {[llength $next_list] > 0} {
            if {$action == 0} {
                set show 1
                switch $dir {
                    "decreasing" {
                        set img_name "order_up"
                    }
                    "increasing" {
                        set img_name "order_down"
                    }
                }
                set package_url [apm_package_url_from_id [ad_conn package_id]]
                set nexturl [export_vars \
                    -base ${package_url}content-admin/toggle-page-order \
                    {page_id
                    page_pos
                    page_name
                    content_id
                    status
                    dir
                    {action 1}
                    {show 0}}]
                set alt "[_ learning-content.page_${dir}]"
            } elseif {$action == 1} {
                set tmp_order [lindex $next_list 1]
                set tmp_item_id [lindex $next_list 0]
                set tmp_page_id [lindex $next_list 3]
                set tmp_status [lindex $next_list 4]
                db_dml update_page2 {*SQL*}
                ns_cache flush xotcl_object_cache ::$item_id
                ns_cache flush xotcl_object_cache ::$page_id
		content::item::set_live_revision -revision_id $page_id -publish_status $status
                db_dml update_page {*SQL*}
                ns_cache flush xotcl_object_cache ::$tmp_item_id
                ns_cache flush xotcl_object_cache ::$tmp_page_id
                content::item::set_live_revision -revision_id $tmp_page_id -publish_status $tmp_status
                ad_returnredirect "${wiki_url}\#cont1"
            }
        } else {
            set show 0
        }
        set content_template [parameter::get -package_id [ad_conn package_id] \
            -parameter "content_template" -default 0]
    }
} else {
    set show 0
}
