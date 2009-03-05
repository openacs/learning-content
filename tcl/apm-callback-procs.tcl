ad_library {

    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date 2008-09-10
}

::xo::db::require package xowiki

namespace eval learning_content::apm {}

ad_proc -public learning_content::apm::package_mount {
    {-package_id:required}
    {-node_id:required}
} {
    Check if packages needed are mounted, if not mount them!
} {

    set package_parent_id [site_node::get_parent_id -node_id $node_id]
    set package_community_id [site_node::get_object_id \
        -node_id $package_parent_id]
    set community_id [dotlrn_community::get_community_id \
        -package_id $package_community_id]
    set community_url [dotlrn_community::get_community_url $community_id]
    #check if assessment is mounted, if not mount it
    if {$community_id > 0} {
        set activity "assessment"
        if {![site_node::exists_p -url "${community_url}${activity}" ]} {
            dotlrn_community::add_applet_to_community \
                $community_id dotlrn_assessment
        }
        #check if evaluation is mounted, if not mount it
        set activity "evaluation"
        if {![site_node::exists_p -url "${community_url}${activity}"]} {
            dotlrn_community::add_applet_to_community \
                $community_id dotlrn_evaluation
        }
    }

    learning_content::category::map_new_tree -object_id $package_id \
        -tree_name "\#learning-content.choose_location\#"

   ::xowiki::Package initialize -package_id $package_id

    set root_directory [get_server_root]
    set prototypes_path "$root_directory/packages/learning-content/www/prototypes/"
    foreach prototype_page [glob \
        $prototypes_path/*.page] {
        regexp {.*/(.*).page} $prototype_page match prototype_page_name

        if {($prototype_page_name eq "glossary-list" \
                || $prototype_page_name eq "header_page" \
                || $prototype_page_name eq "editor")} {
            if {$prototype_page_name eq "editor"} {
                set folder_id [content::folder::get_folder_from_package \
                    -package_id $package_id]
                set folder_object_id [content::item::get_id_by_name \
                    -name "::$folder_id"\
                    -parent_id $folder_id]
                set p [::xowiki::Package instantiate_page_from_id -item_id $folder_object_id]
                set editor_page [source "${prototypes_path}editor.page"]
                $p set text [$editor_page set text]
                $p save
            }
        } else {
            $package_id import_prototype_page $prototype_page_name
        }
    }
}
