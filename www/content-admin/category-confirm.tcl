ad_page_contract {
    @author byron Haroldo Linares Roman (bhlr@byronLs-Computer.local)
    @creation-date 2007-09-13
} {
    tree_id:integer
    category_id:integer,notnull
    {locale ""}
    object_id:integer,optional
    return_url:optional
}

set user_id [ad_maybe_redirect_for_registration]
set body_msg "[_ learning-content.can_delete]"
set package_id [ad_conn package_id]
permission::require_permission -object_id $package_id -privilege admin

set tree_list [learning_content::category::get_tree_levels \
    -subtree_id $category_id $tree_id]
set tree_list [linsert $tree_list 0 $category_id]
foreach category $tree_list {
    set my_category_id [lindex $category 0]
    if {[db_string \
            dbqd.xowiki.www.admin.category-delete.check_mapped_objects {}] \
            eq 1} {
        set body_msg "[_ learning-content.mapped_objects]"
        ad_return_template
    }
}

