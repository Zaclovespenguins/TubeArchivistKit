import Foundation
import SwiftyJSON
import SQLite

extension TubeArchivistServer {
    public func pullAllVideosServer() async throws -> [TAKitVideo] {
        var videoArray: [TAKitVideo] = []
        
        // Initial call to get pagination info
        let url = URL(string: "http://\(webAddress):\(port)/api/video/?page=0")!
        let request = URLRequest(url: url)
        let (data, response) = try await self.session.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw TAConnectionError.badResponse
        }
        
        guard let fetchedData = try? JSON(data: data) else {
            throw TAConnectionError.badData
        }
        
        let totalPageCount: Int = fetchedData["paginate"]["last_page"].intValue
        
        for page in 1...totalPageCount {
            do {
                videoArray.append(contentsOf: try await pullVideosFromPage(page: page))
            } catch {
                print("Error while parsing video data on page \(page): \(error)")
            }
        }
        
        return videoArray
//        return channelArray
    }
    
    func pullVideosFromPage(page: Int) async throws -> [TAKitVideo] {
        var videoArray: [TAKitVideo] = []
        
        // Initial call to get pagination info
        let url = URL(string: "http://\(webAddress):\(port)/api/video/?page=\(page)")!
        let request = URLRequest(url: url)
        let (data, response) = try await self.session.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw TAConnectionError.badResponse
        }
        
        guard let fetchedData = try? JSON(data: data) else {
            throw TAConnectionError.badData
        }
        
        for (_,videoJson):(String, JSON) in fetchedData["data"] {
            videoArray.append(TAKitVideo(
                videoId: videoJson["youtube_id"].stringValue,
                channelId: videoJson["channel"]["channel_id"].stringValue,
                videoTitle: videoJson["title"].stringValue,
                videoDescription: videoJson["description"].stringValue,
                videoUrl: videoJson["media_url"].stringValue,
                thumbnailUrl: videoJson["vid_thumb_url"].stringValue,
                hasWatched: videoJson["player"]["watched"].bool ?? false,
                watchedDate: videoJson["player"]["watched_date"].string ?? "9999-12-31",
                publishedDate: videoJson["published"].stringValue))
        }
        
        return videoArray
    }
    
    public func populateVideoTable() async throws {
        var channelObjectArray: [TAKitVideo] = try await self.pullAllVideosServer()
        
        var videoInsert: [[Setter]] = []

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
        
        for video in channelObjectArray {
            videoInsert.append([videoId <- video.videoId, channelId <- video.channelId, videoTitle <- video.videoTitle, videoDescription <- video.videoDescription, videoUrl <- video.videoUrl, thumbnailUrl <- video.thumbnailUrl, hasWatched <- video.hasWatched, watchedDate <- video.watchedDate, publishedDate <- video.publishedDate])
        }
        
        do {
            let db = try Connection("\(dbPath)/TAKit.sqlite")
            try db.run(videos.insertMany(videoInsert))
        } catch {
            print("Error while adding videos to database: \(error)")
            throw TADatabaseError.videoInsertionError
        }
    }
}

