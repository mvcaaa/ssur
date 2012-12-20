{* input size=[normal, small ] *}
{default size=normal}
{switch match=$size}
	{case match='small'}
		{def $size_width=180 $size_height=150}
	{/case} 

	{case match='front'}
		{def $size_width=290 $size_height=200}
	{/case} 

	{case}
		{def $size_width=360 $size_height=300}
	{/case} 
{/switch}
<object width="{$size_width}" height="{$size_height}">
    <param name="movie" value="http://www.youtube.com/v/{$content}"></param>
    <embed src="http://www.youtube.com/v/{$content}" type="application/x-shockwave-flash" width="{$size_width}" height="{$size_height}" ></embed>
</object>

