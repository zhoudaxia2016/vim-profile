function popup#menu(options)
  let texts = []
  let actions = []
  let i = 0
  for _ in a:options
    let i = i + 1
    call add(texts, ' ' . i . '. ' .  _.text . ' ')
    if type(_.action) == v:t_string
      call add(actions, {-> execute(_.action)})
    else
      call add(actions, _.action)
    endif
  endfor
  call popup_menu(texts, #{border: [0, 0, 0, 0], padding: [0, 0, 0, 0], filter: function('s:popup_menu_filter'), callback: function('s:popup_menu_callback', [actions])})
endfunc

function s:popup_menu_callback(actions, id, n)
  if a:n !=  -1
    call a:actions[a:n - 1]()
  endif
endfunc

function s:popup_menu_filter_fn(id, key)
  call popup_close(a:id, a:key)
endfunc

let s:popup_menu_filter_fn_debounce = utils#debounce(function('s:popup_menu_filter_fn'))

function s:popup_menu_filter(id, key)
  if a:key =~ '\d'
    call popup_close(a:id, a:key)
    return 1
  endif
  return popup_filter_menu(a:id, a:key)
endfunc

