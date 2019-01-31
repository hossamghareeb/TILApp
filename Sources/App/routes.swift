import Vapor

struct AcronymsResponse: Content {
    let data: [Acronym]
}

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }
    
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }
    
    /// Create
    router.post(Acronym.self, at: "api", "acronyms") { request, acronym -> Future<Acronym> in
        return acronym.save(on: request)
    }
    
    /// GET all
    router.get("api", "acronyms") { request -> Future<AcronymsResponse> in
        return Acronym.query(on: request).all().map { AcronymsResponse(data: $0) }
    }
    
    /// GET by ID
    router.get("api", "acronyms", Acronym.parameter) { request -> Future<Acronym> in
        return try request.parameters.next(Acronym.self)
    }
    
    /// Update
    router.put(Acronym.self, at: "api", "acronyms", Acronym.parameter) { request, newAcronym -> Future<Acronym> in
        try request.parameters.next(Acronym.self).flatMap(to: Acronym.self, { oldAcronym in
            oldAcronym.short = newAcronym.short
            oldAcronym.long = newAcronym.long
            return oldAcronym.save(on: request)
        })
    }
    
    /// Delete by ID
    router.delete("api", "acronyms", Acronym.parameter) { request -> Future<HTTPStatus> in
        try request.parameters.next(Acronym.self).delete(on: request).transform(to: HTTPStatus.noContent)
    }
}
