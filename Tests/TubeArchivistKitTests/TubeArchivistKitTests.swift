import Testing
@testable import TubeArchivistKit

@Test func connectionTest() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    let test_ip: String = "10.9.11.2"
    let test_port: String = "8000"
    let test_apiToken: String = "86e8a76e0653f9af757f79f110519e82e71203bb"

    let TAConnection = TubeArchivistServer(webAddress: test_ip, port: test_port, apiToken: test_apiToken)

    Task {
        do {
            let test_response = try await TAConnection.connectionTest()
            #expect(test_response == "pong")
            #expect(test_response == "ping")
        }
    }

}

@Test func channelTest() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    let test_ip: String = "10.9.11.2"
    let test_port: String = "8000"
    let test_apiToken: String = "86e8a76e0653f9af757f79f110519e82e71203bb"

    let TAConnection = TubeArchivistServer(webAddress: test_ip, port: test_port, apiToken: test_apiToken)

    Task {
        do {
             let test_channelResponse = try await TAConnection.getAllChannels()
             #expect(test_channelResponse == "Auto Focus")
        }
    }
}

@Test func fastTest() {
    let a = 1
    #expect(a == 2)
}
