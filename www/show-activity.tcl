ad_page_contract {
    Show activity link based on the object_id
    @author Alvaro Rodriguez (alvaro@viaro.net)
    @creation-date 2008-04-24
 } {
    {-object_id 0}
}

if { $object_id > 0 } { 
    set activity_id [db_string get_object_id {} -default -1]
    set object_id $activity_id
}

set exists_p 1
if {![db_0or1row object_data { *SQL* }]} {
   set exists_p 0
}

if { $exists_p } {
    if {[string eq $object_type content_item]} {
        db_0or1row item_data { *SQL* }
	set object_id $item_id
    }
    set activity_p 1
    switch $object_type {
        as_assessments {
            set activity_p [db_string get_assessment_status {} -default 0]
            set msg [_ learning-content.assessment_not_available_yet]
        }
        forums_message {
            set forum_id [db_string get_forum_id {} \
                -default 0]
            if { [string eq [db_string get_forum_status {} -default "t"] "f"] } {
                set activity_p 0
                set msg [_ learning-content.forum_not_available]
            }
        }
        evaluation_tasks {
        }
    }
} else {
    set activity_p 0
    set msg [_ learning-content.no_activity]
}
