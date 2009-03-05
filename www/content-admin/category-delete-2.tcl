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

db_transaction {
    category::delete $category_id
    category_tree::flush_cache $tree_id
} on_error {
    ad_return_complaint 1 "[_ learning-content.still_contains_subcategories]"
    ad_script_abort
}

ad_returnredirect $return_url

