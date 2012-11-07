
" outline info for Objective-C


function! unite#sources#outline#objc#outline_info()
  return s:outline_info
endfunction


let s:heading_pattern = '^\s*@\(implementation\|interface\|property\)\>'.'\|'.'^\s*\(+\|-\).*'.'\|'.'#pragma\s\+mark\s\+\zs.\+'
"let s:heading_pattern = '#pragma\s\+mark\s\+\zs.\+'
"let s:heading_pattern = '^\s*\(+\|-\).*'
"let s:heading_pattern = '^\s*@\(implementation\|interface\)\>'
"let s:heading_pattern = '^\s*@interface\>'
"-----------------------------------------------------------------------------
" Outline Info

let s:outline_info = {
      \ 'heading': s:heading_pattern,
      \
      \
      \ 'skip': { 'header': '^"' },
      \
      \
      \ 'highlight_rules': [
      \   { 'name'     : 'comment',
      \     'pattern'  : '/\/\/.*/' },
      \   { 'name'     : 'implementation',
      \     'pattern'  : '/@implementation/',
      \     'highlight': unite#sources#outline#get_highlight('type') },
      \   { 'name'     : 'interface',
      \     'pattern'  : '/@interface/',
      \     'highlight': unite#sources#outline#get_highlight('type') },
      \   { 'name'     : 'property',
      \     'pattern'  : '/@property/',
      \     'highlight': unite#sources#outline#get_highlight('type') },
      \   { 'name'     : 'pragma',
      \     'pattern'  : '/#pragma\s\+mark\s/',
      \     'highlight': unite#sources#outline#get_highlight('type') },
      \ ],
      \}

function! s:outline_info.create_heading(which, heading_line, matched_line, context)
  let heading = {
        \ 'word' : a:heading_line,
        \ 'level': 0,
        \ 'type' : 'generic',
        \ }

  if heading.word =~ '^@interface'
    let heading.type = 'interface'
    let heading.level = 4
  elseif heading.word =~ '^@implementation'
    let heading.type = 'implementation'
    let heading.level = 4
  elseif heading.word =~ '^@property'
    let heading.type = 'property'
    let heading.level = 6
  elseif heading.word =~ '#pragma\s\+mark\s'
    let heading.type = 'pragma'
    let heading.level = 5
  else
    let heading.type = 'function'
    let heading.level = 6
  endif

  if heading.level > 0
    return heading
  else
    return {}
  endif
endfunction
