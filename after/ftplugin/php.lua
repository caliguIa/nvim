local debug_variable = require "utils.debug_under_cursor"

debug_variable.setup_debug_keymap(
    { "variable_name", "name" },
    function(variable_name) return string.format("dd(%s);", variable_name) end
)
