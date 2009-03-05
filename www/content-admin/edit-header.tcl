ad_page_contract {
    Edit the header for the course
    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date 2009-01-07
} {
    {return_url "./"}
}

set page_title [_ learning-content.edit_header]
set context [list $page_title]

set package_id [ad_conn package_id]
set folder_id [content::folder::get_folder_from_package \
		   -package_id $package_id]

set page_id [content::item::get_id_by_name \
		 -name "en:header_page" -parent_id $folder_id]
if {![empty_string_p $page_id]} {
    set page [xowiki::Package instantiate_page_from_id \
	          -item_id $page_id]
} else {
    ::xowiki::Package initialize -package_id $package_id
    set page [$package_id import_prototype_page "header_page"]
}
set header [lindex [$page set instance_attributes] 1]

ad_form -name header -export {page_id} \
  -form {
    {header:text(text)
	{label "[_ learning-content.header]"}
	{value $header}
    }
  } -on_submit {
      set page [xowiki::Package instantiate_page_from_id \
		    -item_id $page_id]
      set atts [list "titulo" $header]
      $page set instance_attributes $atts
      $page save
      ad_returnredirect $return_url
  }