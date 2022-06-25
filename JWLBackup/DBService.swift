//
//  DBService.swift
//  JWLBackup
//
//  Created by Manuel De Freitas on 6/24/22.
//

import Foundation
import RealmSwift
import SQLite

class DBService {
    let locationsTable = Table("Location")
    let notesTable = Table("Note")
    let userMarkTable = Table("UserMark")
    let blockRangeTable = Table("BlockRange")
    
    
    
    let blockRangeIdKey = Expression<Int>("BlockRangeId")
    let locationIdKey = Expression<Int>("LocationId")
    let userMarkIdKey = Expression<Int>("UserMarkId")
    let userMarkGuid = Expression<Int>("UserMarkGuid")
    let colorIndex = Expression<Int>("ColorIndex")
    let keySymbol = Expression<String>("KeySymbol")
    let title = Expression<String>("Title")
    
    var fileManager = FileManager()
    let decoder = JSONDecoder()
    let databaseFileName = "user_data.db"
    let manifestFileName = "manifest.json"
    
    func createManifest(from _manifest: ManifestFile) throws -> LocalManifestFile {
        let localRealm = try! Realm()
        let localBackupManifest = LocalManifestFile()
        let localUserData = LocalUserDataBackup()
        
        localUserData.databaseName = _manifest.userDataBackup.databaseName
        localUserData.hashData = _manifest.userDataBackup.hash
        localUserData.deviceName = _manifest.userDataBackup.deviceName
        
        localBackupManifest.name = _manifest.name
        localBackupManifest.creationDate = _manifest.creationDate
        localBackupManifest.userDataBackup = localUserData
        try localRealm.write {
            localRealm.add(localUserData)
            localRealm.add(localBackupManifest)
        }
        return localBackupManifest
    }
    
    func readManifest(from manifest: LocalManifestFile) throws -> LocalManifestFile? {
        let localRealm = try! Realm()
        let manifests = localRealm.objects(LocalManifestFile.self)
        let localManifestFile = manifests.where {
            $0.name == manifest.name
        }
        if !localManifestFile.isEmpty {
            return localManifestFile.first
        }
        return nil
    }
    
    func getUserDataDB(from manifest: LocalManifestFile) throws -> Connection? {
        if let documentDirectory = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first, let directory = manifest.name {
            let destinationDirectoryNameUrl = documentDirectory.appendingPathComponent(directory, isDirectory: true).appendingPathComponent(databaseFileName)
            print(destinationDirectoryNameUrl)
            let db = try Connection(destinationDirectoryNameUrl.path)
            return db
        }
        return nil
    }
    
//    func getPublications(from db: Connection) throws -> Dictionary<String?, [Related]> {
//        let _locations: [Location] = try db.prepare(locationsTable).map { try $0.decode() }
//        let groupingDictionary = Dictionary(grouping: _locations, by: { $0.keySymbol })
//
//
//        groupingDictionary.map { (symbol, locations) in
//
//            let blockRange = blockRangeTable.filter(<#T##predicate: Expression<Bool?>##Expression<Bool?>#>)
//        }
//        return groupingDictionary
//    }
    
    
    
    func fetch<T: Decodable>(from db: Connection, for table: BackupModel) throws -> [T]? {
        let query = Table(table.rawValue)
        switch table {
        case .blockRange:
            let results: [BlockRange]? = try db.prepare(query).map { try $0.decode() }
            return results as? [T]
            case .userMark:
            let results: [UserMark]? = try db.prepare(query).map { try $0.decode() }
            return results as? [T]
            case .note:
            let results: [Note]? = try db.prepare(query).map { try $0.decode() }
            return results as? [T]
            case .bookMark:
            let results: [Bookmark]? = try db.prepare(query).map { try $0.decode() }
            return results as? [T]
            case .inputField:
            let results: [InputField]? = try db.prepare(query).map { try $0.decode() }
            return results as? [T]
            case .location:
            let results: [Location]? = try db.prepare(query).map { try $0.decode() }
            return results as? [T]
            }
    }

}
