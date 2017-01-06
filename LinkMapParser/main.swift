//
//  main.swift
//  LinkMapParser
//
//  Created by mengxiangjian on 2017/1/6.
//  Copyright © 2017年 mengxiangjian. All rights reserved.
//

import Foundation

var filePath : String?

var i = 0
for argument in CommandLine.arguments {
    if i == 1 {
        filePath = argument
    }
    i += 1
}

func parseStart(_ filePath : String) {
    print("file path is : \(filePath)")
}

if let filePath = filePath {
    if FileManager.default.fileExists(atPath: filePath) {
        parseStart(filePath)
    } else {
        print("file is not exist")
    }
} else {
    print("usage : LinkMapParser filepath")
}

