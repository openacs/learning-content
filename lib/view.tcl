set parameter [subst {
    {-m view}
    {-return_url "[ns_conn url]"}
    {-template_file "view-links"}
    {-folder_id 0}
}]

# TODO the following should be done more elegantly
set actual_query [expr {[info exists template_file] ? "template_file=$template_file" : " "}]

if {[info exists url]} {
    # new style, the url is sufficient
    ::xowiki::Package initialize -parameter $parameter -url $url -actual_query $actual_query 
} else {
    # old style, use item_id
    set page [::xowiki::Package instantiate_page_from_id \
		  -item_id $item_id -parameter $parameter]
    ::xo::cc export_vars
}

set html [::$package_id invoke -method $m]

