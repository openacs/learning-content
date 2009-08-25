ad_library {
    Content package procs

    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date 2008-09-17
}

namespace eval ::learning_content {

    ::xo::PackageMgr create ::learning_content::Package \
      -package_key "learning-content" -pretty_name "Learn Content" \
      -superclass ::xowiki::Package

    Package instproc initialize {} {
        ::xowiki::WikiForm instmixin add ::learning_content::ContentForm
        ::xowiki::PageInstanceEditForm instmixin add ::learning_content::ContentWikiForm
	::xowiki::PageTemplateForm instmixin add ::learning_content::ContentTemplateForm
        ::xowiki::FormPage instmixin add ::learning_content::ContentFormPage
        ::xowiki::Page instmixin add ::learning_content::ContentPage
        next
    }

    Package instproc destroy {} {
        ::xowiki::WikiForm instmixin delete ::learning_content::ContentForm
        ::xowiki::PageInstanceEditForm instmixin delete \
            ::learning_content::ContentWikiForm
        ::xowiki::PageTemplateForm instmixin delete \
	    ::learning_content::ContentTemplateForm
        ::xowiki::FormPage instmixin delete ::learning_content::ContentFormPage
        ::xowiki::Page instmixin delete ::learning_content::ContentPage
        next
    }

    Package instproc return_page {
        {-adp:required}
        {-variables:required}
        {-form}
    } {
        foreach _var $variables {
            if {[llength $_var] == 2} {
                upvar [lindex $_var 0] [lindex $_var 0]
                upvar [string trim [lindex $_var 1] $] \
                        [string trim [lindex $_var 1] $]
            } else {
                upvar $_var [set _var]
            }
        }
        if {[string eq $adp "/packages/xowiki/www/edit"]} {
            set adp "/packages/learning-content/www/edit"
        }
        if {[exists_and_not_null item_id]} {
            set category_id [category::get_mapped_categories $item_id]
            set tree_id [category::get_tree $category_id]
            set category_id [learning_content::get_unit_id -category_id $category_id]
            set activity_id [learning_content::activity_exists_p -item_id $item_id]
            if { !$activity_id } {
        # AR: catch the case when a page has been deleted and will be imported
                if {[catch { set page_name [$item_id name] } error]} {
                    set page_name "index"
		    set no_links_p 1
                } else {
		    set no_links_p 0
		}
                if {([string first "glossary-list" $page_name] == -1 && \
                        [string first "index" $page_name] == -1) || \
                        [acs_user::site_wide_admin_p]} {
		    if { !$no_links_p } {
			set edit_link [my make_link -privilege admin $item_id edit]
		    }
                }

		if { $no_links_p } {
                    set edit_link ""
                    set rev_link ""
                }
            } else {
                set edit_link [my make_link -privilege admin \
                                -link "activity-new" [my id] edit item_id \
                                    {return_url "[ad_return_url]"}]
            }
            set new_link2 [my make_link -privilege admin \
                                -link "page-instance-new" [my id] \
                                edit-new object_type]

            set new_link3 [my make_link -privilege admin \
                                -link "activity-new" [my id] edit-new \
                                category_id {return_url "[ad_return_url]"}]

            lappend variables new_link2 new_link3 category_id
        }
        if {[exists_and_not_null form]} {
            upvar form [set form]
        } else {
            set form ""
        }
        return [next -adp $adp -variables $variables -form $form]
    }

    Class create ContentPage -superclass ::xowiki::Page

    ContentPage instproc edit {} {
        my instvar package_id item_id revision_id
        set page_name [$item_id name]
        if {([string first "glossary-list" $page_name] == -1 && \
                [string first "index" $page_name] == -1) || \
                [acs_user::site_wide_admin_p]} {
            next
        } else {
            set content [_ learning-content.you_dont_have_perm]
            set html [$package_id return_page \
                        -adp /packages/learning-content/www/view-plain \
                        -variables {content}]
            return $html
        }
    }

    ContentPage instproc delete {} {
        my instvar package_id item_id name parent_id
        catch {
            db_dml [my qn delete_term_count] {
                delete from content_glossary_term_count
                where folder_id = :parent_id
                    and page = :name}
        } error
        next
    }

    Class create ContentFormPage -superclass ::xowiki::FormPage

    ContentFormPage instproc footer {} {
        if {![my exists __no_form_page_footer]} {
        return ""
        }
        next
    }

    Class create ContentForm -superclass ::xowiki::WikiForm \
        -parameter {
          {field_list 
            {item_id name page_order title creator text description nls_language}}
          {f.page_order
              {page_order:text(hidden),optional}
          }
          {f.description
	      {description:text(hidden),optional}
	  }
          {with_categories false}
          {validate {
               {name {\[::xowiki::validate_name\]} {Another item with this name exists \
                                                             already in this folder}}}
          }
        }

