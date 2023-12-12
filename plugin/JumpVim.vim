if exists("g:is_loaded_jump_vim")
    finish
endif

let g:is_loaded_jump_vim = 1

command! -nargs=0 Testy call JumpVim#Setup()
command! -nargs=0 ShowWindow call JumpVim#ShowWindow()
command! -nargs=1 GoToSlot call JumpVim#GoToSlot(<q-args>)
