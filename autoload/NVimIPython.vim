fun! NVimIPython#IPythonRun()
    " ABOUT: Pythonコンソールウィンドウを作り、編集中のPythonスクリプトを実行する関数
    if &filetype ==# 'python'
        if s:python_exist()
            "" コンソールウィンドウが有ればスクリプトを実行
            let l:script_name = expand('%:p')
            if has_key(s:ipython, 'script_name')
                \&& s:ipython.script_name !=# l:script_name
                call SplitTerm#jobsend_id(s:ipython.info, '%reset')
                call SplitTerm#jobsend_id(s:ipython.info, 'y')
            endif
"            let selected = getreg('"')
			"let line = getline(line("."))
			let line = getline(line("."))
            let s:ipython.script_name = l:script_name
			let s:ipython.selected = line
            call SplitTerm#jobsend_id(s:ipython.info, s:ipython.selected)
        else
            let l:command = 'ipython'
            let l:script_name = expand('%:p')
            if findfile('Pipfile', expand('%:p')) !=# ''
                \ && findfile('Pipfile.lock', expand('%:p')) !=# ''
                let l:command = 'pipenv run ipython'
            endif
            let s:ipython = {}
            let s:ipython.script_name = l:script_name
            let l:script_winid = win_getid()
            call SplitTerm#open(l:command, '--colors=Linux --no-confirm-exit --profile=SplitTerm_$(date -Iseconds)')
            let s:ipython.info = SplitTerm#getinfo()
            silent exe 'normal G'
            call win_gotoid(l:script_winid)
        endif
    endif
endf

fun! s:python_exist() abort
    if exists('s:ipython')
        \&& has_key(s:ipython, 'script_name')
        \&& has_key(s:ipython, 'info')
        "if SplitTerm#exist(s:ipython.info)
            return 1
        "endif
    endif
    return 0
endf
