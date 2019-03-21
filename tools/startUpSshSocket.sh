#!/usr/bin/expect
set timeout -1
set host [lindex $argv 0]

set home $::env(HOME)
set configfile "${home}/.vim/config"
set fid [open $configfile r]
while {[gets $fid line] >= 0} {
    set key [lindex $line 0]
    set value [lindex $line 1]
    if {$key == "pwfile"} {
      set pwfile $value
      break
    }
}
close $fid

puts $pwfile
set fid [open $pwfile r]
while {[gets $fid line] >= 0} {
    set ip [lindex $line 0]
    set pw [lindex $line 1]
    if {$ip == $host} {
      set password $pw
      break
    }
}
close $fid

spawn ssh $host
expect {
  "*password" {
    send "${password}\n"
  }
  "#" {}
}
puts "Ssh socket start up!"
interact
