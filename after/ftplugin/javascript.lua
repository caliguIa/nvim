local debug_variable = require "utils.debug_under_cursor"

debug_variable.setup_debug_keymap(
    { "identifier" },
    function(variable_name) return string.format("console.log('%s', %s);", variable_name, variable_name) end
)
