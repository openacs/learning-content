<master>
  <property name="title">@title@</property>
  <property name="context">@context;noquote@</property>
    <style type="text/css" media="screen">
    .inplaceeditor-saving { background: url(/resources/ajaxhelper/yui-ext/resources/images/grid/wait.gif) bottom right no-repeat; }
    .editor_cancel {padding: 3px 5px; }
        a {
                cursor: pointer;
        }
    </style>

<a class="ALTbutton" href="./">#learning-content.go_back#</a><br><br>
<div id="indicator" style="display: none; top: -2000px; left: -2000px;"><img src="/resources/learning-content/indicator.gif" /></div>

<div style="width:100%; position:relative;">

<div id="dynamic_tree_div" style="float: left;"></div>
<style>a.button { font-size: 10px; }</style>
<script>
    var div_msg = 'msg_div2';
    var dynamic_tree_url ='@dynamic_tree_url;noquote@';

    treeInit("#learning-content.content# <a class=\"button\" onmouseover=\"Effect.Appear(div_msg);\" onmouseout=\"Effect.Fade(div_msg);\"  onclick=\"newUnit(@tree_id@);\"> #learning-content.new_unit#</a>", '@package_id@');
</script>
<script>
    var save_msg = '#learning-content.save#';
    var cancel_msg = '#learning-content.cancel#';
    var add_msg = '#learning-content.add_folder#';
    var delete_msg = '#learning-content.delete_folder#';
    var edit_msg = '#learning-content.edit#';

<multiple name="category_tree">
    var tmpNode = new YAHOO.widget.TextNode({
        label: "@category_tree.category_name@ <a class=\"button\" onclick=\"addEditor(@category_tree.category_id@, @tree_id@, @category_tree.category_id@)\">"+ edit_msg +"</a><if @category_tree.level@ ne 3> <a class=\"button\" onclick=\"addNode(@tree_id@,@category_tree.category_id@)\">"+ add_msg +"</a></if> <a class=\"button\" onclick=\"removeMyNode(@category_tree.category_id@, @tree_id@,@category_tree.category_id@,'@category_delete_alert_msg@')\">"+ delete_msg +"</a> <span id=\"form_@category_tree.category_id@\"></span>", id:@category_tree.category_id@ }, tree.getNodeByProperty('id', @category_tree.parent_id@), true);
</multiple>
</script>

<div id="msg_div2" style="float: left; display: none;">
#learning-content.unit_description#
</div>

<div style="clear: both;"></div>
</div>
