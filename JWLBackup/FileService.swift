//
//  FileService.swift
//  JWLBackup
//
//  Created by Manuel De Freitas on 6/24/22.
//

import Foundation
import SQLite
import SwiftUI
import ZIPFoundation
import RealmSwift


class FileService {
    var fileManager = FileManager()
    let decoder = JSONDecoder()
    let databaseFileName = "user_data.db"
    let manifestFileName = "manifest.json"
    
    func clean(at urls: [URL]) throws {
        for url in urls {
            if fileManager.fileExists(atPath: url.path) {
                try fileManager.removeItem(at: url)
            }
        }
    }
    
    func moveFiles(from urls: [URL], to destination: URL) throws {
        for url in urls {
            if fileManager.fileExists(atPath: url.path) {
                if let pathComponent = url.pathComponents.last {
                    try fileManager.moveItem(at: url, to: destination.appendingPathComponent(pathComponent))
                }
            }
        }
    }
    
    func createManifest(from _manifest: ManifestFile) throws {
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
    }
    
    func upload(from url: URL) throws -> ManifestFile? {

        
        if let documentDirectory = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let tempDirectoryURL = documentDirectory.appendingPathComponent("tmp", isDirectory: true)
            
            let tempManifestFile = tempDirectoryURL.appendingPathComponent(manifestFileName)
            let tempDatabaseFile = tempDirectoryURL.appendingPathComponent(databaseFileName)
            
            try self.clean(at: [tempManifestFile, tempDatabaseFile])
            
            try fileManager.unzipItem(at: url, to: tempDirectoryURL)
            
            let data = try Data(contentsOf: URL(fileURLWithPath: tempManifestFile.path), options: .mappedIfSafe)
            
            let _manifest: ManifestFile = try decoder.decode(ManifestFile.self, from: data)

            let destinationDirectoryNameUrl = documentDirectory.appendingPathComponent(_manifest.name)
            try fileManager.createDirectory(at: destinationDirectoryNameUrl, withIntermediateDirectories: true)
            
            try self.moveFiles(from: [tempManifestFile, tempDatabaseFile], to: destinationDirectoryNameUrl)
            return _manifest
           // try self.createManifest(from: _manifest)
        }
        return nil
    }
    
    
    func removePTNotes(for url: URL) throws {
        
        let fileManager = FileManager()
        if let currentWorkingPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
         
            let destinationURL = URL(fileURLWithPath: currentWorkingPath.path)
            let databaseFileName = "user_data.db"
            let manifestFileName = "manifest.json"
            let databaseURL = destinationURL.appendingPathComponent(databaseFileName)
            let manifestURL = destinationURL.appendingPathComponent(manifestFileName)
            
            if fileManager.fileExists(atPath: databaseURL.path) {
                try fileManager.removeItem(at: databaseURL)
            }
            
            if fileManager.fileExists(atPath: manifestURL.path) {
                try fileManager.removeItem(at: manifestURL)
            }
            try fileManager.unzipItem(at: url, to: destinationURL)
        }
    }
    
    func readDB(url: URL) {
        do {
            try removePTNotes(for: url)
        } catch {
            print(error)
        }
    }
}
