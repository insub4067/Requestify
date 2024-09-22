import XCTest
import Alamofire
#if canImport(UIKit)
import UIKit
#endif
@testable import Requestify

final class RequestifyTests: XCTestCase {
    
    func testSetURL() {
        let url = "https://jsonplaceholder.typicode.com/posts"
        let builder = Requestify().setURL(url)
        
        XCTAssertEqual(builder.urlString, url, "URL should be set correctly")
    }
    
    func testSetMethod() {
        let builder = Requestify().setMethod(.post)
        
        XCTAssertEqual(builder.method, .post, "HTTP Method should be POST")
    }
    
    func testSetParameters() {
        let parameters: [String: Any] = ["key": "value"]
        let builder = Requestify().setParameters(parameters)
        
        XCTAssertEqual(builder.parameters?["key"] as? String, "value", "Parameters should be set correctly")
    }
    
    
    func testSetHeaders() {
        let headers: HTTPHeaders = ["Authorization": "Bearer token123"]
        let builder = Requestify().setHeaders(headers)
        
        XCTAssertEqual(builder.headers?["Authorization"], "Bearer token123", "Headers should be set correctly")
    }
    
    func testSetPrintLog() {
        let builder = Requestify().setPrintLog(false)
        
        XCTAssertFalse(builder.printLog, "Print log should be set to false")
    }
    
    func testSetPrintResponse() {
        let builder = Requestify().setPrintResponse(false)
        
        XCTAssertFalse(builder.printResponse, "Print response should be set to false")
    }
    
    #if canImport(UIKit)
    func testAddImages() {
        let image = UIImage(systemName: "star") // 사용 가능한 더미 이미지
        let builder = Requestify().addImages([image], withName: "image")
        
        XCTAssertFalse(builder.formDataBuilders.isEmpty, "Form data builders should not be empty when images are added")
    }
    #endif
    
    func testAddObject() {
        struct DummyObject: Encodable {
            let name: String
            let age: Int
        }
        let dummyObject = DummyObject(name: "John", age: 25)
        let builder = Requestify().addObject(dummyObject, withName: "user")
        
        XCTAssertNotNil(builder.object, "Encodable object should be added correctly")
    }
}
