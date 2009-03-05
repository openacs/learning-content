<if @show@ true>
  <if @index@ ne 0>
    <if @nexturl@ ne 0>
      <li>
	<a href="@nexturl@" style="text-decoration:none;" @styleb;noquote@>
	    @cat_name@
	</a>
      </li>
    </if>
    <else>
      <li @styleb;noquote@>
	  @cat_name@
      </li>
    </else>
  </if>
</if>
<if @index@ eq 6>
    <li>
    <a href="glossary-list?category_id=@parent_id@" style="text-decoration:none;" @stylec;noquote@>
        #learning-content.glossary#
    </a>
    </li>
</if>