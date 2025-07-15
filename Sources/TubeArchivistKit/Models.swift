import Foundation
import Observation

public struct TAKitChannel: Sendable, Codable {
    public var channelId: String
    public var isActive: Bool
    public var isSubbed: Bool
    public var bannerUrl: String
    public var channelDescription: String
    public var channelName: String
    public var subCount: Int64
}

public struct TAKitVideo: Sendable {
    public var videoId: String
    public var channelId: String
    public var videoTitle: String
    public var videoDescription: String
    public var videoUrl: String
    public var thumbnailUrl: String
    public var hasWatched: Bool
    public var watchedDate: String
    public var publishedDate: String
}
