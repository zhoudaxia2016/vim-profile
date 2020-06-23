function popup#menu(options)
  let texts = []
  let actions = []
  for _ in a:options
    call add(texts, _.text)
    if type(_.action) == v:t_string
      call add(actions, {-> execute(_.action)})
    else
      call add(actions, _.action)
    endif
  endfor
  call popup_menu(texts, #{border: [0, 0, 0, 0], padding: [0, 0, 0, 0], callback: function('s:popup_menu_callback', [actions])})
endfunc

function s:popup_menu_callback(actions, id, n)
  call a:actions[a:n - 1]()
endfunc
