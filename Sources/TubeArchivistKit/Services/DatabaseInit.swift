//
//  DatabaseInit.swift
//  TubeArchivistKit
//
//  Created by Zachary Reyes on 7/10/25.
//
import Foundation
import SQLite

extension TubeArchivistServer {
    func initDatabase() throws {
        do {
            let db = try Connection("\(dbPath)/TAKit.sqlite")
            
            // Create channels table
            let channels = Table("channels")
            let channelId = Expression<String>("channelId")
            let isActive = Expression<Bool>("isActive")
            let isSubbed = Expression<Bool>("isSubbed")
            let bannerUrl = Expression<String>("bannerUrl")
            let channelDescription = Expression<String>("channelDescription")
            let channelName = Expression<String>("channelName")
            let subCount = Expression<Int64>("subCount")
            
            try db.run(channels.create(ifNotExists: true) { t in
                t.column(channelId, primaryKey: true)
                t.column(isActive)
                t.column(isSubbed)
                t.column(bannerUrl)
                t.column(channelDescription)
                t.column(channelName)
                t.column(subCount)
            })
            
        } catch {
            print("Error: \(error)")
            throw TADatabaseError.channelTableCreationError
        }
        
        do {
            let db = try Connection("\(dbPath)/TAKit.sqlite")
            
            let videos = Table("videos")
            let videoId = Expression<String>("videoId")
            let channelId = Expression<String>("channelId")
            let videoTitle = Expression<String>("videoTitle")
            let videoDescription = Expression<String>("videoDescription")
            let videoUrl = Expression<String>("videoUrl")
            let thumbnailUrl = Expression<String>("thumbnailUrl")
            let hasWatched = Expression<Bool>("hasWatched")
            let watchedDate = Expression<String>("watchedDate")
            let publishedDate = Expression<String>("publishedDate")

            try db.run(videos.create(ifNotExists: true) { t in
                t.column(videoId, primaryKey: true)
                t.column(videoTitle)
                t.column(channelId)
                t.column(videoDescription)
                t.column(videoUrl)
                t.column(thumbnailUrl)
                t.column(hasWatched)
                t.column(watchedDate)
                t.column(publishedDate)
            })
        } catch {
            print("Error: \(error)")
            throw TADatabaseError.videoTableCreationError
        }
    }
}
