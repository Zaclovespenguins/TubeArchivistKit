//
//  ErrorHandling.swift
//  TubeArchivistKit
//
//  Created by Zachary Reyes on 7/10/25.
//

import Foundation

public enum TAConnectionError: Error {
    case invalidResponse
    case badData
    case badResponse
    case unableToRetrieveWebAddress
    case unableToRetrievePort
    case unableToRetrieveApiToken
    case unableToAuthenticate
    case badWebAddress
    case badRequest
}

public enum TADatabaseError: Error {
    case channelTableCreationError
    case videoTableCreationError
    case channelInsertionError
    case videoInsertionError
    case channelGetError
}

