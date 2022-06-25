//
//  PublicationList.swift
//  JWLBackup
//
//  Created by Manuel De Freitas on 6/24/22.
//

import SwiftUI
import RealmSwift


struct PublicationList: View {
    private let fileService: FileService = FileService()
    private let dbService: DBService = DBService()
    @ObservedRealmObject var localManifestFile: LocalManifestFile
    @State var notes: [Note] = []
    @State var locations: [Location] = []
    var body: some View {
        List {
            ForEach(notes, id: \.noteId) { note in
                Text(note.content ?? "")
            }
            ForEach(locations, id: \.locationId) { location in
                Text(location.keySymbol ?? "")
            }
        }
            .onAppear {
                do {
                    let connection = try dbService.getUserDataDB(from: self.localManifestFile)
                     guard let connection = connection else {
                         return
                     }
                    Task {
//                        self.notes = try dbService.fetch(from: connection, for: .note) ?? []
                        self.locations = try dbService.fetch(from: connection, for: .location) ?? []
                    }
                } catch {
                    print(error)
                }

            }
    }
}
