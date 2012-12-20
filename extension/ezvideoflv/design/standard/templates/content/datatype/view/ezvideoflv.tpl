{default $width=$attribute.content.width
	 $height=$attribute.content.height
	 $opt_string=''
	 $show_original=0 
	 $correct_size=0
}
{def
	$flv=concat( 'video/flv/', $attribute.contentobject_id,"/",$attribute.content.contentobject_attribute_id )
	$preview=concat( 'video/preview/', $attribute.contentobject_id,"/",$attribute.content.contentobject_attribute_id )
	$player=ezini( 'FLVPlayer', 'File', 'ezvideoflv.ini' )
	$options=ezini( 'FLVPlayer', 'Options', 'ezvideoflv.ini' )
}
{switch match=$size}
	{case match="half"}
		{def
		     $width=$width|div(2)|ceil
		     $height=$height|div(2)|ceil
		}
	{/case}
	{case match="double"}
		{def
		     $width=$width|mul(2)
		     $height=$height|mul(2)
		}
	{/case}
	{case match="frontpage"}
		{def
		     $width=160
		     $height=120
		}
	{/case}
	{case match="original"}
		{def
		     $width=384
		     $height=288
		}
	{/case}
{/switch}

{if $correct_size}
<!-- {$width}x{$height} -->
  {def $width=$width|sum(20)
       $height=$height|sum(20)
  }
{/if}

{if $attribute.has_content}
	{if $attribute.content.has_flv}
		{foreach $options as $key => $value}
			{set opt_string=concat($opt_string, '&amp;', $key, '=', $value)}
		{/foreach}
		<object type="application/x-shockwave-flash" data={$player|ezdesign()} width="{$width}" height="{$height}">
			<param name="movie" value={$player|ezdesign()} />
			<param name="allowFullScreen" value="true" />
			<param name="FlashVars" value="flv={$flv|ezurl('no')}&amp;startimage={$preview|ezroot('no')}{$opt_string}" />
		</object>
	{else}
	<p>{'FLV version not yet generated'|i18n( 'ezvideoflv/datatype' )}
	{/if}
	{if $show_original}<p><a href={concat("content/download/",$attribute.contentobject_id,"/",$attribute.content.contentobject_attribute_id,"/",$attribute.content.original_filename)|ezurl}>{'Download the original video file'|i18n( 'ezvideoflv/datatype' )}</a></p>{/if}
{else}
	<p>{'No file'|i18n( 'ezvideoflv/datatype' )}</p>
{/if}
{undef $width $height $flv $opt_string $options $player $preview $size $show_original}
