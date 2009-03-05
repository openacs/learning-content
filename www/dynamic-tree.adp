<if @total@ eq 0>no data</if>
<else>
	<multiple name="categories">@categories.category_id@,@categories.category_name@,@categories.is_category@,@categories.object_url@<if @categories.rownum@ ne @total@>;</if></multiple>
</else>