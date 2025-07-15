import SQLite

extension TubeArchivistServer {
    public func AllChannelsArray() throws -> [TAKitChannel] {
        do {
            let db = try Connection("\(dbPath)/TAKit.sqlite")
            let channels = Table("channels")

            return try db.prepare(channels).map { row in
                return try row.decode()
            }
        } catch {
            print("Error getting channels from database: \(error)")
            throw TADatabaseError.channelGetError
        }
    }
}
