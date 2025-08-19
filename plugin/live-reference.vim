if exists('g:loaded_live_refs')
    finish
endif
let g:loaded_live_refs = 1

let g:live_refs_enabled = get(g:, 'live_refs_enabled', 1)
let g:live_refs_min_word_len = get(g:, 'live_refs_min_word_len', 3)
let g:live_refs_max_results = get(g:, 'live_refs_max_results', 10)
let g:live_refs_updatetime = get(g:, 'live_refs_updatetime', 700)

if g:live_refs_enabled && &updatetime > g:live_refs_updatetime
    let &updatetime = g:live_refs_updatetime
endif

let s:keywords = {
    \ 'python': ['def', 'class', 'if', 'else', 'elif', 'for', 'while', 'try', 'except', 'finally', 'with', 'as', 'import', 'from', 'return', 'yield', 'break', 'continue', 'pass', 'and', 'or', 'not', 'in', 'is', 'None', 'True', 'False', 'len', 'str', 'int', 'float', 'list', 'dict', 'set', 'tuple', 'range', 'enumerate', 'zip', 'print', 'input', 'open', 'close', 'read', 'write', 'split', 'join', 'strip', 'replace', 'find', 'get', 'pop', 'append', 'extend', 'insert', 'remove', 'sort', 'reverse', 'lambda', 'global', 'nonlocal', 'assert', 'del', 'exec', 'eval', 'async'],
    \ 'javascript': ['function', 'var', 'let', 'const', 'if', 'else', 'for', 'while', 'do', 'switch', 'case', 'default', 'break', 'continue', 'return', 'try', 'catch', 'finally', 'throw', 'new', 'this', 'typeof', 'instanceof', 'in', 'of', 'true', 'false', 'null', 'undefined', 'console', 'log', 'length', 'push', 'pop', 'shift', 'unshift', 'slice', 'splice', 'indexOf', 'includes', 'forEach', 'map', 'filter', 'reduce', 'find', 'some', 'every', 'async', 'await', 'class', 'extends', 'super', 'static', 'import', 'export', 'from', 'default', 'delete', 'void'],
    \ 'typescript': ['function', 'var', 'let', 'const', 'if', 'else', 'for', 'while', 'do', 'switch', 'case', 'default', 'break', 'continue', 'return', 'try', 'catch', 'finally', 'throw', 'new', 'this', 'typeof', 'instanceof', 'in', 'of', 'true', 'false', 'null', 'undefined', 'console', 'log', 'length', 'async', 'await', 'class', 'extends', 'super', 'static', 'import', 'export', 'from', 'default', 'delete', 'void', 'interface', 'type', 'enum', 'namespace', 'module', 'declare', 'abstract', 'implements', 'private', 'protected', 'public', 'readonly', 'string', 'number', 'boolean', 'any', 'unknown', 'never', 'object'],
    \ 'c': ['int', 'char', 'float', 'double', 'void', 'short', 'long', 'signed', 'unsigned', 'if', 'else', 'for', 'while', 'do', 'switch', 'case', 'default', 'break', 'continue', 'return', 'sizeof', 'typedef', 'struct', 'union', 'enum', 'const', 'static', 'extern', 'auto', 'register', 'volatile', 'goto', 'NULL', 'true', 'false', 'malloc', 'calloc', 'realloc', 'free', 'printf', 'scanf', 'fprintf', 'sprintf', 'strlen', 'strcpy', 'strcmp', 'strcat', 'strncpy', 'strncmp', 'strncat', 'memcpy', 'memset', 'memcmp', 'fopen', 'fclose', 'fread', 'fwrite', 'fgets', 'fputs', 'fgetc', 'fputc', 'include', 'define', 'ifdef', 'ifndef', 'endif', 'pragma'],
    \ 'cpp': ['int', 'char', 'float', 'double', 'bool', 'void', 'short', 'long', 'signed', 'unsigned', 'wchar_t', 'class', 'struct', 'public', 'private', 'protected', 'virtual', 'override', 'final', 'friend', 'operator', 'if', 'else', 'for', 'while', 'do', 'switch', 'case', 'default', 'break', 'continue', 'return', 'try', 'catch', 'throw', 'new', 'delete', 'this', 'nullptr', 'true', 'false', 'const', 'static', 'extern', 'inline', 'mutable', 'explicit', 'template', 'typename', 'namespace', 'using', 'std', 'cout', 'cin', 'cerr', 'clog', 'endl', 'size', 'empty', 'begin', 'end', 'rbegin', 'rend', 'push_back', 'pop_back', 'push_front', 'pop_front', 'insert', 'erase', 'clear', 'find', 'count', 'lower_bound', 'upper_bound', 'sort', 'reverse', 'swap', 'move', 'forward', 'get', 'first', 'second', 'auto', 'decltype', 'constexpr', 'noexcept', 'thread_local'],
    \ 'java': ['class', 'interface', 'extends', 'implements', 'enum', 'package', 'import', 'public', 'private', 'protected', 'static', 'final', 'abstract', 'synchronized', 'volatile', 'transient', 'native', 'strictfp', 'if', 'else', 'for', 'while', 'do', 'switch', 'case', 'default', 'break', 'continue', 'return', 'try', 'catch', 'finally', 'throw', 'throws', 'new', 'this', 'super', 'null', 'true', 'false', 'instanceof', 'int', 'char', 'float', 'double', 'boolean', 'byte', 'short', 'long', 'void', 'String', 'Object', 'Integer', 'Double', 'Boolean', 'Character', 'Long', 'Short', 'Byte', 'Float', 'System', 'out', 'err', 'in', 'println', 'print', 'printf', 'length', 'size', 'get', 'set', 'add', 'remove', 'contains', 'isEmpty', 'clear', 'toString', 'equals', 'hashCode', 'clone', 'wait', 'notify', 'notifyAll', 'getClass'],
    \ 'go': ['func', 'var', 'const', 'type', 'struct', 'interface', 'map', 'slice', 'array', 'chan', 'package', 'import', 'if', 'else', 'for', 'range', 'switch', 'case', 'default', 'break', 'continue', 'fallthrough', 'return', 'go', 'defer', 'select', 'make', 'new', 'len', 'cap', 'append', 'copy', 'delete', 'close', 'panic', 'recover', 'print', 'println', 'true', 'false', 'nil', 'iota', 'int', 'int8', 'int16', 'int32', 'int64', 'uint', 'uint8', 'uint16', 'uint32', 'uint64', 'uintptr', 'float32', 'float64', 'complex64', 'complex128', 'byte', 'rune', 'string', 'bool', 'error', 'fmt', 'Printf', 'Println', 'Sprintf', 'Errorf', 'os', 'io', 'bufio', 'strings', 'strconv', 'time', 'log', 'http', 'json', 'context', 'sync', 'atomic'],
    \ 'rust': ['fn', 'let', 'mut', 'const', 'static', 'struct', 'enum', 'impl', 'trait', 'type', 'use', 'mod', 'pub', 'crate', 'super', 'self', 'Self', 'if', 'else', 'match', 'for', 'while', 'loop', 'break', 'continue', 'return', 'yield', 'move', 'ref', 'where', 'as', 'unsafe', 'extern', 'true', 'false', 'Some', 'None', 'Ok', 'Err', 'Option', 'Result', 'Vec', 'HashMap', 'HashSet', 'BTreeMap', 'BTreeSet', 'String', 'str', 'i8', 'i16', 'i32', 'i64', 'i128', 'isize', 'u8', 'u16', 'u32', 'u64', 'u128', 'usize', 'f32', 'f64', 'bool', 'char', 'Box', 'Rc', 'Arc', 'RefCell', 'Mutex', 'RwLock', 'len', 'is_empty', 'push', 'pop', 'insert', 'remove', 'get', 'contains', 'iter', 'into_iter', 'map', 'filter', 'fold', 'reduce', 'collect', 'unwrap', 'expect', 'panic', 'println', 'print', 'dbg', 'todo', 'unimplemented', 'unreachable'],
    \ 'swift': ['func', 'var', 'let', 'class', 'struct', 'enum', 'protocol', 'extension', 'import', 'public', 'private', 'internal', 'fileprivate', 'open', 'static', 'final', 'override', 'required', 'convenience', 'lazy', 'weak', 'unowned', 'if', 'else', 'guard', 'switch', 'case', 'default', 'for', 'while', 'repeat', 'break', 'continue', 'fallthrough', 'return', 'throw', 'throws', 'rethrows', 'try', 'catch', 'defer', 'do', 'in', 'is', 'as', 'super', 'self', 'Self', 'init', 'deinit', 'subscript', 'willSet', 'didSet', 'get', 'set', 'mutating', 'nonmutating', 'dynamic', 'optional', 'required', 'true', 'false', 'nil', 'Any', 'AnyObject', 'Type', 'String', 'Int', 'Double', 'Float', 'Bool', 'Character', 'print', 'debugPrint', 'dump', 'fatalError', 'precondition', 'assert', 'count', 'isEmpty', 'first', 'last', 'append', 'insert', 'remove', 'removeAll', 'contains', 'map', 'filter', 'reduce', 'forEach', 'compactMap', 'flatMap', 'sorted', 'reversed'],
    \ 'vim': ['function', 'endfunction', 'if', 'endif', 'elseif', 'else', 'for', 'endfor', 'while', 'endwhile', 'try', 'endtry', 'catch', 'finally', 'throw', 'return', 'break', 'continue', 'let', 'const', 'unlet', 'lockvar', 'unlockvar', 'echo', 'echon', 'echohl', 'echomsg', 'echoerr', 'execute', 'eval', 'call', 'normal', 'silent', 'redir', 'redraw', 'redrawstatus', 'sleep', 'source', 'runtime', 'finish', 'quit', 'quitall', 'wq', 'write', 'wall', 'read', 'edit', 'enew', 'find', 'sfind', 'tabfind', 'split', 'vsplit', 'new', 'vnew', 'tabnew', 'close', 'only', 'hide', 'buffer', 'bnext', 'bprev', 'bfirst', 'blast', 'badd', 'bdelete', 'bunload', 'tab', 'tabnext', 'tabprev', 'tabfirst', 'tablast', 'tabclose', 'tabonly', 'set', 'setlocal', 'setglobal', 'exists', 'has', 'type', 'len', 'empty', 'string', 'str2nr', 'str2float', 'printf', 'substitute', 'submatch', 'search', 'searchpos', 'match', 'matchadd', 'matchdelete', 'matchlist', 'matchstr', 'split', 'join', 'reverse', 'sort', 'uniq', 'filter', 'map', 'extend', 'add', 'insert', 'remove', 'count', 'index', 'max', 'min', 'abs', 'round', 'floor', 'ceil', 'line', 'col', 'virtcol', 'indent', 'lnum', 'getline', 'setline', 'append', 'cursor', 'getpos', 'setpos', 'getcurpos', 'expand', 'fnamemodify', 'resolve', 'simplify', 'pathshorten', 'glob', 'globpath', 'file_readable', 'filereadable', 'filewritable', 'isdirectory', 'delete', 'rename', 'mkdir', 'system', 'shellescape'],
    \ 'sh': ['if', 'then', 'else', 'elif', 'fi', 'case', 'esac', 'for', 'while', 'until', 'do', 'done', 'break', 'continue', 'function', 'return', 'exit', 'local', 'readonly', 'declare', 'typeset', 'export', 'unset', 'shift', 'set', 'test', 'true', 'false', 'echo', 'printf', 'read', 'exec', 'eval', 'source', 'cd', 'pwd', 'ls', 'cp', 'mv', 'rm', 'mkdir', 'rmdir', 'touch', 'find', 'grep', 'sed', 'awk', 'cut', 'sort', 'uniq', 'head', 'tail', 'cat', 'more', 'less', 'wc', 'tr', 'tee', 'xargs', 'which', 'whereis', 'type', 'alias', 'unalias', 'history', 'jobs', 'bg', 'fg', 'nohup', 'sleep', 'wait', 'kill', 'killall', 'ps', 'top', 'htop', 'df', 'du', 'free', 'mount', 'umount', 'chmod', 'chown', 'chgrp', 'su', 'sudo', 'passwd', 'id', 'whoami', 'who', 'w', 'last', 'date', 'cal', 'uptime', 'uname', 'hostname', 'ping', 'wget', 'curl', 'ssh', 'scp', 'rsync', 'tar', 'gzip', 'gunzip', 'zip', 'unzip'],
    \ 'bash': ['if', 'then', 'else', 'elif', 'fi', 'case', 'esac', 'for', 'while', 'until', 'do', 'done', 'break', 'continue', 'function', 'return', 'exit', 'local', 'readonly', 'declare', 'typeset', 'export', 'unset', 'shift', 'set', 'test', 'true', 'false', 'echo', 'printf', 'read', 'exec', 'eval', 'source', 'select', 'time', 'coproc', 'mapfile', 'readarray', 'compgen', 'complete', 'compopt', 'caller', 'command', 'builtin', 'enable', 'help', 'let', 'logout', 'popd', 'pushd', 'dirs', 'shopt', 'suspend', 'times', 'trap', 'ulimit', 'umask', 'bind', 'hash', 'getopts'],
    \ 'zsh': ['if', 'then', 'else', 'elif', 'fi', 'case', 'esac', 'for', 'while', 'until', 'do', 'done', 'break', 'continue', 'function', 'return', 'exit', 'local', 'readonly', 'declare', 'typeset', 'export', 'unset', 'shift', 'set', 'test', 'true', 'false', 'echo', 'printf', 'read', 'exec', 'eval', 'source', 'autoload', 'bindkey', 'compdef', 'zstyle', 'zmodload', 'zmv', 'select', 'repeat', 'always', 'nocorrect', 'noglob', 'alias', 'unalias', 'which', 'whence', 'where', 'rehash', 'hash', 'unhash', 'cd', 'pushd', 'popd', 'dirs'],
    \ 'make': ['all', 'clean', 'install', 'uninstall', 'distclean', 'check', 'test', 'dist', 'distcheck', 'PHONY', 'SUFFIXES', 'PRECIOUS', 'INTERMEDIATE', 'SECONDARY', 'DELETE_ON_ERROR', 'SILENT', 'EXPORT_ALL_VARIABLES', 'CC', 'CXX', 'CFLAGS', 'CXXFLAGS', 'CPPFLAGS', 'LDFLAGS', 'LDLIBS', 'AR', 'ARFLAGS', 'AS', 'ASFLAGS', 'CPP', 'FC', 'FFLAGS', 'LEX', 'LFLAGS', 'YACC', 'YFLAGS', 'RM', 'ifdef', 'ifndef', 'ifeq', 'ifneq', 'else', 'endif', 'include', 'sinclude', 'override', 'export', 'unexport', 'vpath', 'VPATH', 'define', 'endef', 'undefine', 'origin', 'flavor', 'foreach', 'call', 'value', 'eval', 'file', 'error', 'warning', 'info', 'shell', 'strip', 'findstring', 'filter', 'filter-out', 'sort', 'word', 'wordlist', 'words', 'firstword', 'lastword', 'dir', 'notdir', 'suffix', 'basename', 'addsuffix', 'addprefix', 'join', 'wildcard', 'realpath', 'abspath', 'if', 'or', 'and', 'subst', 'patsubst']
    \ }

