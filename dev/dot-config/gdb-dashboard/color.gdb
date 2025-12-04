# dashboard -style style_selected_1 '47;1'
dashboard -style style_selected_2 '47'
dashboard -style style_low '30;1'
dashboard -style style_high '34'
# dashboard -style style_error '31'
# dashboard -style style_critical '31;7'

dashboard -style style_selected_1 ';7' # current/changed values: bold
# dashboard -style style_selected_1 ';7' # current/changed values: reversed
# dashboard -style style_selected_2 '90;7' # surrounding items: grey, reversed
# dashboard -style style_low '0' # register names etc.: black
# dashboard -style style_high '34' # variable identifiers: blue
dashboard -style style_error '31' # error messages
dashboard -style style_critical '97;41' # breakpoints, ellipses: white on red

dashboard -style divider_fill_style_primary '36'
dashboard -style divider_label_style_on_primary '34;1'
dashboard -style divider_label_style_off_primary '34'

dashboard -style divider_fill_style_secondary '30'
dashboard -style divider_label_style_on_secondary '30'
dashboard -style divider_label_style_off_secondary '30;1'

dashboard -style syntax_highlighting 'xcode'
dashboard -style prompt_not_running '\\[\\e[30m\\]>>>\\[\\e[0m\\]'
