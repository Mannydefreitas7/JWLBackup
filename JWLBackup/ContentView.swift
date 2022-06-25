//
//  ContentView.swift
//  JWLBackup
//
//  Created by Manuel De Freitas on 6/23/22.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    @State private var showImporter = false
//    @State var notes: [Note] = [Note]()
//    @State var locations: [Location] = [Location]()
//    @State var publications: Dictionary<String?, [Location]> = Dictionary<String?, [Location]>()
    private let fileService: FileService = FileService()
    private let dbService: DBService = DBService()
    @ObservedResults(LocalManifestFile.self) var localManifestFiles
  
    var body: some View {
        NavigationView {
            List {
                ForEach(localManifestFiles, id: \.hash) { file in
                    NavigationLink {
                        PublicationList(localManifestFile: file)
                    } label: {
                        Text(file.name ?? "")
                    }
                }
            }
            .listStyle(.sidebar)
            
            VStack {
                Button {
                    showImporter.toggle()
                } label: {
                    Text("Import File")
                }
            }
            
        }
        .toolbar(content: {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    showImporter.toggle()
                } label: {
                    Text("Import File")
                }
            }
        })
        .frame(minWidth: 600, minHeight: 300)
        .fileImporter(isPresented: $showImporter, allowedContentTypes: [.fileURL, .database, .jwlibrary], onCompletion: { result in
            do {
                let url = try result.get()
                let manifest = try fileService.upload(from: url)
                if let manifest = manifest {
                   let localManifest = try dbService.createManifest(from: manifest)
                }
            } catch {
                print(error)
            }
        })
    }
}

