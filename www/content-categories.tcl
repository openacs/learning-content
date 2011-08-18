::xowiki::Page proc __render_html {
    -package_id
    {-tree_name ""}
    -tree_style
    -no_tree_name:boolean
    -count:boolean
    {-summary 0}
    {-open_page ""}
    {-category_ids ""}
    {-except_category_ids ""}
} {}

##### Generating YUI Dynamic Tree for index content #####
set glossary_id [ns_queryget category_id]
set cont 1
set package_id [$__including_page set package_id]
set package_url [$package_id package_url]
set tree_list  [category_tree::get_mapped_trees $package_id]
set tree_id    [lindex [lindex $tree_list 0] 0]
set tree_name    [lindex [lindex $tree_list 0] 1]
set folder_id [$package_id folder_id]
set categories [learning_content::get_categories -tree_id $tree_id]
set show_all_p f
set admin_p [::xo::cc permission \
		 -object_id $package_id -privilege admin \
		 -party_id [::xo::cc user_id]]
if {$admin_p} {
    # get production_mode parameter
    if {[parameter::get -package_id $package_id -parameter production_mode -default 0]} {
	set show_all_p t
    }
}

set page_id [string trimleft $__including_page "::"]

# Alvaro: url of the script that adds the content dynamically
# to the tree branches
set dynamic_tree_url "${package_url}dynamic-tree"

set open_category_id 0
set open_item_id [expr {$open_page ne "" ? [::xo::db::CrClass lookup -name $open_page \
    -parent_id $folder_id] : 0}]
set open_category_id [category::get_mapped_categories  -tree_id $tree_id \
    $open_item_id]
set open_unit_id1 0
set open_unit_id2 0
set open_unit_id3 0
db_0or1row get_unit_id1 {*SQL*}
db_0or1row get_unit_id2 {*SQL*}

template::multirow create category_tree category_id category_name parent_id is_open_p
template::multirow create glossary glossary_url glossary_parent_id selected_p

foreach category_id $categories {

    set total 0
    set category_name [learning_content::get_category_name -category_id $category_id ]
# Alvaro: for each branch we need to know if the open page is inside, so we 
#set it open if the page is inside or close otherwise
    if {$open_unit_id1 == $category_id || $open_unit_id2 == $category_id \
    || $open_category_id == $category_id || $glossary_id == $category_id} {
        set is_open_unit true
    } else {
        set is_open_unit false
    }

    set total [expr $total + [llength [learning_content::category::get_all_objects \
        -category_id $category_id -content_type "::xowiki::PageInstance" -show_all_p $show_all_p] ]]
    set subcategories [db_list get_childrens {*SQL*}]
    foreach subcategory_id $subcategories {
        set total [expr $total + [llength [learning_content::category::get_all_objects \
            -category_id $subcategory_id -content_type "::xowiki::PageInstance" -show_all_p $show_all_p] ]]
        set in_subcategories [category::get_children \
            -category_id $subcategory_id]
        foreach in_subcategory_id $in_subcategories {
            set total [expr $total + [llength [learning_content::category::get_all_objects \
                -category_id $in_subcategory_id -content_type "::xowiki::PageInstance" -show_all_p $show_all_p] ]]
        }
    }

    if { $total > 0 } {
    # Alvaro: adding a category node to the tree root :Content    
        template::multirow append category_tree $category_id $category_name $package_id $is_open_unit

        if {![exists_and_not_null open_page] } {
            set open_page ""
        }

        set is_open false

        foreach subcategory_id $subcategories {
            set subcategory_name [learning_content::get_category_name \
                -category_id $subcategory_id ]
            set child_list \
                [expr [category::count_children \
                        -category_id $subcategory_id] \
                    +  [llength [learning_content::category::get_all_objects \
                        -category_id $subcategory_id -content_type "::xowiki::PageInstance" -show_all_p $show_all_p]]]
            if { $child_list } {

                if {$open_category_id == $subcategory_id || \
                    $open_unit_id1 == $subcategory_id } {
                    set is_open true
                } else {
                    set is_open false
                }

                set in_subcategories [category::get_children \
                    -category_id $subcategory_id]
                set subtotal 0
                set subtotal [expr $subtotal \
                    + [llength [learning_content::category::get_all_objects \
                        -category_id $subcategory_id -content_type "::xowiki::PageInstance" -show_all_p $show_all_p]]]
                foreach in_subcategory_id $in_subcategories {
                    set subtotal [expr $subtotal \
                        + [llength [learning_content::category::get_all_objects \
                            -category_id $in_subcategory_id -content_type "::xowiki::PageInstance" -show_all_p $show_all_p]]]
                }

                if { $subtotal > 0 } {
        # Alvaro: adding a subcategory node to the category parent node
                    template::multirow append category_tree $subcategory_id $subcategory_name $category_id $is_open

                    foreach in_subcategory_id $in_subcategories {

                        set in_subcategory_name [learning_content::get_category_name \
                            -category_id $in_subcategory_id]
                        set in_child_list [expr \
                            [category::count_children \
                                -category_id $in_subcategory_id] \
                            + [llength [learning_content::category::get_all_objects \
                                -category_id $in_subcategory_id -content_type "::xowiki::PageInstance" -show_all_p $show_all_p]]]
                        if { $in_child_list } {
                            if {$open_category_id == $in_subcategory_id } {
                                set is_sub_open true
                            } else {
                                set is_sub_open false
                            }
        # Alvaro: adding a in_subcategory node to the category parent node
                            template::multirow append category_tree $in_subcategory_id $in_subcategory_name $subcategory_id $is_sub_open
                        }
                    }
                }
            }
        }
    # Alvaro: this is how we tell the tree which page is open
    }
    # Alvaro: this will add the Glosario as a category to the tree.
    if { $glossary_id == $category_id } {
        template::multirow append category_tree $cont [_ learning-content.glossary] $category_id true
	template::multirow append glossary "${package_url}glossary-list?category_id=$category_id" $cont 1
    } else {
        template::multirow append category_tree $cont [_ learning-content.glossary] $category_id false
	template::multirow append glossary "${package_url}glossary-list?category_id=$category_id" $cont 0
    }
    set cont [expr $cont + 1]
}

if {![info exists skin]} {set skin portlet-skin}
if {![string match /* $skin]} {set skin [file dir $__adp_stub]/$skin}
template::set_file $skin

