import FluentPostgreSQL
import Vapor

final class Acronym: Codable {
    static let name = "acronyms"

    var id: Int?
    var userID: User.ID
    var short: String
    var long: String
    
    init(short: String, long: String, userID: User.ID) {
        self.short = short
        self.long  = long
        self.userID = userID
    }
}

extension Acronym: PostgreSQLModel {}
extension Acronym: Content  {}
extension Acronym: Parameter{}
extension Acronym {
    var user: Parent<Acronym, User> {
        return parent(\.userID)
    }
}
extension Acronym: Migration  {
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.reference(from: \.userID, to: \User.id)
        }
    }
}
