//
//  FileType.swift
//  JWLBackup
//
//  Created by Manuel De Freitas on 6/23/22.
//

import Foundation
import UniformTypeIdentifiers
import SwiftUI

extension UTType {
    static var jwlibrary: UTType {
        // Look up the type from the file extension
        UTType.types(tag: "jwlibrary", tagClass: .filenameExtension, conformingTo: nil).first!
    }
}

struct BackupFile: FileDocument {
    static var readableContentTypes = [UTType.jwlibrary]
    var url: URL

    init(url: URL) {
        self.url = url
    }

    init(configuration: ReadConfiguration) {
        url = URL(string: "")!
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let file = try FileWrapper(url: url, options: .immediate)

        return file
    }
}
