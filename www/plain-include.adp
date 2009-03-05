<script type="text/javascript" src="/resources/learning-content/dynamic-tree.js"></script>
<div id="dynamic_tree_div"></div>

<script> var folder_id = @folder_id@; </script>
<script> 
dynamic_tree_url = '@dynamic_tree_url;noquote@';
treeInit('#learning-content.content#', @package_id@ );
</script>
<script>
<multiple name="category_tree">
    var tmpNode = new YAHOO.widget.TextNode({
        label: "@category_tree.category_name@", id:@category_tree.category_id@ }, tree.getNodeByProperty('id', @category_tree.parent_id@), @category_tree.is_open_p@);
</multiple>
<multiple name="glossary">
<if @glossary.selected_p@ eq 1>
    var tmpNode = new YAHOO.widget.HTMLNode('<strong><a href="@glossary.glossary_url;noquote@">#learning-content.glossary#</a></strong>',tree.getNodeByProperty('id',@glossary.glossary_parent_id@), false, false);
</if><else>
    var tmpNode = new YAHOO.widget.HTMLNode('<a href="@glossary.glossary_url;noquote@">#learning-content.glossary#</a>',tree.getNodeByProperty('id',@glossary.glossary_parent_id@), false, false);
</else>
</multiple>
current_object_id =  @page_id;noquote@;
</script>