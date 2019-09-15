//
//  NetworkHelpers.swift
//  YNotes
//
//  Created by Dzhek on 12/08/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import Foundation

//MARK: - • Objects for convert

struct Gist: Codable {
    let description: String
    let files: [String : File]
}

struct File: Codable {
    let content: String
}

struct JSONote: Codable {
    let uid: String
    let title: String
    let content: String
    let color: String
    let importance: String
    let selfDestructionDate: Date?
    let lastEditedDate: Date
}

//MARK: - • Methods

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

//MARK: - • Objects 

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    
}

struct EndPoint {
    let baseURL = "https://api.github.com"
    let notebook = "/gists"
    let authorizations = "/authorizations"
    static var gistId =  ""
}

struct Services {
    static var token = ""
    static var tokenID = 0
    static var username = ""
    static var password = ""
    static let fileName = "ios-course-notes-db"
    static let descriptionToken = "token MyYnotes"
}

struct AuthData: Decodable {
    let token: String
    let tokenID: Int  // TODO: будет использован для удаления токена 
    
    enum CodingKeys: String, CodingKey {
        case token
        case tokenID = "id"
    }
}
