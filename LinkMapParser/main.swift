//
//  main.swift
//  LinkMapParser
//
//  Created by mengxiangjian on 2017/1/6.
//  Copyright © 2017年 mengxiangjian. All rights reserved.
//

import Foundation

var filePath : String?
var isLibstat = false

for (i, argument) in CommandLine.arguments.enumerated() {
    if i == 1 {
        filePath = argument
    } else if i == 2 {
        if argument.contains("l") {
            isLibstat = true
        }
    }
}

if let filePath = filePath {
    if FileManager.default.fileExists(atPath: filePath) {
        let parser = Parser();
        parser.parseStart(filePath: filePath,isLibstat: isLibstat)
    } else {
        print("file is not exist")
    }
} else {
    print("usage : LinkMapParser filepath \n -l: libStat")
}

