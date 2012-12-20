<?php /* #?ini charset="koi8-r"?

[children]
Parameter[sort_by]=sort_by
Parameter[parent_node_id]=parent_node_id
Parameter[offset]=offset
Parameter[limit]=limit
Module=content
FunctionName=list

[children_count]
Parameter[parent_node_id]=parent_node_id
Module=content
FunctionName=list_count

[subtree]
Constant[sort_by]=priority;0
Parameter[parent_node_id]=parent_node_id
Parameter[offset]=offset
Parameter[limit]=limit
Module=content
FunctionName=tree

[comments]
Constant[sort_by]=published;0
Constant[class_filter_type]=include
Constant[class_filter_array]=comment
Parameter[parent_node_id]=parent_node_id
Module=content
FunctionName=list

[comments_count]
Constant[class_filter_type]=include
Constant[class_filter_array]=comment
Parameter[parent_node_id]=parent_node_id
Module=content
FunctionName=list_count

[related_objects]
Parameter[sort_by]=sort_by
Module=content
FunctionName=related_objects

[related_objects_count]
Module=content
FunctionName=related_objects_count

[topics]
Constant[sort_by]=published;0
Module=content
FunctionName=related_objects

*/ ?>