let s:ignored_filetypes = ['text', 'txt', 'markdown', 'md', 'rst', 'asciidoc', 'tex', 'latex', 'log', 'conf', 'config', 'ini', 'csv', 'tsv', 'json', 'xml', 'html', 'css', 'yaml', 'yml', 'toml', 'gitcommit', 'gitrebase', 'diff', 'help', 'man', 'qf', 'netrw', 'nerdtree']

let s:header_mappings = {'h': 'c', 'hpp': 'cpp', 'hxx': 'cpp', 'hh': 'cpp', 'H': 'cpp'}

let s:universal_ignore = ['a', 'an', 'the', 'is', 'are', 'was', 'were', 'be', 'been', 'have', 'has', 'had', 'do', 'does', 'did', 'will', 'would', 'could', 'should', 'may', 'might', 'can', 'must', 'shall', 'to', 'of', 'in', 'on', 'at', 'by', 'for', 'with', 'from', 'up', 'out', 'off', 'over', 'under', 'again', 'further', 'then', 'once', 'here', 'there', 'when', 'where', 'why', 'how', 'all', 'any', 'both', 'each', 'few', 'more', 'most', 'other', 'some', 'such', 'no', 'nor', 'not', 'only', 'own', 'same', 'so', 'than', 'too', 'very', 's', 't', 'just', 'now']

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

