::xowiki::Package initialize -ad_doc {
    
    @author byron Haroldo Linares Roman (bhlr@byronLs-Computer-2.local)
    @creation-date 2008-02-08
    @arch-tag: 2DB9A129-4B88-4E91-8686-8D47FCA678AF
    @cvs-id $Id$
} -parameter {
    -folder_id
    -tree_id
    -category_id
    -state
}

learning_content::category::set_category_publish_state \
    -category_id $category_id \
    -tree_id $tree_id \
    -wiki_folder_id $folder_id \
    -state $state 

ad_returnredirect "set-category-publish-state?action=$state"