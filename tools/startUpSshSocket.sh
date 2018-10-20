#!/usr/bin/expect

set username [lindex $argv 0]
set password [lindex $argv 1]
set hostname [lindex $argv 2]

spawn ssh -N ${username}@${hostname}
expect "*password"
send "${password}\n"
puts "Ssh socket start up!"
interact
