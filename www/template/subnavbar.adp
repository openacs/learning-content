  <if @show@ true>
    <if @nexturl@ ne 0>
      <li ><a @styles;noquote@ href="@nexturl@"><img src="/resources/learning-content/images/@img_name@" /> @cat_name@</a></li>
    </if>
    <else>
      <li>@cat_name@</li>
    </else>
  </if>