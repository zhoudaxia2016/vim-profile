" jenkins compiler
let name = 'jenkins'
if (!exists('g:current_compiler'))
  let g:current_compiler = name
else
  if (g:current_compiler == name)
    finish
  else
    let g:current_compiler = name
  endif
endif

let configFile = expand('$HOME/.vim/yamls/jenkins-lint.yaml')
if (!filereadable(configFile))
  finish
endif
let config = utils#readConfig(configFile)
let cmd = 'curl -s --user ' . config.user . ':' . config.password . ' -X POST -F "jenkinsfile=<' . expand('%') . '" http://jenkins.gz.ekwing.com/pipeline-model-converter/validate'

let &l:makeprg = cmd
let &l:errorformat = '%C Errors encountered validating Jenkinsfile:,%+A WorkflowScript: %m \@ line %l%., column %c.,%C%m,%C%p'
