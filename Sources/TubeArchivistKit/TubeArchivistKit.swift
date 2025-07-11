import Foundation
import SwiftyJSON
import KeychainSwift

public struct TubeArchivistServer {
//    let keychain = KeychainSwift()
//    public init(webAddress: String, port: String, apiToken: String) {
//        keychain.set(webAddress, forKey: "webAddress")
//        keychain.set(port, forKey: "port")
//        keychain.set(apiToken, forKey: "apiToken")
//    }
    let webAddress: String
    let port: String
    let apiToken: String
    let session: URLSession
    
    let dbPath = NSSearchPathForDirectoriesInDomains(
        .documentDirectory, .userDomainMask, true
    ).first!

    public init(webAddress: String, port: String, apiToken: String) {
        self.webAddress = webAddress
        self.port = port
        self.apiToken = apiToken
        self.session = TAURLSession(apiToken: apiToken)
        
        do {
            try self.initDatabase()
        } catch {
            print("Database init failed: \(error)")
        }
    }
    
    public func connectionTest() async throws -> String {
        let url = URL(string: "http://\(webAddress):\(port)/api/ping")!
        let request = URLRequest(url: url)
        
        let (data, response) = try await self.session.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw TAConnectionError.badResponse
        }
        //checks if there are errors regarding the HTTP status code and decodes using the passed struct
        guard let fetchedData = try? JSON(data: data) else {
            throw TAConnectionError.badData
        }
        
        return fetchedData["response"].stringValue
    }
}

