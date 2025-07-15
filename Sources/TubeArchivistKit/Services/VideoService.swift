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
}

