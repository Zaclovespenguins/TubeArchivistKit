import TubeArchivistKit
import Foundation
import SwiftyJSON
import SQLite

let test_ip: String = "10.9.11.2"
let test_port: String = "8000"
let test_apiToken: String = "86e8a76e0653f9af757f79f110519e82e71203bb"

let TAConnection = TubeArchivistServer(webAddress: test_ip, port: test_port, apiToken: test_apiToken)



//do {
//    let db = try Connection("TAKit.sqlite")
//    
//    // Create channels table
//    let channels = Table("test_channels")
//    let channelId = Expression<String>("channelId")
//    let channelName = Expression<String>("channelName")
//    
//    try db.run(channels.create(ifNotExists: true) { t in
//        t.column(channelId, primaryKey: true)
//        t.column(channelName)
//    })
//    
//    let insertMany = [[channelId <- "Bleh", channelName <- "Bleh The Csfshannel"], [channelId <- "Blorp", channelName <- "Blorp Tsfhe Channel"]]
//    
//    let testInsert = channels.insertMany(insertMany)
//    
//    let rowid = try db.run(channels.insertMany(insertMany))
//    
//    for channel in try db.prepare(channels) {
//        do {
//            let name = try channel.get(channelName)
//            let id = try channel.get(channelId)
//            print("Id: \(id) and name: \(name)")
//        } catch {
//            print(error)
//        }
//    }
//    
//} catch {
//    print("Main DB error: \(error)")
//}

//public struct TAKitChannel: Sendable {
//    var channelId: String
//    var isActive: Bool
//    var isSubbed: Bool
//    var bannerUrl: String
//    var channelDescription: String
//    var name: String
//    var subCount: String
//}

//do {
//    let channels = try await TAConnection.pullAllChannelsServer()
//    try TAConnection.populateChannelTable(channelObjectArryay: channels)
//}
//
//do {
//    let db = try Connection("TAKit.sqlite")
//    
//    // Create channels table
//    let channels = Table("channels")
//    let channelId = Expression<String>("channelId")
//    let isActive = Expression<Bool>("isActive")
//    let isSubbed = Expression<Bool>("isSubbed")
//    let bannerUrl = Expression<String>("bannerUrl")
//    let channelDescription = Expression<String>("channelDescription")
//    let channelName = Expression<String>("channelName")
//    let subCount = Expression<Int64>("subCount")
//    
//    for channel in try db.prepare(channels) {
//        do {
//            let name = try channel.get(channelName)
//            let id = try channel.get(channelId)
//            print("Id: \(id) and name: \(name)")
//        } catch {
//            print(error)
//        }
//    }
//}

do {
    try await TAConnection.populateVideoTable()
}

do {
    let db = try Connection("TAKit.sqlite")
    
    let videos = Table("videos")
    let videoId = Expression<String>("videoId")
    let channelId = Expression<String>("channelId")
    let videoTitle = Expression<String>("videoTitle")
    let videoDescription = Expression<String>("videoDescription")
    let videoUrl = Expression<String>("videoUrl")
    let thumbnailUrl = Expression<String>("thumbnailUrl")
    let hasWatched = Expression<Bool>("hasWatched")
    let watchedDate = Expression<String>("watchedDate")

    for video in try db.prepare(videos) {
        do {
            let name = try video.get(videoTitle)
            let id = try video.get(channelId)
            print("Id: \(id) and name: \(name)")
        } catch {
            print(error)
        }
    }
}



