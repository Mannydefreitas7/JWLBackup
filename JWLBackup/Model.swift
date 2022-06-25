//
//  Note.swift
//  JWLBackup
//
//  Created by Manuel De Freitas on 6/23/22.
//

import Foundation
import RealmSwift

struct Related: Decodable {
    let blockRange: [BlockRange]?
    let location: Location?
    let publicationLocation: Location?
    let note: Note?
    let userMark: UserMark?
}

enum BackupModel: String {
    func getType<T: Decodable>() -> T.Type {
        switch self {
        case .blockRange: return BlockRange.self as! T.Type
        case .userMark: return UserMark.self as! T.Type
        case .note: return Note.self as! T.Type
        case .bookMark: return Bookmark.self as! T.Type
        case .inputField: return InputField.self as! T.Type
        case .location: return Location.self as! T.Type
        }
    }

    case blockRange = "BlockRange"
    case userMark = "UserMark"
    case note = "Note"
    case bookMark = "BookMark"
    case inputField = "InputField"
    case location = "Location"
}

struct BlockRange: Decodable {
    let blockRangeId: Int?
    let blockType: Int?
    let identifier: Int?
    let startToken: Int?
    let endToken: Int?
    let userMarkId: Int
    
    enum CodingKeys: String, CodingKey {
        case blockRangeId = "BlockRangeId"
        case blockType = "BlockType"
        case identifier = "Identifier"
        case startToken = "StartToken"
        case endToken = "EndToken"
        case userMarkId = "UserMarkId"
    }
}

struct Bookmark: Decodable {
    let bookmarkId: Int?
    let locationId: Int?
    let publicationLocationId: Int?
    let slot: Int?
    let title: String?
    let snippet: String?
    let blockType: Int?
    let blockIdentifier: Int?
    
    enum CodingKeys: String, CodingKey {
        case bookmarkId = "BookmarkId"
        case locationId = "LocationId"
        case publicationLocationId = "PublicationLocationId"
        case slot = "Slot"
        case title = "Title"
        case snippet = "Snippet"
        case blockType = "BlockType"
        case blockIdentifier = "BlockIdentifier"
    }
}

struct InputField: Decodable {
    let locationId: Int?
    let textTag: String?
    let value: String?
    
    enum CodingKeys: String, CodingKey {
        case locationId = "LocationId"
        case textTag = "TextTag"
        case value = "Value"
    }
}

struct Location: Decodable {
    let locationId: Int?
    let bookNumber: Int?
    let chapterNumber: Int?
    let documentId: Int?
    let track: Int?
    let issueTagNumber: Int?
    let keySymbol: String?
    let mepsLanguage: Int?
    let locationType: Int?
    let title: String?
    
    enum CodingKeys: String, CodingKey {
        case locationId = "LocationId"
        case bookNumber = "BookNumber"
        case chapterNumber = "ChapterNumber"
        case documentId = "DocumentId"
        case track = "Track"
        case issueTagNumber = "IssueTagNumber"
        case keySymbol = "KeySymbol"
        case mepsLanguage = "MepsLanguage"
        case locationType = "LocationType"
        case title = "Title"
    }
}

struct Note: Codable {
    let noteId: Int?
    let guid: String?
    let userMarkId: Int?
    let locationId: Int?
    let title: String?
    let content: String?
    let lastModified: String?
    let blockType: Int?
    let blockIdentifier: Int?
    
    enum CodingKeys: String, CodingKey {
        case noteId = "NoteId"
        case guid = "Guid"
        case userMarkId = "UserMarkId"
        case locationId = "LocationId"
        case title = "Title"
        case content = "Content"
        case lastModified = "LastModified"
        case blockType = "BlockType"
        case blockIdentifier = "BlockIdentifier"
    }
}

struct Tag: Decodable {
    let tagId: Int?
    let tagType: Int?
    let name: String?
    let imageFilename: String?
    
    enum CodingKeys: String, CodingKey {
        case tagId = "TagId"
        case tagType = "TagType"
        case name = "Name"
        case imageFilename = "ImageFilename"
    }
}

struct TagMap: Decodable {
    let tagMapId: Int?
    let playlistItemId: Int?
    let locationId: Int?
    let noteId: Int?
    let tagId: Int?
    let position: Int?
    
    enum CodingKeys: String, CodingKey {
        case tagMapId = "TagMapId"
        case playlistItemId = "PlaylistItemId"
        case locationId = "LocationId"
        case noteId = "NoteId"
        case tagId = "TagId"
        case position = "Position"
    }
}

struct UserMark: Decodable {
    let userMarkId: Int?
    let colorIndex: Int?
    let locationId: Int?
    let styleIndex: Int?
    let userMarkGuid: String?
    let version: Int?
    
    enum CodingKeys: String, CodingKey {
        case userMarkId = "UserMarkId"
        case colorIndex = "ColorIndex"
        case locationId = "LocationId"
        case styleIndex = "StyleIndex"
        case userMarkGuid = "UserMarkGuid"
        case version = "Version"
    }
}

struct UserMarkBlockRange: Decodable {
    let userMark: UserMark?
    let blockRanges: [BlockRange]?
    
    enum CodingKeys: String, CodingKey {
        case userMark = "UserMark"
        case blockRanges = "BlockRanges"
    }
}

struct ManifestFile: Decodable {
    let creationDate: String
    let userDataBackup: UserDataBackup
    let name: String
    let type: Int
    let version: Int
}

class LocalManifestFile: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var owner: String?
    @Persisted var creationDate: String?
    @Persisted var userDataBackup: LocalUserDataBackup?
    @Persisted var name: String?
    @Persisted var type: Int?
    @Persisted var version: Int?
}

class LocalUserDataBackup: Object {
    @Persisted var lastModifiedDate: String?
    @Persisted var hashData: String?
    @Persisted var databaseName: String?
    @Persisted var schemaVersion: Int?
    @Persisted var deviceName: String?
}

struct UserDataBackup: Decodable {
    let lastModifiedDate: String
    let hash: String
    let databaseName: String
    let schemaVersion: Int
    let deviceName: String
}
