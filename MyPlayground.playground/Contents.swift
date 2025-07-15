import TubeArchivistKit
import Foundation
import SwiftUI

let test_ip: String = "10.9.11.2"
let test_port: String = "8000"
let test_apiToken: String = "86e8a76e0653f9af757f79f110519e82e71203bb"

let TAConnection = TubeArchivistServer(webAddress: test_ip, port: test_port, apiToken: test_apiToken)


do {
//    let channelData = try await TAConnection.pullAllChannelsServer()
//    
//    try TAConnection.populateChannelTable(channelObjectArryay: channelData)
    
    let allChannels = try await TAConnection.pullAllChannelsServer()
    
    print(allChannels.map(\.channelName))
    
} catch {
    print(error)
}







