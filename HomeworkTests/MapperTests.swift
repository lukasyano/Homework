import CoreData
@testable import Homework
import XCTest

final class MapperTests: XCTestCase {
    func testMapFromApi() {
        // Given
        let post = ApiPostModel(
            userId: -1,
            id: -1,
            title: "title"
        )

        let user = ApiUserModel(
            id: -1,
            name: "name",
            email: "email",
            address: Address(street: "street", city: "city"),
            website: "website",
            company: Company(name: "companyName")
        )

        // When
        let result = Mapper.mapFromApi(post: post, user: user)

        // Then
        XCTAssertEqual(result.title, "Title") //make sure First letter capitalized
        XCTAssertEqual(result.author, "name")
        XCTAssertEqual(result.email, "email")
        XCTAssertEqual(result.website, "website")
        XCTAssertEqual(result.street, "street")
        XCTAssertEqual(result.city, "city")
        XCTAssertEqual(result.companyName, "companyName")
    }

    func testMapFromDB() {
        // Given
        let container = NSPersistentContainer(name: "Homework")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        let moc = container.viewContext
        
        let postEntity = NSEntityDescription.entity(forEntityName: "DBPostModel", in: moc)!
        
        let dbModel = DBPostModel(entity: postEntity, insertInto: moc)
        dbModel.id = UUID()
        dbModel.title = "Test title"
        dbModel.author = "John Doe"
        dbModel.email = "john@example.com"
        dbModel.website = "www.example.com"
        dbModel.street = "123 Main St"
        dbModel.city = "New York"
        dbModel.companyName = "Example Inc"
        
        do {
            try moc.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        
        // When
        let result = Mapper.mapFromDB(dbModel: [dbModel])
        
        // Then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].title, "Test title")
        XCTAssertEqual(result[0].author, "John Doe")
        XCTAssertEqual(result[0].email, "john@example.com")
        XCTAssertEqual(result[0].website, "www.example.com")
        XCTAssertEqual(result[0].street, "123 Main St")
        XCTAssertEqual(result[0].city, "New York")
        XCTAssertEqual(result[0].companyName, "Example Inc")
    }

}
