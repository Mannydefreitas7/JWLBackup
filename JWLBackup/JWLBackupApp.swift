//
//  JWLBackupApp.swift
//  JWLBackup
//
//  Created by Manuel De Freitas on 6/23/22.
//

import SwiftUI

@main
struct JWLBackupApp: App {
    
    @State private var dragOver = false
    @State private var showImporter = false
    
    
//    func unzipBackup(at databaseURL: URL) throws {
//        let locationsTable = Table("Location")
//
//        let db = try Connection(databaseURL.path)
//
//        let _locations: [Location] = try db.prepare(locationsTable).map { try $0.decode() }
//        let groupingDictionary = Dictionary(grouping: _locations, by: { $0.keySymbol })
//
//        self.publications = groupingDictionary
////        self.notes = try db.prepare(notesTable).map { _note in
////           return try _note.decode()
////        }
//
//
//
//
//
////        for location in try db.prepare(locationByPTBook) {
////            if let noteLocationId = location[locationId] {
////                ptLocationIds.append(noteLocationId)
////            }
////        }
//    }
    
//    func removePTNotes(for url: URL) throws {
//
//        let fileManager = FileManager()
//        if let currentWorkingPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
//
//            let destinationURL = URL(fileURLWithPath: currentWorkingPath.path)
//            let databaseFileName = "user_data.db"
//            let manifestFileName = "manifest.json"
//            let databaseURL = destinationURL.appendingPathComponent(databaseFileName)
//            let manifestURL = destinationURL.appendingPathComponent(manifestFileName)
//
//            if fileManager.fileExists(atPath: databaseURL.path) {
//                try fileManager.removeItem(at: databaseURL)
//            }
//
//            if fileManager.fileExists(atPath: manifestURL.path) {
//                try fileManager.removeItem(at: manifestURL)
//            }
//            try fileManager.unzipItem(at: url, to: destinationURL)
//            try unzipBackup(at: databaseURL)
//        }
//    }
    
//    func readDB(url: URL) {
//        do {
//            try removePTNotes(for: url)
//        } catch {
//            print(error)
//        }
//    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
