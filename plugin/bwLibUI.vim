" bwLibUI.vim
" Bruce Who
" 2004-11-20
" Depend on LibList.vim
if exists("g:whose_LibUI")
  finish
endif
let g:whose_LibUI=1

" @promptList: a string list created by libList.vim
" @cols: how many columns
function! Whose_CreatePromptList(promptList, cols)
  let num_common = GetListCount(a:promptList)
  let i = 0
  let promptStr = ""
  while i < num_common
    let j = 0
    while j < a:cols && i + j < num_common
      let com = GetListItem(a:promptList, i+j)
      let promptStr = promptStr.'('.(i+j+1).') '. 
            \ com."\t".( strlen(com) < 4 ? "\t" : '' )
      let j = j + 1
    endwhile
    let promptStr = promptStr."\n"
    let i = i + a:cols
  endwhile
  return promptStr
endfunction 

" @retrun: the index of the list starting with 0
function! Whose_ChoiceList(top,list,prompt,cols)
  let choice=input(a:top . "\n" . Whose_CreatePromptList(a:list,a:cols) . "\n" . a:prompt)
  if choice =~ '\d\+'  && choice <=  GetListCount(a:list) && choice >0
    return choice -1
  elseif choice==""
    " default is 0
    return 0
  else
    echo "wrong choice! First one is selected."
    return 0
  endif
endfunction
