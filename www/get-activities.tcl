ad_page_contract {
    Get the existing applications for content activities
    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date 2008-04-12
 } {
    {activity ""}
    {parent_id 0}
}

set result ""
set prev_forum_id 0
set prev_grade_item_id 0
set cont 0
set community_id [dotlrn_community::get_community_id]
set community_url [dotlrn_community::get_community_url $community_id]

switch $activity {
    "forums_message" {
        set activity_type "forums"
        set package_id [dotlrn_community::get_package_id_from_package_key \
            -package_key $activity_type -community_id $community_id]
	set package_url [apm_package_url_from_id $package_id]
	set forums_url "${package_url}admin"
        db_multirow -extend { changed_p count } \
            forums get_forums_and_messages { *SQL* } {
            if { $prev_forum_id == 0 } {
                set changed_p 1
            } elseif { $prev_forum_id != $forum_id } {
                set changed_p 1
            } else {
                set changed_p 0
            }
            set prev_forum_id $forum_id
            set count $cont
            incr cont
        }
        db_multirow empty_forums get_forums_with_no_messages { *SQL } {}
    }
    "as_assessments" {
        set activity_type "assessment"
        set package_id [dotlrn_community::get_package_id_from_package_key \
            -package_key $activity_type -community_id $community_id]
        set folder_id [as::assessment::folder_id -package_id $package_id]
        db_multirow -extend { as_title } assessments get_as_item { *SQL* } {
            set as_title [db_string get_as_title {} -default ""]
        }
    }
    "evaluation_tasks" {
        set activity_type "evaluation"
        set package_id [dotlrn_community::get_package_id_from_package_key \
            -package_key $activity_type -community_id $community_id]
        db_multirow -extend { changed_p count } evaluations \
            get_grades_with_info { *SQL* } {

            if { $prev_grade_item_id == 0 } {
                set changed_p 1
            } elseif { $prev_grade_item_id != $grade_item_id } { 
                set changed_p 1
            } else {
                set changed_p 0
            }
            set prev_grade_item_id $grade_item_id
            set count $cont
            incr cont
        }
        db_multirow empty_evaluations get_grades_without_info { *SQL* } {}
    }
    "chat_room" {
        set activity_type "chat"
        set package_id [dotlrn_community::get_package_id_from_package_key \
            -package_key $activity_type -community_id $community_id]
        db_multirow chat_room get_chat_rooms { *SQL* } {}
    }
}

