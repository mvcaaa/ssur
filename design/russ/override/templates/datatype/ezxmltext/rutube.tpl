{* input size=[normal, small ] *}
{default size=normal}
{switch match=$size}
	{case match='small'}
		{def $size_width=180 $size_height=150}
	{/case} 

	{case}
		{def $size_width=360 $size_height=300}
	{/case} 
{/switch}


<OBJECT width="{$size_width}" height="{$size_height}">
	<PARAM name="movie" value="http://video.rutube.ru/{$content}" />
	<PARAM name="wmode" value="window" />
	<PARAM name="allowFullScreen" value="true"></PARAM>
	<EMBED src="http://video.rutube.ru/{$content}" type="application/x-shockwave-flash" wmode="window" width="{$size_width}" height="{$size_height}" allowFullScreen="true" />
</OBJECT>
