<if @show@ true>
 <div class="order-nav">
<include src="/packages/learning-content/www/content-admin/toggle-page-order" page_pos=@page_pos@ page_id=@page_id@ content_id=@content_id@ type=@type@ dir="decreasing" action=0 page_name=@page_name@ status=@status@>
<span class="order-text"> #learning-content.order# </span>
<include src="/packages/learning-content/www/content-admin/toggle-page-order" page_pos=@page_pos@ page_id=@page_id@ content_id=@content_id@ type=@type@ dir="increasing" action=0 page_name=@page_name@ status=@status@>
</div>
</if>