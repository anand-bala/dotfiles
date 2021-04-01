if exists("b:current_syntax")
  finish
endif

syntax match rosmsgComment "\v#.*$"

syntax keyword rosmsgPrimitives bool
syntax keyword rosmsgPrimitives byte
syntax keyword rosmsgPrimitives char
syntax keyword rosmsgPrimitives float32
syntax keyword rosmsgPrimitives float64
syntax keyword rosmsgPrimitives int8
syntax keyword rosmsgPrimitives uint8
syntax keyword rosmsgPrimitives int16
syntax keyword rosmsgPrimitives uint16
syntax keyword rosmsgPrimitives int32
syntax keyword rosmsgPrimitives uint32
syntax keyword rosmsgPrimitives int64
syntax keyword rosmsgPrimitives uint64
syntax keyword rosmsgPrimitives string

syntax match rosmsgType         "\v^\h\w+(/\h\w+)=" nextgroup=rosmsgArray,rosmsgField,rosmsgConstant
syntax match rosmsgArray        "\v\[(\<\=)?\d*\]"
syntax match rosmsgField        "\v\s+\h\w*(\w*\s*\=)@!" contains=rosmsgFieldName
syntax match rosmsgFieldName    "\v\h\w*" contained
syntax match rosmsgConstant     "\v\s+\u[0-9A-Z_]*(\s*\=)@=" contains=rosmsgConstantName
syntax match rosmsgConstantName "\v\u[0-9A-Z_]*" contained



highlight link rosmsgComment        Comment
highlight link rosmsgPrimitives     Keyword
highlight link rosmsgType           Type
highlight link rosmsgArray          Type
highlight link rosmsgFieldName      Identifier
highlight link rosmsgConstantName   Constant

let b:current_syntax = "rosmsg"
