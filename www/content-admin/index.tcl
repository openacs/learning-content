
ad_page_contract {
    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date 2008-03-01
} 

set page_title [_ learning-content.admin]
set context [list $page_title]
set package_id [ad_conn package_id]
permission::require_permission -object_id $package_id -privilege admin

set src_community_id [dotlrn_community::get_community_id]
set actual_package_id $package_id
set return_url [ad_conn url]
set show_header [parameter::get -package_id $package_id \
    -parameter show_header \
    -default -1]
set copy_msg [_ learning-content.view_content]
set error_msg [_ learning-content.copy_error_message]
set success_msg [_ learning-content.copy_success_message]
set content_url [apm_package_url_from_id $package_id]
set user_id [ad_conn user_id]
set copy_link [_ learning-content.copy]

set community_type_clause \
    "and dotlrn_communities_all.community_type in \
('dotlrn_club', 'dotlrn_pers_community')"
db_multirow communities get_communities { *SQL* } {}

set community_type_clause \
    "and dotlrn_communities_all.community_type not in \
('dotlrn_community', 'dotlrn_club', 'dotlrn_pers_community')"
db_multirow classes get_communities { *SQL* } {}
