<master>
  <property name="title">@page_title;noquote@</property>
  <property name="context">@context;noquote@</property>
  <script type="text/javascript" src="/resources/ajaxhelper/prototype/prototype.js"></script>
  <script type="text/javascript" src="/resources/ajaxhelper/scriptaculous/scriptaculous.js"></script>
  <script src="/resources/learning-content/content-admin.js" type="text/javascript"></script>
<style>
    a {
        cursor: pointer; color: #235C96;
    }
    .content_admin {
        background-color:#F2F2F2;
        border:1px solid #CCCCCC;
        margin-bottom:10px;
        padding : 10px;
        width: 95%;
    }
</style>
<a class="ALTbutton" href="@content_url@">#learning-content.go_back#</a><br /><br />
<h2>#learning-content.content_admin#</h2>
<div class="content_admin">  
<ul>
    <li><p>#learning-content.go_to# <a href='@content_url@'>#learning-content.content#</a></p></li>
    <li><p><a href="@content_url@content-admin/category-view">#learning-content.edit_content_index# </a></p></li>
    <li><p>#learning-content.show_header# 
        <if @show_header@ eq 1 >
            #learning-content.yes# | <a href="@content_url@content-admin/header-toggle?package_id=@package_id@&value=0&return_url=@return_url;noquote@">#learning-content.no#</a>
        </if><else>
            <a href="@content_url@content-admin/header-toggle?package_id=@package_id@&value=1&return_url=@return_url;noquote@"> #learning-content.yes#</a> | #learning-content.no#
        </else>
    </p></li>
    <li><p><a href="@content_url@content-admin/edit-header">#learning-content.edit_title#</a></p></li>
    <li><p><a href='@content_url@content-admin/tracking'>#learning-content.user_views#</a></p></li>
</ul>
</div>

<div style="position:relative;">
<h2>#learning-content.copy_content_to#</h2>
<div id='div_@package_id@'></div>

<div id="copy_content" class="content_admin" >
    <ul>
        <li><p>#learning-content.my_communities# <small> (<a style="cursor: pointer;" onclick="Effect.BlindDown('communities');"> ++</a> | <a style="cursor: pointer;"  onclick="Effect.BlindUp('communities');">-- </a>)</small></p>
            <ul id="communities" style="display: none;">
                <if @communities:rowcount@ eq 0>#learning-content.no_communities#</if>
                <multiple name="communities">
	            <if @communities.dst_community_id@ ne @src_community_id@>
                        <li id="community_@communities.community_package_id@"> @communities.community_name@ <a onclick="if (confirm('#learning-content.copy_warning_message#')) { copy_request(@src_community_id@,@communities.dst_community_id@, '@communities.community_url@','community_@communities.community_package_id@', '@copy_msg@', '@error_msg@', '@success_msg@' ); }"> @copy_link;noquote@  </a></li>
		    </if><else>
   		        <if @communities:rowcount@ eq 1>#learning-content.no_communities#</if>
		    </else>
                </multiple>
            </ul>
        </li>
        <li><p>#learning-content.my_classes# <small> (<a style="cursor: pointer;" onclick="Effect.BlindDown('classes');"> ++</a> | <a style="cursor: pointer;"  onclick="Effect.BlindUp('classes');">-- </a>)</small></p>
            <ul id="classes" style="display: none;">
                <if @classes:rowcount@ eq 0>#learning-content.no_classes#</if>
                <multiple name="classes">
                        <li id="class_@classes.community_package_id@"> @classes.community_name@ <a onclick="if (confirm('#learning-content.copy_warning_message#')) { copy_request(@src_community_id@,@classes.dst_community_id@, '@classes.community_url@','class_@classes.community_package_id@', '@copy_msg@', '@error_msg@', '@success_msg@' ); }"> @copy_link;noquote@  </a></li>
                </multiple>
            </ul>
        </li>
    </ul>
</div>
</div>

<if @package_id@ eq "">
<small>No community specified</small>
</if>
