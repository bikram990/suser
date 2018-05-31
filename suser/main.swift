//
//  main.swift
//  suser
//
//  Created by Joel Rennich on 5/31/18.
//  Copyright © 2018 Orchard & Grove Inc. All rights reserved.
//

import Foundation
import SystemConfiguration

// quick tool to launch a tool as the current console user

// get all the args, and slice out the suser ones

var suserArgs = [String]()
var commandArgs = [String]()

var split = false
for i in 0...(CommandLine.arguments.count - 1) {
    
    // skip the first arg, as it's the path to the binary
    
    if i == 0 {
        continue
    }
    
    if CommandLine.arguments[i].starts(with: "-") && !split {
        suserArgs.append(CommandLine.arguments[i])
    } else {
        split = true
        commandArgs.append(CommandLine.arguments[i])
    }
}

if suserArgs.contains("-h") {
    print("""
suser - a handy way to get the current user and run something as that user.
    suser needs to be run as root and will query SCDynamicStore for the current
    console user and run any arguments to suser as the console user.

    If the current console user has a uid of < 500, suser will quit. If the user
    running suser is not root, suser will quit.

    suser will echo the result of the command to standard out.

options:
    -h this help statement
    -i ignore if current console user is < uid 500
    -s do not print anything to standard out
    -r ignore if the executing user is root or not

Version: 1.0
""")
}

// check for root

if NSUserName() != "root" {
    if !suserArgs.contains("-s") {
        print("Not running as root, quitting.")
    }
    exit(1)
}

// get current console user

var uid = uid_t.init(0)

let consoleUser = SCDynamicStoreCopyConsoleUser(nil, &uid, nil)

if uid < 500 && !suserArgs.contains("-i") {
    if !suserArgs.contains("-s") {
        print("Not a normal user")
    }
    exit(1)
}

// switch to the console user

seteuid(uid)

// run the command

let result = cliTask(commandArgs.joined(separator: " "))

if !suserArgs.contains("-s") {
    print("Result: \(result)")
}
