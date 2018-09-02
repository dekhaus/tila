import Vapor
import Fluent

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    let acronymsController = AcronymsController()
    let usersController = UsersController()
    
    try router.register(collection: acronymsController)
    try router.register(collection: usersController)
}
