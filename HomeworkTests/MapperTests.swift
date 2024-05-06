import CoreData
@testable import Homework
import XCTest

final class MapperTests: XCTestCase {
    func test_mapper_MapFromApi_shouldTransformApiModelsToEntities() {
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
        let result: PostEntity = Mapper.mapFromApi(post: post, user: user)
        // Then
        XCTAssertEqual(result.title, "Title") // make sure First letter capitalised
        XCTAssertEqual(result.author, "name")
        XCTAssertEqual(result.email, "email")
        XCTAssertEqual(result.website, "website")
        XCTAssertEqual(result.street, "street")
        XCTAssertEqual(result.city, "city")
        XCTAssertEqual(result.companyName, "companyName")
    }

    func test_mapper_mapFromDb_shouldTransformDbModelToPostEntity() {
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
        dbModel.title = "Title"
        dbModel.author = "author"
        dbModel.email = "email@email.com"
        dbModel.website = "www.website.com"
        dbModel.street = "123 Main St"
        dbModel.city = "City"
        dbModel.companyName = "Baltic Amadeus"

        do {
            try moc.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        // When
        let result = Mapper.mapFromDB(dbModel: [dbModel])
        // Then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].title, "Title")
        XCTAssertEqual(result[0].author, "author")
        XCTAssertEqual(result[0].email, "email@email.com")
        XCTAssertEqual(result[0].website, "www.website.com")
        XCTAssertEqual(result[0].street, "123 Main St")
        XCTAssertEqual(result[0].city, "City")
        XCTAssertEqual(result[0].companyName, "Baltic Amadeus")
    }
}
