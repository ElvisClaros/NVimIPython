if exists("g:loaded_NVimIPython")
	finish
endif
let g:loaded_NVimIPython = 1

command! -nargs=0 IPython call NVimIPython#IPythonRun()
