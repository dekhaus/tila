import FluentPostgreSQL
import Vapor

final class Acronym: Codable {
    static let name = "acronyms"

    var id: Int?
    var short: String
    var long: String
    
    init(short: String, long: String) {
        self.short = short
        self.long  = long
    }
}

extension Acronym: PostgreSQLModel {}
extension Acronym: Content  {}
extension Acronym: Migration  {}
extension Acronym: Parameter{}
