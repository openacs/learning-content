ad_page_contract {
    @author byron Haroldo Linares Roman (bhlr@byronLs-Computer.local)
    @creation-date 2007-08-24
} {
    tree_id:integer
    name:notnull
    category_id:integer,optional
    return_url:optional
    {parent_id 0}
    {language "en_US"}
    {mode 1}
}

set user_id [ad_conn user_id]
set package_id [ad_conn package_id]
permission::require_permission -object_id $package_id -privilege admin

if { ![string equal [string trim [string tolower $name]] "glosario"] } {
    set new_cat "1"
    set description "User category for content package"
    if {$mode eq 1 && [exists_and_not_null category_id]} {
        ## edit mode####
        category::update -category_id $category_id \
            -locale $language \
            -name $name \
            -description $description
    } elseif {$mode eq 2} {
        if {[learning_content::category::valid_level_and_count -tree_id $tree_id \
                -category_id $parent_id]} {
            set new_cat [category::add -tree_id $tree_id \
                            -parent_id $parent_id \
                            -locale $language \
                            -name $name \
                            -description $description]
            set parent_cat [learning_content::category::category_parent \
                -category_id $new_cat -tree_id $tree_id]
        }
    } elseif {$mode eq 3} {
        set new_cat [learning_content::category::new_subtree -tree_id $tree_id]
        set parent_cat $new_cat
    }
    if {[exists_and_not_null return_url]} {
        if {[exists_and_not_null new_cat]} {
            set temp "$return_url&new_cat=$new_cat"
            append temp "ad_returnredirect &parent_cat=$parent_cat"
            ad_returnredirect $temp
        } else {
            ad_returnredirect $return_url
        }
    }
} else {
    set new_cat "0"
}
