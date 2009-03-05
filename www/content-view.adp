<master>
  <property name="title">@title;noquote@</property>
  <property name="context">@context;noquote@</property>
  <property name="header_stuff">@header_stuff;noquote@
  </property>
   <link rel='stylesheet' href='/resources/xowiki/cattree.css' media='all' />

   <script type="text/javascript" src="/resources/learning-content/dynamic-tree.js"></script> 
   <!-- Required CSS -->
   <link type="text/css" rel="stylesheet" href="/resources/ajaxhelper/yui/treeview/assets/folders/tree.css"> 
   <!-- Dependency source files --> 
   <script src = "/resources/ajaxhelper/yui/yahoo/yahoo-min.js" ></script>
   <script src = "/resources/ajaxhelper/yui/event/event-min.js" ></script>
   <script src = "/resources/ajaxhelper/yui/connection/connection-min.js" ></script>

    <!-- Tooltip source files -->
    <script src = "/resources/ajaxhelper/yui/animation/animation-min.js" ></script>
    <script src = "/resources/ajaxhelper/yui/yahoo-dom-event/yahoo-dom-event.js" ></script>
    <link type="text/css" rel="stylesheet" href="/resources/ajaxhelper/yui/container/assets/container.css">
    <script src = "/resources/ajaxhelper/yui/container/container-min.js" ></script>
    <link type="text/css" rel="stylesheet" href="/resources/learning-content/tooltip.css">

    <!-- TreeView source file --> 
    <script src = "/resources/ajaxhelper/yui/treeview/treeview-min.js" ></script>

    <link type="text/css" rel="stylesheet" href="/resources/learning-content/style-blue.css">

<!--[if IE 6]>
<link type="text/css" rel="stylesheet" href="/resources/learning-content/style-blue-ie6.css">
<script type="text/javascript" src="/resources/learning-content/fix-png-ie6.js"></script>
<![endif]-->
<!--[if IE 7]>
<link type="text/css" rel="stylesheet" href="/resources/learning-content/style-blue-ie.css">
<![endif]-->

   <script type="text/javascript" src="/resources/ajaxhelper/prototype/prototype.js"></script> 
   <script type="text/javascript" src="/resources/ajaxhelper/scriptaculous/scriptaculous.js"></script> 
   <script language='javascript' src='/resources/acs-templating/mktree.js' type='text/javascript'></script>

  <!-- The following DIV is needed for overlib to function! -->
  <div id="overDiv" style="position:absolute; visibility:hidden; z-index:1000;"></div>	

	<h2 id="cont1"></h2>
  <div class='xowiki-content'>
    <div id='wikicmds'>
      <if @edit_link@ not nil and @edit_link@ ne ""><a href="@edit_link@" accesskey='e' title='Edit'>#learning-content.edit#</a> &middot;</if>
      <if @rev_link@ not nil and @edit_link@ ne ""><a href="@rev_link@" accesskey='r' >#xowiki.revisions#</a> &middot;</if>
      <if @object_type@ not nil and @object_type@ ne "::xowiki::Page">
	<if @object_type@ eq "::xowiki::PageInstance">
	  <if @new_link2@ not nil and @new_link2@ ne ""><a href="@new_link2@">#learning-content.new_page#</a> &middot;</if>
	  <if @new_link3@ not nil and @new_link3@ ne ""><a href="@new_link3@">#learning-content.new_activity#</a> &middot;</if>
	</if>
	<else>
	  <if @new_link@ not nil><a href="@new_link@" accesskey='n'>#xowiki.new#</a> &middot;</if>
	</else>
      </if>
      <else>
	  <if @new_link2@ not nil and @new_link2@ ne ""><a href="@new_link2@">#learning-content.new_page#</a> &middot;</if></else>
	  <if @new_link3@ not nil and @new_link3@ ne ""><a href="@new_link3@">#learning-content.new_activity#</a> &middot;</if>
      <if @delete_link@ not nil><a href="@delete_link@" accesskey='d'>#xowiki.delete#</a> &middot;</if>
	<if @admin_link@ not nil><a href="content-admin/">#learning-content.content_admin#</a></if>
    </div>
  <!-- </div> -->
<!-- </body> -->

  <div id="categories_cont" style="width:15%; float: left;">
    <div style="float:left; font-size: 85%;
      background: url(/resources/xowiki/bw-shadow.png) no-repeat bottom right;
      margin-left: 2px; margin-top: 2px; padding: 0px 6px 6px 0px; width: 95%;">
      
      <div style="border: 1px solid #a9a9a9; padding: 5px 5px; background: #f8f8f8">
	<div id="categories">
	    <include src="/packages/learning-content/www/content-categories" open_page=@name@ skin=plain-include &__including_page=page>
	</div>
      </div>
    </div>
  </div>

  <div id="cont1" style="float:right; width: 84%;">
    @content;noquote@</div>

  </div> <!-- class='xowiki-content' -->
<div id="myTooltip" style="width: 200px;">
    <div class="hd">
        <div class="tl"></div>
        <center><b id="tooltip_title"></b></center>
        <div class="tr"></div>
    </div>
    <div class="bd"></div>
    <div class="ft">
        <div class="bl"></div>
        <div class="br"></div>
    </div>
</div>

   <script type="text/javascript" src="/resources/learning-content/content-view.js"></script> 
 <script>

    var browser = navigator.appName;
    var att = "class";
    var glossary = document.getElementsByTagName('a');
    var myarray = new Array();
    var re = new RegExp('__[0-9]+__');
    for (var i=0; i<glossary.length; i++){
        var anchor = glossary[i];
        if (browser == "Microsoft Internet Explorer") var att = "className";
        if (anchor.getAttribute("href") && ((anchor.getAttribute("rel") == "glossary") || anchor.getAttribute(att) == "glossary__content__")){
            myarray.push(anchor);
            anchor.onmouseover = function () { showTooltip(this); return false; }
            anchor.onmouseout = function () { hideTooltip(this); return false; }
            anchor.style.color = '#7BB0BF';
            var new_word = anchor.id.replace(re,'');
            new_word = new_word.replace(/ +/g,'_');

            anchor.href = 'glossary-list?category_id=@category_id@#glossary_'+encodeURI(new_word)
            document.write('<a style="display: none;" id="word_'+anchor.id+'" value=""></a>');
        }
    }
    setTimeout("",500);
    for(var i=0; i<myarray.length; i++){
        var new_word = myarray[i].id.replace(re,'');
        new Ajax.Updater('word_'+myarray[i].id,'get-tooltip?word='+encodeURI(new_word), {method: 'get'});
    }
    var myTooltip = new YAHOO.widget.Tooltip("myTooltip", {context: myarray, autodismissdelay: 20000} );

</script>