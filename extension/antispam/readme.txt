Antispam datatype for eZ publish 3.6+
*************************************

1. Introduction
---------------
It's possible to let anonymous people create objects or complete
forms in eZ publish. In both cases, the form is available for the
general public without the need to login. With the current state
of the internet in mind, it will be only a matter of time before
a spambot starts submitting the form.

That is where this datatype steps in. It generates the, by now,
familiar characters in an image that the user needs to retype to be
able to submit the form.


2. Features
-----------
The characters in the image will from now on be referred to as
'challenge'.

Here are the highlights of this datatype:

- Configurable challenge:
  > Custom length
  > Custom characters: lowercase, uppercase, numeric and user-
    defined characters
  > Possibility to ignore certain characters, e.g. similarly
    looking chars: i and l, ...

- Configurable image:
  > Easy configuration through INI file
  > Possibility to have several image formats
  > Configurable image dimensions
  > Configurable colors: background, border, text and line
  > Configurable minimum font size
  > Configurable angle to rotate the characters
  > Configurable font name
  > Configurable amount of noise lines

- Most configurable image parameters have extra randomness added:
  > Font size: minimum size + random size between 0 and 8
  > Angle: random value between minimum angle (ini value) and its
    absolute value. If you specify -20 in the ini file, the angle
    will be between -20 and 20.
  > Noise lines added to confuse image analyzers
  > Noise lines pick a random color from the line color setting
  > Text colors are picked randomly as well
  > The base height of the characters is a randomized value too

- Information collection support (with proper validation for
  is_required)

- Content class import & export support


3. Installation
---------------
Installation is very simple. Either get your copy of the datatype
from SVN or download it from eZ Contributions area.

- Put the antispam extension inside the extension folder.
- Open the admin interface and go to Setup -> Extensions.
- Tick the box in front of 'antispam'
- Click on 'Apply Changes'


4. Configuration
----------------

The following configuration scenario asumes that you have a content 
class "comment" available and want to add anti spam support to it.
The idea is that users can comment your content without the need to
login.

To provide this functionality, follow these steps:

1. Step: Add attribute

Add an attribute called "captch" with the datatype "Anti Spam" to
the "comment" content class. Some configuration options will be
displayed for the attribute.

The recommended configuration is:
Password length: 6
Uppercase (A-Z): Yes
Lowercase (a-z): No
Numeric (0-9):   Yes
Custom:          No

2. Step: Add template

Add the following template code to the edit view of your
"comment" content class:

<div class="attribute-captcha">
    <p>{'To prevent commentspamming, please enter the string you see in the image below in the input box beneath the image.'|i18n('design/standard/content/edit')}</p>
    <p><strong>{'Capital letters and numbers:'|i18n('design/standard/content/edit')}</strong></p
    {def $attribute=$object.data_map.captcha}
    <img src={antispam(challenge($attribute),$attribute.class_content.ini_block)|ezroot} alt="Antispam" />
    <br />
    <input type="text" name="ContentObjectAttribute_sckantispam_answer_{$attribute.id}" value="" />
    <input type="hidden" name="ContentObjectAttribute_id[]" value="{$attribute.id}" />
</div>

3. Step: Assign permissions

For anonymous user to be able to edit the comment class
without being logged in, you need to assign the right to
anonymous to create and edit objects of this class.

You do so by configuring the following permissions:

Module  | Function    | Limitation
--------------------------------------------------------------
content | edit        | Class( Comment ), Section( Standard )
--------------------------------------------------------------
content | create      | Class( Comment ), Section( Standard )
--------------------------------------------------------------
content | versionread | Class( Comment ), Section( Standard ),
                      | Owner( Self ),
                      | Status( Draft , Pending )


5. FAQ
------

Q:

Why is the captcha image empty?

A:

First check whether you forgot to provide a password length
with the attribute configuration option.

If that does not
help, then check whether the path to the TTF font file is
correct in antispam/settings/antispam.ini. It should be
relative to the eZ publish root, for example:

FontName=./extension/antispam/design/standard/fonts/arial.ttf


6. Changelog
------------
* 1.0:
    - Initial release
    - 20/09/2005

* 1.1:
    - Fixed: call time pass by reference issues
    - Fixed: use ezroot() instead of ezurl() [*]
    - Added: create directory if it does not exist where we
      store captcha images [*]
    - Added: arial.ttf as font usable out-of-the-box [*]
    - Added: more documentation (esp. configuration) [*]
    - Release date: 09/12/2005


7. Thanks
---------
All changes marked with [*] have been kindly contributed by
Sandro Groganz.


8. Copyright
------------
Antispam extension for eZ publish 3.6+
Copyright (C) 2005  SCK-CEN (Belgian Nuclear Research Centre)

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

Please consult license.txt for the complete GNU GPL License.


9. Contact
----------
In either of these cases you are welcome to contact us:

- You found a bug
- You have a comment
- You want to congratulate us
- You just want to say hello

Developed by:
 - Hans Melis <hmelis #at# sckcen #dot# be>
 - Tom Couwberghs <tcouwber #at# sckcen #dot# be>


10. Disclaimer
--------------
This extension is developed in the framework of knowledge management
projects. It is contributed to the eZ publish community as is.

YMMV!