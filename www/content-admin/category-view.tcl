ad_page_contract {

    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date 2008-08-24

}

set package_id [ad_conn package_id]
permission::require_permission -object_id $package_id -privilege admin

set ah_sources [ah::requires -sources "scriptaculous"]
set msg2_fade [ah::effects -element "msg_div2" \
                -effect "Fade" \
                -options "duration: 1.5"]

set msg2_appear [ah::effects -element "msg_div2" \
                    -effect "Appear" \
                    -options "duration: 0.5"]

##### Alvaro: Generating dynamic YUI tree for content index editor #####

set tree_list  [category_tree::get_mapped_trees $package_id]
set tree_id    [lindex [lindex $tree_list 0] 0]
set tree_name    [lindex [lindex $tree_list 0] 1]
set categories [learning_content::get_categories  -tree_id $tree_id]
set dynamic_tree_url "[ad_conn package_url]/dynamic-tree"

template::multirow create category_tree category_id category_name parent_id level

set title [_ learning-content.edit_content_index]
set context [list [list ./ [_ learning-content.admin]] $title]

# Alvaro: Adding 1st level categories
foreach category_id $categories {

    set category_name [learning_content::get_category_name -category_id $category_id ]
    template::multirow append category_tree $category_id $category_name $package_id 1
    set subcategories [db_list get_childrens {*SQL*}]

# Alvaro: Adding 2nd level subcategories
    foreach subcategory_id $subcategories {
        if {$subcategory_id != 0 } {
            set subcategory_name [learning_content::get_category_name \
                -category_id $subcategory_id ]
            template::multirow append category_tree $subcategory_id $subcategory_name $category_id 2
            set in_subcategories [db_list get_subchildrens {*SQL*}]
# Alvaro: Adding 3rd level subcategories
            foreach in_subcategory_id $in_subcategories {
                if { $in_subcategory_id != 0 } {
                set in_subcategory_name [learning_content::get_category_name \
                    -category_id $in_subcategory_id]
               template::multirow append category_tree $in_subcategory_id $in_subcategory_name $subcategory_id 3
                }
            }
        }
    }
}

template::head::add_javascript \
    -src "/resources/ajaxhelper/yui/yahoo/yahoo-min.js" \
    -order 1
template::head::add_javascript \
    -src "/resources/ajaxhelper/yui/event/event-min.js" \
    -order 2
template::head::add_javascript \
    -src "/resources/ajaxhelper/yui/connection/connection-min.js" \
    -order 3
template::head::add_javascript \
    -src "/resources/ajaxhelper/yui/treeview/treeview-min.js" \
    -order 4
template::head::add_javascript \
    -src "/resources/learning-content/dynamic-tree.js"
template::head::add_css \
    -href "/resources/ajaxhelper/yui/treeview/assets/folders/tree.css"
template::head::add_css \
    -href "/resources/learning-content/style-blue.css"