//
//  TAUrlSession.swift
//  TubeArchivistKit
//
//  Created by Zachary Reyes on 7/10/25.
//

import Foundation

func TAURLSession(apiToken: String) -> URLSession {
    // This is needed because the "Authorization" header in the default URLSession is reserved
    let config = URLSessionConfiguration.default
    config.httpAdditionalHeaders = [
        "Authorization": "Token \(apiToken)"
    ]
    return URLSession(configuration: config)
}