function! s:IsInComment()
    let synstack = synstack(line('.'), col('.'))
    if empty(synstack)
        return 0
    endif
    for syn_id in synstack
        let syn_name = synIDattr(syn_id, 'name')
        if syn_name =~? 'comment\|todo\|fixme\|note\|hack\|xxx'
            return 1
        endif
    endfor
    return 0
endfunction

function! s:IsIgnoredWord(word)
    let word_lower = tolower(a:word)
    
    if index(s:ignored_filetypes, &filetype) >= 0
        return 1
    endif
    
    if a:word =~ '^\d\+$'
        return 1
    endif
    
    if len(a:word) == 1 && a:word !~ '[ijklmnxyzabcdefghpqrstuv]'
        return 1
    endif
    
    if index(s:universal_ignore, word_lower) >= 0
        return 1
    endif
    
    let effective_ft = &filetype
    let extension = expand('%:e')
    if has_key(s:header_mappings, extension)
        let effective_ft = s:header_mappings[extension]
    endif
    
    if has_key(s:keywords, effective_ft)
        if index(s:keywords[effective_ft], word_lower) >= 0
            return 1
        endif
    endif
    
    if &filetype == 'make' || expand('%:t') =~? 'makefile\|\.mk$'
        if has_key(s:keywords, 'make')
            if index(s:keywords['make'], word_lower) >= 0
                return 1
            endif
        endif
    endif
    
    if len(a:word) <= 4 && a:word =~ '^[A-Z]\+$'
        return 1
    endif
    
    if a:word =~ '^\(TODO\|FIXME\|NOTE\|HACK\|XXX\|BUG\|WARNING\|ERROR\|INFO\|DEBUG\)$'
        return 1
    endif
    
    if a:word =~ '^\(define\|undef\|ifdef\|ifndef\|endif\|pragma\|include\)$'
        return 1
    endif
    
    return 0
