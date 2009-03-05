ad_page_contract {
    gets all the objects from a category_id and adds the content
    to the dynamic YUI tree
    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date 2008-01-06
}  {
    {category_id  ""}
    {folder_id 0}
}

set user_id [ad_conn user_id]
set package_id [ad_conn package_id]

# Alvaro: query to find all the objects inside a category
set category_objects [db_list get_items_id {*SQL*} ]
set total [llength $category_objects]
template::multirow create categories \
    category_name category_id is_category object_url

# Alvaro: adding each object to the parent category node 
foreach object $category_objects {
    set package_url [apm_package_url_from_id $package_id]
    set page [::xowiki::Package instantiate_page_from_id -item_id $object]
    set page_name [$page set name]
    $page volatile
    set object_url "${package_url}${page_name}"
    regsub -all { } $object_url "%20" object_url
    if { $object != 0} {
        set object_title [db_string get_name {*SQL*} -default ""]
        template::multirow append categories $object "$object_title" \
            false $object_url
    }
}

