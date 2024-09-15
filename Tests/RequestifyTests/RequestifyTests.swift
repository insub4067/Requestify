import XCTest
import Alamofire
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
}