    Class create ContentTemplateForm -superclass ::xowiki::PageTemplateForm \
        -parameter {
          {field_list {item_id name text}}
          {f.name
              {name:text(hidden),optional}
          }
        }

    Class create ContentWikiForm -superclass ::xowiki::PageInstanceEditForm \
      -parameter {
          {field_list {item_id name title page_order text creator description}}
          {f.name
              {name:text(hidden),optional}
          }
          {f.page_order
              {page_order:text(hidden),optional}
          }
          {f.title
              {title:text(text)
              {label #learning-content.Name#}}
          }
	  {f.description
	      {description:text(hidden),optional}
	  }
          {with_categories true}
      }

    ContentWikiForm instproc after_submit {item_id} {
        #AR: overwrite the after submit_link 
        #to avoid redirecting to a language specific url
        my instvar data
        my submit_link "[[$data package_id] package_url][$data name]"
        next
    }

    ContentWikiForm instproc edit_data {} {
        my instvar page_instance_form_atts data
        foreach var $page_instance_form_atts {
            if {[string equal $var "contenido"]} {
                set contenido [my var $var]
                set page_name "[$data set name]"
                set folder_id [$data set parent_id]
                # Delete old glossary entries for the page
                db_dml [my qn remove_old_messages] {
                    delete from content_glossary_term_count
                    where folder_id = :folder_id
                        and page = :page_name}
                # Find all glossary words 
                while { [regexp -nocase "<a.*(id=\"(.+)__\[0-9\]+__\")\[^>\]*>" \
                        $contenido match value1 value2 value3] } {

                    regexp -nocase ".* id=\"(.+)__\[0-9\]+__\" .*" $match \
                        match term
                    set cont [regsub -all -nocase \
                        "<a\[^>\]*id=\"${term}__\[0-9\]+__\"\[^>\]*>" \
                        $contenido "" result]
                    set contenido $result
                    if {[db_string [my qn check_if_exists] "
                            select 1
                            from content_glossary_term_count
                            where folder_id = $folder_id
                                and page = '$page_name'
                                and term = '$term'" -default 0]} {
                        db_dml [my qn update_word_times] {
                            update content_glossary_term_count
                            set times_used = :cont
                            where folder_id = :folder_id
                                and page = :page_name
                                and term = :term}
                    } else {
                        db_dml [my qn insert_word_times] {
                            insert into content_glossary_term_count
                                ( term, page, folder_id, times_used )
                            values
                                ( :term, :page_name, :folder_id, :cont )}
                    }
                    # If fails to replace the words,
                    # continue with the next one to avoid loops
                    if { $cont == 0 } break
                }
            }
        }
        set item_id [next]
        return $item_id
    }

    Class create Policy -superclass ::xo::Policy

    Policy policyb -contains {
        Class Package -array set require_permission {
        admin               swa
        reindex             swa
        rss                 swa
        google-sitemap      none
        google-sitemapindex none
        delete              {{{has_class ::xowiki::PageTemplate} id swa}
                                {{has_class ::xowiki::Object} id swa}
                                {id admin}}

        edit-new            {{{has_class ::xowiki::Object} id swa}
                                {{has_class ::xowiki::Page} id swa}
                                {{has_class ::xowiki::PageTemplate} id swa}
                                {id create}}
        }

        Class Page -array set require_permission {
        view               none
        revisions          {{package_id admin}}
        diff               swa
        edit               swa
        make-live-revision {{package_id admin}}
        delete-revision    swa
        delete             swa
        save-tags          login
        popular-tags       login
        }

        Class PageInstance -array set require_permission {
        view               none
        revisions          {{package_id admin}}
        diff               {{package_id admin}}
        edit               {{package_id admin}}
        make-live-revision {{package_id admin}}
        delete-revision    {{package_id admin}}
        delete             {{item_id admin}}
        save-tags          login
        popular-tags       login
        }

        Class Form -array set require_permission {
        view               none
            revisions          {{package_id admin}}
            edit               {{package_id admin}}
            make-live-revision {{package_id admin}}
            delete-revision    {{package_id admin}}
            delete             {{item_id admin}}
            create-new       {{package_id admin}}
        }

        Class PageTemplate -array set require_permission {
            edit               swa
            edit-new           swa
            revisions          swa
            diff               swa
            make-live-revision swa
            delete-revision    swa
            delete             swa
        }

        Class Object -array set require_permission {
            edit               swa
            revisions          swa
            make-live-revision swa
            delete-revision    swa
            delete             swa
            save-tags          swa
            popular-tags       swa
        }

        Class File -array set require_permission {
            download           none
        }
    }
}