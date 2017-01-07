//
//  Parser.swift
//  LinkMapParser
//
//  Created by mengxiangjian on 2017/1/7.
//  Copyright © 2017年 mengxiangjian. All rights reserved.
//

import Foundation

enum ParseSection {
    case none
    case file
    case section
    case symbol
}

class File {
    var name = ""
    var size = 0
}

class Lib {
    var name = ""
    var size = 0
}

class Parser {
    
    var parseSection = ParseSection.none
    var fileDict = [String:File]();
    
    func reset() {
        fileDict = [String:File]();
    }
    
    /// start parse
    ///
    /// - Parameter filePath: linkmap file path
    func parseStart(filePath : String, isLibstat: Bool) {
        self.reset()
        let streamReader = StreamReader(path: filePath)
        while let line = streamReader?.nextLine() {
            if line.hasPrefix("#") {
                if line.contains("Object files") {
                    parseSection = .file;
                } else if line.contains("Sections") {
                    parseSection = .section;
                } else if line.contains("Symbols") {
                    parseSection = .symbol;
                }
                continue
            }
            
            switch parseSection {
            case .file:
                self.parseFiles(line: line)
                break
            case .section:
                self.parseSections(line: line)
                break
            case .symbol:
                self.parseSymbols(line: line)
                break;
            default:
                break
            }
        }
        
        if isLibstat {
            // lib stastic
            self.logLibStat()
        } else {
            // file stastic
            self.logFileStat()
        }
    }
    
    func parseFiles(line:String) {
        let components = line.components(separatedBy: "]")
        if components.count > 1 {
            let index = components[0].replacingOccurrences(of: "[", with: "").replacingOccurrences(of: " ", with: "")
            let nameArray = components[1].components(separatedBy: "/")
            if nameArray.count > 1 {
                let name = nameArray[nameArray.count - 1]
                let file = File()
                file.name = name
                fileDict[index] = file
            }
        }
    }
    
    func parseSections(line:String) {
    }
    
    func parseSymbols(line:String) {
        let component = line.components(separatedBy: "\t")
        if component.count > 2 {
            let index = component[2].components(separatedBy: "]")[0].replacingOccurrences(of: "[", with: "").replacingOccurrences(of: " ", with: "")
            let file = fileDict[index]
            if let file = file {
                let hexString = component[1]
                let size = self.hex2dec(num: hexString)
                file.size += size
            }
        }
    }
    
    func logFileStat() {
        var fileArray = [File]()
        for key in fileDict.keys {
            let file = fileDict[key]! as File
            fileArray.append(file)
        }
        
        fileArray.sort { (aFile, bFile) -> Bool in
            return (aFile.size > bFile.size)
        }
        
        for file in fileArray {
            print("filename: \(file.name)  size: \(self.format(size: file.size))")
        }
    }
    
    func logLibStat() {
        var libDict = [String:Lib]()
        for key in fileDict.keys {
            let file = fileDict[key]!
            var name = file.name
            if file.name.contains(".o)") ||
                file.name.contains(".obj)") {
                let components = file.name.components(separatedBy: "(")
                if components.count > 1 {
                    name = components[0]
                }
            }
            let lib = libDict[name]
            if let lib = lib {
                lib.size += file.size
            } else {
                let newLib = Lib()
                newLib.name = name
                newLib.size = file.size
                libDict[name] = newLib
            }
        }
        
        var libArray = [Lib]()
        for key in libDict.keys {
            let lib = libDict[key]! as Lib
            libArray.append(lib)
        }
        
        libArray.sort { (aLib, bLib) -> Bool in
            return aLib.size > bLib.size
        }
        
        for lib in libArray {
            print("\(lib.name)  size: \(self.format(size: lib.size))")
        }
    }
    
    func format(size:Int) -> String {
        var finalSize = Float(size)
        if size > 1024 * 1024 {
            finalSize = Float(size) / Float(1024.0) / Float(1024.0)
            let string = String(format: "%.2f", finalSize)
            return "\(string) MB"
        } else if size > 1024 {
            finalSize = Float(size) / Float(1024.0)
            let string = String(format: "%.2f", finalSize)
            return "\(string) KB"
        }
        let string = String(format: "%.0f", finalSize)
        return "\(string) B"
    }
    
    func hex2dec(num:String) -> Int {
        let str = num.uppercased()
        var sum = 0
        for i in str.utf8 {
            if i > 70 {
                continue
            }
            sum = sum * 16 + Int(i) - 48 // 0-9 从48开始
            if i >= 65 {                 // A-Z 从65开始，但有初始值10，所以应该是减去55
                sum -= 7
            }
        }
        return sum
    }
}
