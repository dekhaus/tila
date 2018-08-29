import Vapor
import Fluent

struct AcronymsController: RouteCollection {
    func boot(router: Router) throws {
        let acronymsRoutes = router.grouped("api", "acronyms")
        
        // index
        func getAllHandler(_ req: Request) throws -> Future<[Acronym]> {
            return Acronym.query(on: req).all()
        }
        
        // create
        func createHandler(_ req: Request) throws -> Future<Acronym> {
            return try req
                .content
                .decode(Acronym.self)
                .flatMap(to: Acronym.self) { acronym in
                    return acronym.save(on: req)
            }
        }
        
        // show
        func getHandler(_ req: Request) throws -> Future<Acronym> {
            return try req.parameters.next(Acronym.self)
        }

        // update
        func updateHandler(_ req: Request) throws -> Future<Acronym> {
            return try flatMap(to: Acronym.self,
                               req.parameters.next(Acronym.self),
                               req.content.decode(Acronym.self)) { acronym, updatedAcronym in
                                acronym.short = updatedAcronym.short
                                acronym.long  = updatedAcronym.long
                                return acronym.save(on: req)
            }
        }
        
        // delete
        func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
            return try req.parameters.next(Acronym.self)
                .delete(on: req)
                .transform(to: HTTPStatus.noContent)
        }
        
        // search
        func searchHandler(_ req: Request) throws -> Future<[Acronym]> {
            guard
                let searchTerm = req.query[String.self, at: "t"]
                else {
                    throw Abort(.badRequest)
            }
            
            return Acronym.query(on: req).group(.or) { or in
                or.filter(\.short == searchTerm)
                or.filter(\.long  == searchTerm)
                }.all()
        }

        // first
        func firstHandler(_ req: Request) throws -> Future<Acronym> {
            return Acronym.query(on: req)
                .first()
                .map(to: Acronym.self) { acronym in
                    guard let acronym = acronym else {
                        throw Abort(.notFound)
                    }
                    return acronym
            }
        }

        // sorted
        func sortedHandler(_ req: Request) throws -> Future<[Acronym]> {
            return Acronym.query(on: req)
                .sort(\.short, .ascending)
                .all()
        }

        acronymsRoutes.get(use: getAllHandler)
        acronymsRoutes.post(use: createHandler)
        acronymsRoutes.get(Acronym.parameter, use: getHandler)
        acronymsRoutes.put(Acronym.parameter, use: updateHandler)
        acronymsRoutes.delete(Acronym.parameter, use: deleteHandler)
        acronymsRoutes.get("search", use: searchHandler)
        acronymsRoutes.get("first", use: firstHandler)
        acronymsRoutes.get("sorted", use: sortedHandler)

    }
}