endfunction

function! s:GetWordUnderCursor()
    if s:IsInComment()
        return ''
    endif
    
    let word = expand('<cword>')
    if len(word) < g:live_refs_min_word_len || word !~ '\w'
        return ''
    endif
    
    let line = getline('.')
    let col = col('.') - 1
    
    let word_start = match(line, '\<' . escape(word, '\/.*$^~[]') . '\>', col)
    if word_start == -1
        let word_start = match(line, '\<' . escape(word, '\/.*$^~[]') . '\>')
        while word_start != -1 && word_start <= col
            let word_end = word_start + len(word) - 1
            if col >= word_start && col <= word_end
                break
            endif
            let word_start = match(line, '\<' . escape(word, '\/.*$^~[]') . '\>', word_start + 1)
        endwhile
    endif
    
    if word_start != -1
        let word_end = word_start + len(word) - 1
        if col < word_start || col > word_end
            return ''
        endif
    else
        return ''
    endif
    
    if s:IsIgnoredWord(word)
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
    call popup_setoptions(s:popup_id, {'filter': function('s:PopupFilter', [a:results])})
endfunction

function! s:PopupFilter(results, id, key)
    if mode() != 'n'
        return 0
    endif
    
    if a:key == "\<Esc>" || a:key == ';'
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
