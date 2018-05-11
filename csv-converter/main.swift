#!/usr/bin/env swift

import Foundation

struct YNABRow {
    let date: String
    let payee: String
    let memo: String
    let outflow: String
    let inflow: String
    
    func toString() -> String {
        return [date, payee, memo, outflow, inflow].joined(separator: ",") + "\n"
    }
}


guard CommandLine.arguments.count == 3 else {
    print("Please provide source and destination paths")
    exit(0)
}

let sourceFilePath = CommandLine.arguments[1]
let destinationFilePath = CommandLine.arguments[2]

guard FileManager.default.fileExists(atPath: sourceFilePath) else {
    print("Cannot find file at path: \(sourceFilePath)")
    exit(0)
}

do {
    let csvData = try String(contentsOfFile: sourceFilePath, encoding: .utf8).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    let rows = csvData.components(separatedBy: "\n")
    
    var result = ["Date,Payee,Memo,Outflow,Inflow"]
    
    for i in 1..<rows.count {
        let row = rows[i]
        let rowComps: [String] = row.components(separatedBy: ",")
    
        let dateComp = rowComps.first!
        let dateEndIndex = dateComp.index(dateComp.startIndex, offsetBy: 9)
        let date = dateComp[...dateEndIndex]

        let ynabRow = YNABRow(date: String(date), payee: "", memo: rowComps[4], outflow: rowComps[5], inflow: rowComps[6])
        result.append(ynabRow.toString())
    }
    
    let data = result.joined(separator: "\n").data(using: .utf8)
    
    let success = FileManager.default.createFile(atPath: destinationFilePath, contents: data, attributes: nil)
    
    if success {
        print("Finished!")
    } else {
        print("Failed to create file")
        exit(0)
    }
 
} catch {
    print("Failed to parse file: \(error)")
    exit(0)
}



