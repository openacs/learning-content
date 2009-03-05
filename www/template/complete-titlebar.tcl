ad_page_contract {
    @author byron Haroldo Linares Roman (bhlr@byronLs-Computer.local)
            Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date 2007-07-18
} {
    page_pos:optional
    page_id:optional
    content_id:optional
    my_title:optional
    type:optional
    category_id:optional
}

if {![string match $page_pos "@page_order@"]} {
    set show 1
} else {
    set show 0
}
