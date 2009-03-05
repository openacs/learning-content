ad_page_contract {
    Automatically create a page instance with a standard name
    and the default page template
    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date 2008-01-10
} {
    {activity_id 0}
    {activity_name ""}
    {redirect_url ""}
    {optional_text ""}
    {category_id 0}
    {page_item_id 0}
}

set package_id [ad_conn package_id]
set package_url [apm_package_url_from_id $package_id]
permission::require_permission -object_id $package_id -privilege admin

set data [learning_content::create_page]
set item_id [lindex $data 0]
set page_name [lindex $data 1]
set link "${package_url}$page_name"

ad_returnredirect  [export_vars -base $link {{m edit}}]
