function! airline#extensions#weather#init(ext)
  call a:ext.add_statusline_funcref(function('airline#extensions#weather#apply'))
endfunction

function! airline#extensions#weather#apply(...)
  let w:airline_section_z = get(w:, 'airline_section_z', g:airline_section_z)
  let w:airline_section_z .= '%{weather#get()}'
endfunction
