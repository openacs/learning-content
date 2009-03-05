ad_page_contract {
    Copy Content Information
} {
    {src_community_id}
    {dst_community_id}
}

set package_id [ad_conn package_id]
permission::require_permission -object_id $package_id -privilege admin

set result [learning_content::copy \
                -src_community_id $src_community_id \
                -dst_community_id $dst_community_id]