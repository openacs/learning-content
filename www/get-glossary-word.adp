@content;noquote@
<if @rels_p@ eq 1>
    <ul class="glossary_options">
        <li>
            <a id="new_entry" style="cursor: pointer; @new_style@" onclick="select_new_word('@scolor@')">#learning-content.new_entry#</a>
        </li>
    </ul><hr />
    <if @related_words:rowcount@ gt 0>
        <b>#learning-content.similar_words#</b><ul class="glossary_options">
        <multiple name="related_words">
            <li>
                <a id="rel_@related_words.name@" style="cursor: pointer; @related_words.style@" onclick="select_word('@package_url@','@related_words.name@','@scolor@','@related_words.item_id@')">@related_words.name@</a>
            </li>
        </multiple>
        </ul><hr />
    </if>
    <if @other_words:rowcount@ gt 0>
        <b>#learning-content.other_words#</b>
        <ul class="glossary_options">
        <multiple name="other_words">
                <li><a id="rel_@other_words.name@" style="cursor: pointer;" onclick="select_word('@package_url@','@other_words.name@','@scolor@','@other_words.item_id@');">@other_words.name@</a></li>
        </multiple>
        </ul><hr />
    </if>
</if>
