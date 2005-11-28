" Document {{{
" COPYRIGHT: Copyright (C) 2005 Bruce Who
"            Permission is hereby granted to use and distribute this code,
"            with or without modifications, provided that this copyright
"            notice is copied with it. Like anything else that's free,
"            bwTemplate.vim(and its templates) is provided *as is* and
"            comes with no warranty of any kind, either expressed or
"            implied. In no event will the copyright holder be liable for
"            any damages resulting from the use of this software.
" FILENAME:  bwTemplate.vim
" AUTHOR:    Bruce Who (a.k.a 胡旭昭, or Hu Xuzhao)
" EMAIL:     Bruce.Who.hk at gmail.com
" DATE:      2004-11-20
" $Revision: 1.7 $
"
" DESCRIPTION:
"   Please don't hesitate to correct my English :)
"
"   This script can be used to load template files just to save time. It
"   shows templates for current buffer's filetype, you can choose one and
"   load it. Some templates are distributed with this script, and I will
"   add more if I have time. Of course, you can post your templates to me
"   if you like, and I will add them to this package and your name to this
"   script, :-)
"
"   If you find any bugs or solutions to the known bugs, please send it to
"   me.
"
" INSTALLATION:
"   Drop the script to your plugin directory. And you can place the
"   'templates' directory where you prefer. But DONNOT forget to set the
"   'g:bwTemplateDir' variable to it.
"
" PREREQUISITE:
"   This script needs bwLibUI.vim and libList.vim
"
" USAGE:
"   You need to config following global variables in your _vimrc:
"   - g:bwTemplateDir
"       define g:bwTemplateDir in .vimrc to specify where the 'templates'
"       directory is.
"       let g:bwTemplateDir = 'c:/vim/templates/'
"       NOTE: don't forget the last /! 'c:/vim/templates/' is wrong!
"   - g:bwTemplate_author
"       e.g., let g:bwTemplate_author='Your name'. This is optional.
"   - g:bwTemplate_email
"       e.g., let g:bwTemplate_email='Your email'. This is optional.
"
"   commands:
"     :WTemplate      automatically load a template file
"     :WTemplateList  load a template file from a list
"   keymaps:
"     <F4>t   WTemplate
"     <S-F>t  WTemplateList
"
" HOW_TO_WRITE_A_TEMPLATE:
"   you can use in a template some special tags which will be replaced after
"   the template is loaded, they are:
"
"       - @AUTHOR@         bwTemplate_author
"       - @EMAIL@          bwTemplate_email
"
"       - @DATE@           date in %Y-%m-%d format, e.g. 2005-11-26
"       - @TIME@           time in %H:%M:%S format, e.g. 16:23:27
"       - @YEAR@           year, e.g. 2005
"
"       - @PARENTDIR@      parent directory's name, for 'e:/files/a.c', it's
"                          'files'
"       - @FILE@           file name with extension name, e.g. 'main.c'
"       - @FILENAME@       file name, for 'main.c', it's 'main'         
"       - @FILE_EXT@       extension file name, for 'main.c', it's 'c'
"       - @INCLUDE_GUARD@  for C/CPP header files, e.g. 'SAMPLE_H'. It is
"                          the file name with ext and with . replaced by _
"
"       - @CURSOR@         this tag is special, it will not be expanded to
"                          any string. It's where your cursor is after the
"                          template is loaded.
"
"   you need not to use following tags if you don't add templates to CVS.
"   They are converted to corresponding CVS tags.
"       - @CVS_AUTHOR@   author
"       - @CVS_DATE@     date
"       - @CVS_HEADER@   header
"       - @CVS_ID@       id
"       - @CVS_LOCKER@   locker
"       - @CVS_LOG@      log
"       - @CVS_NAME@     name
"       - @CVS_RCSfile@  RCSfile
"       - @CVS_REVISION@ revision
"       - @CVS_SOURCE@   source
"       - @CVS_STATE@    state
"
"   After you have finished your template, you can place the template in
"   'g:bwTemplateDir' with the name 'default' + filetype, such as
"   'sample.python'. This is the simplest way to add a template, but only
"   one file is allowed for each filetype.
"
"   If you want to add more templates for a filetype. You can create a
"   sub-directory in 'g:bwTemplateDir' with filetype as its name, e.g.
"   'python'. And then you just need to drop your template into that
"   direcotry.
"
" TODO:
"   - use built-in list instead of libList.vim
"   - use substitute() in place of %s
"   - add a menu for templates
"
" KNOWN_BUGS:
"   - After a template is loaded to a empty buffer, there is always a blank
"     line left at the end.
" }}}

