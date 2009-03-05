<master>
  <property name="title">@page_title;noquote@</property>
  <property name="context">@context;noquote@</property>
<link media="all" type="text/css" href="/resources/learning-content/fix-xowiki-edit.css" rel="stylesheet"/>
<link media="all" type="text/css" href="/resources/learning-content/activities.css" rel="stylesheet"/>
<script src="/resources/learning-content/content-activities.js" type="text/javascript"></script>
<center>
    <table style="height: 30px; width: 50%; border-collapse: collapse; margin-top: 10px; min-width: 400px;">
        <tr>
            <td style="width: 28px; background: url(/resources/learning-content/images/sel_left2.gif)"></td>
            <td style="text-align: center; background-color: #F2F2F2;"><a href="@back_url;noquote@">1. #learning-content.choose_activity#</a></td>
            <td style="width: 28px; background: url(/resources/learning-content/images/sel_middle2.gif);"></td>
            <td style="text-align: center; background-color: #D8E0E6;"><b>2. #learning-content.choose_location#</b></td>
            <td style="width: 28px; background: url(/resources/learning-content/images/sel_right2.gif)"></td>
        </tr>
    </table>
<table style="width: 25%;">
    <tr>
        <th style="text-align: right; width: 50%;">#learning-content.activity_type#:</th>
        <th style="text-align: left; width: 50%;">@activity_type_name@</th>
    </tr>
    <tr>
        <td style="text-align: right; width: 50%;">#learning-content.Name#:</td>
        <td style="text-align: left; width: 50%;">
        <if @activity_name@ ne "">@activity_name@</if><else>#learning-content.New#</else></td>
    </tr>
</table>
<table style="margin-top: 10px;">
<tr>
    <td valign="top" id="ok_submit" style="">
        <formtemplate id="activities">
	</formtemplate>
    </td>
</tr>
</table>
</center>
<if @page_item_id@ eq 0>
    <script>
        var categories = document.getElementById('@cat_name@');
        for (i = 0 ; i < categories.options.length ; i++) {
           if( categories.options[i].value == '@activities_category@' ) {
                categories.selectedIndex = i;
                break;
            }
        }
        if (categories.selectedIndex == 0) {
            for (i = 0 ; i < categories.options.length ; i++) {
                if( categories.options[i].value == '@category_id@' ) {
                    categories.selectedIndex = i;
                    break;
                }
            }
        }
    </script>
</if>
<if @tree_id@ gt 0>
    <script>
    try {
     document.getElementById('__category__ad_form__category_'+@tree_id@).setAttribute('size',5);
    } catch (e){}
    </script>
</if>