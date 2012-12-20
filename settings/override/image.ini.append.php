<?php /* #?ini charset="utf-8"?

[ImageMagick]
IsEnabled=true
ExecutablePath=/usr/bin
Executable=convert
Filters[]=thumbnail=-thumbnail %1x%2^ -unsharp 0x.5 -gravity center -extent %1x%2

*/ ?>
