; minimal, nvim 0.11.x compatible (no except*)
[
  "def" "class" "return" "if" "elif" "else" "for" "while"
  "try" "except" "finally" "with" "as" "pass" "break" "continue"
  "lambda" "yield" "from" "import" "global" "nonlocal" "assert"
  "del" "async" "await" "match" "case" "raise"
] @keyword

(string) @string
(comment) @comment
(integer) @number
(float) @number
(none) @constant.builtin
(true) @boolean
(false) @boolean

(function_definition name: (identifier) @function)
(class_definition name: (identifier) @type)
(call function: (identifier) @function.call)
(attribute attribute: (identifier) @field)
(assignment left: (identifier) @variable)

(import_statement name: (dotted_name (identifier) @namespace))
(import_from_statement module_name: (dotted_name (identifier) @namespace))
