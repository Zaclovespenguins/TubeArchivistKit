import Foundation
import SwiftData

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


