import Vapor
import Fluent
import FluentPostgresDriver
import JWT

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    let postgresConfig = SQLPostgresConfiguration(
          hostname: "localhost",
          port: 5432,
          username: "postgres",
          password: "sangam",
          database: "grocerydb", tls: .disable
      )

      app.databases.use(.postgres(
          configuration: postgresConfig
      ), as: .psql)

    app.migrations.add(CreateUsersTableMigration())
    app.migrations.add(CreateGroceryCategoryTableMigration())
    app.migrations.add(CreateGroceryItemMigration())
    
    
    //regiter the controller
    
    try app.register(collection: UserController())
    try app.register(collection: GroceryController())
    
    await app.jwt.keys.add(hmac: "MY_SECRET", digestAlgorithm: .sha256)
    
    Task {
        try await app.autoMigrate()
    }
    try routes(app)
}
