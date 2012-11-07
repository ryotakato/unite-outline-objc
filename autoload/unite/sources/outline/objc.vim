"=============================================================================
" File    : autoload/unite/sources/outline/objc.vim
" Author  : ryotakato <ryotakato4@gmail.com>
" Updated : 2012-11-07
"
" Licensed under the MIT license:
" http://www.opensource.org/licenses/mit-license.php
"
"=============================================================================


" outline info for Objective-C
" Version: 0.1.0

function! unite#sources#outline#objc#outline_info()
  return s:outline_info
endfunction


" select heading regex pattern
let s:heading_pattern = 
            \ '^\s*@\(implementation\|interface\|property\)\>'
            \ .'\|'.'^\s*\(+\|-\).*'
            \ .'\|'.'#pragma\s\+mark\s\+\zs.\+'

"-----------------------------------------------------------------------------
" Outline Info

let s:outline_info = {
      \ 'heading': s:heading_pattern,
      \
      \ 'highlight_rules': [
      \   { 'name'     : 'comment',
      \     'pattern'  : '/\/\/.*/' },
      \   { 'name'     : 'implementation',
      \     'pattern'  : '/@implementation/',
      \     'highlight': unite#sources#outline#get_highlight('special') },
      \   { 'name'     : 'interface',
      \     'pattern'  : '/@interface/',
      \     'highlight': unite#sources#outline#get_highlight('special') },
      \   { 'name'     : 'property',
      \     'pattern'  : '/@property/',
      \     'highlight': unite#sources#outline#get_highlight('id') },
      \   { 'name'     : 'pragma',
      \     'pattern'  : '/\zs.*\ze # pragma mark/',
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
    let heading.word = substitute(heading.word, '{', '', '') 
  elseif heading.word =~ '^@implementation'
    let heading.type = 'implementation'
    let heading.level = 4
  elseif heading.word =~ '^@property'
    let heading.type = 'property'
    let heading.level = 6
  elseif heading.word =~ '^#pragma\s\+mark\s'
    let heading.type = 'pragma'
    let heading.level = 5
    let heading.word = substitute(heading.word, '^#pragma\s\+mark\s\+', '', '') . ' # pragma mark'
  else
    let heading.type = 'method'
    let heading.level = 6
    let heading.word = substitute(heading.word, '{', '', '') 
  endif

  if heading.level > 0
    return heading
  else
    return {}
  endif
endfunction

