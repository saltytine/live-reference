if exists('g:loaded_live_refs')
    finish
endif
let g:loaded_live_refs = 1

let g:live_refs_enabled = get(g:, 'live_refs_enabled', 1)
let g:live_refs_min_word_len = get(g:, 'live_refs_min_word_len', 3)
let g:live_refs_max_results = get(g:, 'live_refs_max_results', 10)

let s:current_word = ''
let s:popup_id = -1
let s:last_pos = [0, 0]

function! s:ClosePopup()
    if s:popup_id != -1
        try
            call popup_close(s:popup_id)
        catch
        endtry
        let s:popup_id = -1
    endif
endfunction

function! s:GetWordUnderCursor()
    let word = expand('<cword>')
    if len(word) < g:live_refs_min_word_len || word !~ '\w'
        return ''
    endif
    return word
endfunction

function! s:FindWordOccurrences(word)
    let results = []
    let current_line = line('.')

    let save_pos = getcurpos()
    call cursor(1, 1)

    let search_pattern = '\<' . escape(a:word, '\/.*$^~[]') . '\>'
    let flags = 'W'

    while 1
        let pos = searchpos(search_pattern, flags)
        if pos[0] == 0
            break
        endif

        if pos[0] != current_line
            let line_text = getline(pos[0])
            call add(results, {'lnum': pos[0], 'text': trim(line_text)})
        endif

        if len(results) >= g:live_refs_max_results
            break
        endif

        let flags = 'W'
    endwhile

    call setpos('.', save_pos)
    return results
endfunction

function! s:ShowReferences(word, results)
    if empty(a:results)
        return
    endif

    let lines = ['References for "' . a:word . '":']
    for result in a:results
        call add(lines, printf('%4d: %s', result.lnum, result.text))
    endfor

    let opts = {
        \ 'line': 'cursor+1',
        \ 'col': 'cursor',
        \ 'minwidth': 40,
        \ 'maxwidth': 80,
        \ 'minheight': 1,
        \ 'maxheight': 15,
        \ 'border': [1, 1, 1, 1],
        \ 'borderchars': ['-', '|', '-', '|', '+', '+', '+', '+'],
        \ 'padding': [0, 1, 0, 1],
        \ 'close': 'click',
        \ 'moved': 'any'
        \ }

    let s:popup_id = popup_create(lines, opts)

    call popup_setoptions(s:popup_id, {
        \ 'filter': function('s:PopupFilter', [a:results])
        \ })
endfunction

function! s:PopupFilter(results, id, key)
    if a:key == "\<Esc>" || a:key == 'q'
        call popup_close(a:id)
        return 1
    endif

    if a:key =~ '^[1-9]$'
        let idx = str2nr(a:key) - 1
        if idx < len(a:results)
            call popup_close(a:id)
            execute 'normal! ' . a:results[idx].lnum . 'G'
        endif
        return 1
    endif

    return 0
endfunction

function! s:UpdateReferences()
    if !g:live_refs_enabled
        return
    endif

    let current_pos = [line('.'), col('.')]
    if current_pos == s:last_pos
        return
    endif
    let s:last_pos = current_pos

    let word = s:GetWordUnderCursor()

    if word != s:current_word
        call s:ClosePopup()
        let s:current_word = word
    endif

    if empty(word)
        return
    endif

    let results = s:FindWordOccurrences(word)

    if !empty(results)
        call s:ShowReferences(word, results)
    endif
endfunction

function! s:ToggleLiveRefs()
    let g:live_refs_enabled = !g:live_refs_enabled
    if !g:live_refs_enabled
        call s:ClosePopup()
        echo 'Live refs disabled'
    else
        echo 'Live refs enabled'
    endif
endfunction

augroup LiveRefs
    autocmd!
    autocmd CursorHold * call s:UpdateReferences()
    autocmd CursorMoved * call s:ClosePopup()
    autocmd InsertEnter * call s:ClosePopup()
    autocmd WinLeave * call s:ClosePopup()
augroup END

command! LiveRefsToggle call s:ToggleLiveRefs()
command! LiveRefsShow call s:UpdateReferences()

nnoremap <silent> <leader>lr :LiveRefsToggle<CR>
