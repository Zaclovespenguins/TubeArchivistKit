import Foundation
import SwiftData

public struct TAKitChannel: Sendable, Codable {
    public var channelId: String
    public var isActive: Bool
    public var isSubbed: Bool
    public var bannerUrl: String
    public var channelDescription: String
    public var channelName: String
    public var subCount: Int64
}
