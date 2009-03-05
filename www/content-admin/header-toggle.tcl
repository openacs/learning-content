ad_page_contract {
} {
    {package_id}
    {return_url ""}
    {value:integer}
}

parameter::set_value -package_id $package_id -parameter show_header \
    -value $value
ad_returnredirect $return_url