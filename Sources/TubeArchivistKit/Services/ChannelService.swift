import Foundation
import SwiftyJSON
import SQLite

extension TubeArchivistServer {
    public func pullAllChannelsServer() async throws -> [TAKitChannel] {
        var channelArray: [TAKitChannel] = []
        
        let url = URL(string: "http://\(webAddress):\(port)/api/channel")!
        let request = URLRequest(url: url)
        let (data, response) = try await self.session.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw TAConnectionError.badResponse
        }
        
        guard let fetchedData = try? JSON(data: data) else {
            throw TAConnectionError.badData
        }
        
        for (_,channel):(String, JSON) in fetchedData["data"] {
            channelArray.append(TAKitChannel(
                channelId: channel["channel_id"].stringValue,
                isActive: channel["channel_active"].boolValue,
                isSubbed: channel["channel_subscribed"].boolValue,
                bannerUrl: channel["channel_banner_url"].stringValue,
                channelDescription: channel["channel_description"].stringValue,
                name: channel["channel_name"].stringValue,
                subCount: channel["channel_subs"].int64Value))
        }
        
        return channelArray
    }
    
    public func populateChannelTable(channelObjectArryay: [TAKitChannel]) throws {
        var channelInsert: [[Setter]] = []
        
        // Create channels table
        let channels = Table("channels")
        let channelId = Expression<String>("channelId")
        let isActive = Expression<Bool>("isActive")
        let isSubbed = Expression<Bool>("isSubbed")
        let bannerUrl = Expression<String>("bannerUrl")
        let channelDescription = Expression<String>("channelDescription")
        let channelName = Expression<String>("channelName")
        let subCount = Expression<Int64>("subCount")
        
        for channel in channelObjectArryay {
            channelInsert.append([channelId <- channel.channelId, isActive <- channel.isActive, isSubbed <- channel.isSubbed, bannerUrl <- channel.bannerUrl, channelDescription <- channel.channelDescription, channelName <- channel.name, subCount <- channel.subCount])
        }
        
        do {
            let db = try Connection("TAKit.sqlite")
            try db.run(channels.insertMany(channelInsert))
        } catch {
            print("Error while adding channels to database: \(error)")
            throw TADatabaseError.channelInsertionError
        }
    }
}

