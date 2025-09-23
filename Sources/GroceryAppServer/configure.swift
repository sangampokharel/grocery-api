import Vapor
import Fluent
import FluentPostgresDriver
import JWT

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    let a = Environment.get("JWT_SIGN_KEY")
    let postgresConfig = SQLPostgresConfiguration(
        hostname: Environment.get("DB_HOST_NAME") ?? "localhost",
          port: 5432,
        username: Environment.get("DB_USER_NAME") ?? "username",
        password: Environment.get("DB_PASSWORD") ?? "password",
          database: Environment.get("DB_NAME") ?? "grocerydb", tls: .disable
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
