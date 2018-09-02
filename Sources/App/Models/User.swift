import Foundation
import Vapor
import FluentPostgreSQL

final class User: Codable {
    static let name = "users"

    var id: UUID?
    var fullname: String
    var username: String
    
    init(fullname: String, username: String) {
        self.fullname = fullname
        self.username = username
    }
}

extension User: PostgreSQLUUIDModel {}
extension User: Content {}
extension User: Migration {}
extension User: Parameter {}
extension User {
    var acronyms: Children<User, Acronym> {
        return children(\.userID)
    }
}