if exists('g:bwTemplate') " {{{
  finish
endif
let g:bwTemplate = 1 " }}}

let s:path = expand('<sfile>:p:h')

" gobal setting {{{
if !exists('g:bwTemplateDir')
  let g:bwTemplateDir = s:path.'/templates/'
endif

if !exists('g:bwTemplate_author')
  let g:bwTemplate_author = ''
endif

if !exists('g:bwTemplate_email')
  let g:bwTemplate_email = ''
endif

"" let g:whose_WTemplate_lht = '@'
"" let g:whose_WTemplate_rht = '@'
" }}}

" commands {{{
command! -nargs=? WTemplate call <SID>PickUpTemplate(1,<f-args>)
command! -nargs=? WTemplateList call <SID>PickUpTemplate(0,<f-args>)
" }}}

" keymaps {{{
nnoremap <F4>t :WTemplate<CR>
nnoremap <S-F4>t :WTemplateList<CR>
" }}}

" Implement {{{
function! s:PickUpTemplate(auto,...) " {{{
" pick up a template from several candidates
" @auto: 1,load the first one
"        0,show all
" @type: 'c': template for .c
"        'makefile': template for makefile
" function! s:PickUpTemplate(auto,type)
  " get the default template file
  if a:0 == 1
    let type = a:1
  else
    let type = ''
  endif
  let template_file = s:GetDefaultTemplateFilePath()
  " check the default template file
  let file_list = ""
  let name_list = ""
  if filereadable( template_file )
    if a:auto == 1
      call s:LoadFile( template_file )
      return
    endif
    let file_list = AddListItem( file_list, template_file, 0 )
    let name_list = AddListItem( name_list,
                               \ fnamemodify(template_file, ":t"),
                               \ 0 )
  endif
  " get the template directory
  let template_dir = s:GetTemplateDirPath()
  if isdirectory(template_dir)
    " append all files in template_dir to the file_list
    let j = GetListCount( file_list )
    let files = glob(template_dir . '*')
    let tmp_list = substitute(files, "\n", g:listSep, "g")
    let total = GetListCount( tmp_list )
    let i = 0
    while i < total
      let fn = GetListItem( tmp_list, i )
      let file_list = AddListItem( file_list, fn, j )
      let name_list = AddListItem( name_list, fnamemodify(fn, ":t"), j )
      let i = i + 1
      let j = j + 1
    endwhile
  endif
  " auto
  if a:auto == 1 && GetListCount( file_list ) != 0
    call s:LoadFile( GetListItem( file_list, 0 ) )
    return
  endif
  if GetListCount( file_list ) == 0
    echo 'no template files!'
  else
    let sel = Whose_ChoiceList( "Choose one template",
                              \ name_list,
                              \ "choice:",
                              \ 3)
    call s:LoadFile( GetListItem( file_list, sel ) )
  endif
endfunction " }}}

function s:LoadFile(fn) " {{{
" insert the file to the current position
" @fn: filename
  exe '0read ' . a:fn
  call s:SubstituteFile()
  go
  let res = search('@CURSOR@','W')
  if res == 0
  else
    substitute/@CURSOR@//
  endif
  normal zz
endfunction " }}}

