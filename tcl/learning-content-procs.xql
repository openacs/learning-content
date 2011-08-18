<?xml version="1.0"?>

<queryset>

    <fullquery name="learning_content::map_activity_objects.get_new_item_id">
        <querytext>
            select item_id
            from cr_items
            where name = :item_name
                and parent_id = :dst_folder_id
        </querytext>
    </fullquery>

    <fullquery name="learning_content::map_activity_objects.get_objects">
        <querytext>
            select name, item_id
            from cr_items
            where parent_id = :src_folder_id
        </querytext>
    </fullquery>

    <fullquery name="learning_content::copy_glossary_words_count.get_words_count">
        <querytext>
            select *
            from content_glossary_term_count
            where folder_id = :src_folder_id
        </querytext>
    </fullquery>

    <fullquery name="learning_content::copy_glossary_words_count.check_word">
        <querytext>
            select 1
            from content_glossary_term_count
            where term = :term
                and page = :page
                and folder_id = :dst_folder_id
        </querytext>
    </fullquery>

    <fullquery name="learning_content::copy_glossary_words_count.insert_word">
        <querytext>
            insert into
            content_glossary_term_count 
                (term, page, folder_id, times_used)
            values
                (:term, :page, :dst_folder_id, :times_used)
        </querytext>
    </fullquery>

    <fullquery name="learning_content::copy_glossary_words_count.update_word">
        <querytext>
            update content_glossary_term_count
            set times_used = :times_used
            where term = :term
                and page = :page
                and folder_id = :dst_folder_id
        </querytext>
    </fullquery>

    <fullquery name="learning_content::insert_items_into_category_by_name.get_item_id">
        <querytext>
            select object_id from acs_objects
            where title = :item_name
                and context_id = :folder_id
        </querytext>
    </fullquery>

    <fullquery name="learning_content::map_objects_to_categories.get_item_id_in_context">
        <querytext>
            select object_id from acs_objects 
            where title = :object_name
                and context_id = :folder_id
        </querytext>
    </fullquery>

    <fullquery name="learning_content::get_first_page.get_page_name">
        <querytext>
            select name
            from cr_items
            where item_id = :object_id
        </querytext>
    </fullquery>

    <fullquery name="learning_content::get_activity_id.activity_id">
        <querytext>
            select activity_id 
            from content_activities 
            where item_id = :item_id
        </querytext>
    </fullquery>

    <fullquery name="learning_content::activity_edit.update_activity">
        <querytext>
            update content_activities 
            set activity_id = :activity_id 
            where item_id = :item_id
        </querytext>
    </fullquery>

    <fullquery name="learning_content::activity_new.insert_activity">
        <querytext>
            insert into
            content_activities (item_id, activity_id)
            values (:item_id, :activity_id)
        </querytext>
    </fullquery>

    <fullquery name="learning_content::activity_exists_p.activity_exists">
        <querytext>
            select 1 
            from content_activities
            where item_id = :item_id
        </querytext>
    </fullquery>

    <fullquery name="learning_content::copy.get_src_package_id">
        <querytext>
            select object_id 
            from site_nodes 
            where parent_id = (
                    select node_id
                    from site_nodes
                    where object_id = (
                            select package_id
                            from dotlrn_communities
                            where community_id = :src_community_id ) )
            and name = 'learning-content'
        </querytext>
    </fullquery>

    <fullquery name="learning_content::copy.get_dst_package_id">
        <querytext>
            select object_id
            from site_nodes
            where parent_id = (
                    select node_id
                    from site_nodes
                    where object_id = (
                            select package_id
                            from dotlrn_communities
                            where community_id = :dst_community_id )
            )
            and name = 'learning-content'
        </querytext>
    </fullquery>

    <fullquery name="learning_content::get_categories.get_categories">
        <querytext>
                select c.category_id as category_id
                from categories c,
                    category_translations ct
                where parent_id is null
                    and tree_id = :tree_id
                    and c.category_id = ct.category_id
                    and ct.locale = :locale
                order by category_id
        </querytext>
    </fullquery>

    <fullquery name="learning_content::category::delete.order_categories_for_delete">
        <querytext>
            select category_id
            from categories
            where tree_id = :tree_id
                and category_id in ([join $category_ids ,])
            order by left_ind desc
        </querytext>
    </fullquery>

    <fullquery name="learning_content::category::category_childs.select_cat">
        <querytext>
            select count(ci.item_id)
            from category_object_map c, cr_items ci,
                cr_revisions r, xowiki_page p
            where c.object_id = ci.item_id
                and ci.parent_id = :wiki_folder_id
                and ci.content_type not in ('::xowiki::PageTemplate')
                and ci.name not in ('en:header_page','en:index','en:indexe')
                and r.revision_id = ci.live_revision
                and p.page_id = r.revision_id
                and c.category_id = :cat_id
            group by category_id
            order by category_id desc
        </querytext>
    </fullquery>

    <fullquery name="learning_content::category::up.select_content">
        <querytext>
            select ci.item_id,
                p.page_order,
                ci.name,
                ci.content_type,
                category_id,
                xpi.page_instance_id
            from category_object_map c,
                cr_items ci,
                xowiki_page p,
                xowiki_page_instance xpi
            where c.object_id = ci.item_id
                and ci.parent_id = :wiki_folder_id
                and ci.content_type not in ('::xowiki::PageTemplate')
                and p.page_id = xpi.page_instance_id
                and category_id = :cat_id
                and xpi.page_instance_id = ci.live_revision
            order by p.page_order
        </querytext>
    </fullquery>

    <fullquery name="learning_content::category::page_order.select_content">
        <querytext>
            select ci.item_id,
                    p.page_order,
                    ci.name,
                    ci.content_type,
                    category_id,
                    xpi.page_instance_id
            from category_object_map c,
                    cr_items ci,
                    xowiki_page p,
                    xowiki_page_instance xpi
            where c.object_id = ci.item_id
                and ci.parent_id = :wiki_folder_id
                and ci.content_type = '::xowiki::PageInstance'
                and p.page_id = xpi.page_instance_id
                and category_id in ([join $cat_id ","])
                and xpi.page_instance_id = ci.live_revision
            order by p.page_order
        </querytext>
    </fullquery>

    <fullquery name="learning_content::category::category_parent.select_parent">
        <querytext>
            select parent_id,
                category_id as category
            from categories 
            where category_id = :category_id
                and tree_id = :tree_id
        </querytext>
    </fullquery>

    <fullquery name="learning_content::category::get_ready_objects.get_ready_objects">
        <querytext>
            select com.object_id
            from category_object_map com $join_clause
            where com.category_id = :category_id $where_clause
        </querytext>
    </fullquery>

    <fullquery name="learning_content::category::get_all_objects.get_all_objects">
        <querytext>
            select com.object_id
            from category_object_map com $join_clause
            where com.category_id = :category_id $where_clause
        </querytext>
    </fullquery>

    <fullquery name="learning_content::create_page.page_index">
        <querytext>
            select count(p.page_id)
            from cr_items ci,
                xowiki_page p
            where ci.parent_id = :folder_id
                and ci.content_type = '::xowiki::PageInstance'
                and p.page_id = ci.live_revision
        </querytext>
    </fullquery>

    <fullquery name="learning_content::create_page.select_name">
        <querytext>
            select 1 from cr_items
            where name = :page_name
                and parent_id = :folder_id
        </querytext>
    </fullquery>

    <fullquery name="learning_content::category::get_under_categories.get_under_categories">
        <querytext>
            select category_id
            from categories
            where parent_id = :parent_id
                and category_id < :category_id
            order by category_id desc
        </querytext>
    </fullquery>

    <fullquery name="learning_content::category::get_over_categories.get_over_categories">
        <querytext>
            select category_id
            from categories
            where parent_id = :parent_id
                and category_id > :category_id
            order by category_id
        </querytext>
    </fullquery>

</queryset>
