ad_page_contract {
    @author byron Haroldo Linares Roman (bhlr@byronLs-Computer.local)
    @creation-date 2007-08-27
} {
    tree_id:integer
    category_id:integer,notnull
    {locale ""}
    object_id:integer,optional
    return_url:optional
}

set user_id [ad_conn user_id]
set package_id [ad_conn package_id]
permission::require_permission -object_id $package_id -privilege admin

set tree_list [learning_content::category::get_tree_levels -subtree_id $category_id \
    -tree_id $tree_id]
set tree_list [linsert $tree_list 0 $category_id]
foreach category $tree_list {
    set my_category_id [lindex $category 0]
    if {[db_string check_mapped_objects {*SQL*}] eq 1} {
        ad_return_complaint 1 "[_ learning-content.mapped_objects]"
        ad_script_abort
    }
    lappend category_ids $my_category_id
}

set result [learning_content::category::delete -tree_id $tree_id \
    -category_ids $category_ids]
if {$result eq 0} {
    ad_return_complaint 1 "[_ learning-content.still_contains_subcategories]"
}
