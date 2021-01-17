vim9script
def g:WebdevelopResolvePath(config: dict<any>, rootDir: string): string
  var paths = config.compilerOptions.paths
  var fname = v:fname
  var baseUrl = config.compilerOptions.baseUrl
  baseUrl = substitute(baseUrl, '^\./', rootDir .. '/', '')
  baseUrl = substitute(baseUrl, '^\.$', rootDir .. '/', '')
  for key in paths->keys()
    var targets = paths[key]
    key = substitute(key, '\*', '\\(.*\\)', '')
    if fname =~ key
      for value in targets
        value = substitute(value, '\*', '\\1', '')
        fname = substitute(fname, key, value, '')
        if fname !~ '^\.'
          fname = baseUrl .. fname
        endif
        if file_readable(fname)
          return fname
        endif
      endfor
    endif
  endfor
  return fname
enddef 

export def WebdevelopInit()
  var ft = &filetype
  var configFile = 'jsconfig.json'
  var rootDir = utils#findRoot(configFile)
  if rootDir == null
    configFile = 'tsconfig.json'
    rootDir = utils#findRoot(configFile)
  endif
  if rootDir == null | return | endif
  var config = json_decode(system('cat ' .. rootDir .. '/' .. configFile))
  g:resolve_path_config = config
  g:resolve_rootdir = rootDir
  if ft == 'vue' || ft == 'javascript' || ft == 'typescript'
    set sua+=.js
    set sua+=.vue
    set isfname+=@-@
    set includeexpr=WebdevelopResolvePath(resolve_path_config,resolve_rootdir)
  endif
enddef