function s:SubstituteFile() " {{{
" substitute tags like @FILE@
  let author = g:bwTemplate_author
  let email = g:bwTemplate_email
	let time = strftime("%H:%M:%S")
	let date = strftime("%Y-%m-%d")
	let year = strftime("%Y")
	let cwd = getcwd()
	let parent_dir = substitute(cwd, ".*/", "", "g")
  let myfile = expand("%:t")
	let myfilename = expand("%:t:r")
	let myfile_ext = expand("%:e")
	let inc_guard = substitute(myfile, "\\.", "_", "g")
	let inc_guard = toupper(inc_guard)
	silent! execute "%s/@AUTHOR@/" . author . "/g"
	silent! execute "%s/@EMAIL@/" . email . "/g"
	silent! execute "%s/@DATE@/" . date . "/g"
	silent! execute "%s/@TIME@/" . time . "/g"
	silent! execute "%s/@YEAR@/" . year . "/g"
	silent! execute "%s/@PARENTDIR@/" . parent_dir . "/g"
	silent! execute "%s/@FILE@/" . myfile . "/g"
	silent! execute "%s/@FILENAME@/" . myfilename . "/g"
	silent! execute "%s/@FILE_EXT@/" . myfile_ext . "/g"
	silent! execute "%s/@INCLUDE_GUARD@/" . inc_guard . "/g"
	silent! execute "%s/@CVS_AUTHOR@/$".'Author$' . "/g"
	silent! execute "%s/@CVS_DATE@/$".'Date$' . "/g"
	silent! execute "%s/@CVS_HEADER@/$".'Header$' . "/g"
	silent! execute "%s/@CVS_ID@/$".'Id$' . "/g"
	silent! execute "%s/@CVS_LOCKER@/$".'Locker$' . "/g"
	silent! execute "%s/@CVS_LOG@/$".'Log$' . "/g"
	silent! execute "%s/@CVS_NAME@/$".'Name$' . "/g"
	silent! execute "%s/@CVS_RCSfile@/$".'RCSfile$' . "/g"
	silent! execute "%s/@CVS_REVISION@/$".'Revision$' . "/g"
	silent! execute "%s/@CVS_SOURCE@/$".'Source$' . "/g"
	silent! execute "%s/@CVS_STATE@/$".'State$' . "/g"
endfunction " }}}

" function! s:GetDefaultTemplateFilePath(...) {{{
function! s:GetDefaultTemplateFilePath(...)
"function! s:GetDefaultTemplateFileName(filetype='')
"@filetype: 'python', 'txt',... If '', then the current buffer's filetype
"           is used.
  if a:0 == 1 && a:1 != ''
    let ft = a:1
  elseif a:0 == 0
    let ft = &filetype
  else
    throw 'wrong arguments!'
  endif
  return g:bwTemplateDir . 'default.' . ft
endfunction
" }}}

" function! s:GetTemplateDirPath(...) {{{
function! s:GetTemplateDirPath(...)
"function! s:GetTemplateDirPath(filetype='')
"@filetype: 'python', 'txt',... If '', then the current buffer's filetype
"           is used.
  if a:0 == 1 && a:1 != ''
    let ft = a:1
  elseif a:0 == 0
    let ft = &filetype
  else
    throw 'wrong arguments!'
  endif
  return g:bwTemplateDir . ft . '/'
endfunction
" }}}

" XXX add a menu of templates for buffers with different filetypes. {{{
"
" function! s:FindTemplatesForFiletype(filetype)
" "@return: two lists, found templates' path and their names
" endfunction
"
" let s:has_menu=0
" 
" function! s:MakeTemplateMenu()
"   if s:has_menu
"     " remove the old one
"     aunmenu bwTemplate
"     " build the new one
"     menu bwTemplate
"     let s:has_menu = 1
"   endif
" endfunction

" au BufEnter * call <SID>MakeTemplateMenu()
" }}}

" }}}

" Modeline for ViM {{{
" vim:fdm=marker fdl=0 fdc=3 fenc=utf-8 bomb:
" }}} */
