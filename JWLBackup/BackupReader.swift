//
//  BackupReader.swift
//  JWLBackup
//
//  Created by Manuel De Freitas on 6/23/22.
//

import Foundation
import SQLite

class BackupReader {
    
    func openTable(name: String, at path: String) throws {
        
        let db = try Connection(path)
        let table = Table(name)
        
    }
    
}
