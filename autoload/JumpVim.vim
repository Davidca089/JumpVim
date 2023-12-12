function! JumpVim#Setup()
    if empty(glob($HOME . "/.cache/JumpVim"))
        call mkdir($HOME . "/.cache/JumpVim")
    endif

    if empty(glob($HOME . "/.cache/JumpVim/slots.json"))
        call writefile(['{"slot1": [], "slot2": [], "slot3": [], "slot4": []}'], $HOME . "/.cache/JumpVim/slots.json")
    endif

endfunction

function s:AddSlot(id, result)
    let l:curr_pos = getpos('.')
    let l:row = curr_pos[1]
    let l:col = curr_pos[2]
    let l:filename = expand('%:p')

    let l:dict = json_decode(readfile($HOME . "/.cache/JumpVim/slots.json")[0])

    let dict["slot". a:result] = [l:filename, l:row, l:col]
    call writefile([json_encode(l:dict)], $HOME . "/.cache/JumpVim/slots.json")

endfunction

function s:WindowHandler(id, result)
    if a:result =~? '[1234]'
        call win_execute(a:id, 'call cursor(' . a:result . ',1)')
    else
        return popup_filter_menu(a:id, a:result)
    endif
endfunction

function! JumpVim#GoToSlot(slot_num)
    let l:slot = "slot" . a:slot_num
    if empty(glob($HOME . "/.cache/JumpVim/slots.json"))
        return 1
    endif

    let l:json = json_decode(readfile($HOME . "/.cache/JumpVim/slots.json")[0])
    if json[l:slot] == []
        return 1
    endif

    let l:args = get(json, l:slot)
    echo args

    let l:filename = args[0]
    let l:row = args[1]
    let l:col = args[2]

    echo filename row col

endfunction

function! JumpVim#ShowWindow()
    call popup_menu(['One', 'Two', 'Three', 'Four'],
                \#{ title: "Save mark to slot ...",
                \ highlight: 'Normal',
                \ filter: function('s:WindowHandler'),
                \ callback: function('s:AddSlot'),
                \ })

endfunction
