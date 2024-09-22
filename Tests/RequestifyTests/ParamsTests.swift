//
//  File.swift
//  
//
//  Created by 김인섭 on 9/15/24.
//

import XCTest
@testable import Requestify

class ParamsTests: XCTestCase {
    
    func testAddDuplicateKey() {
        let parameters = Params()
            .add("username", value: "user123")
            .add("username", value: "newUser123")
            .build()
        
        XCTAssertEqual(parameters["username"] as? String, "newUser123", "The 'username' parameter should be updated with 'newUser123'")
    }
    
    func testAddEmptyKey() {
        let parameters = Params()
            .add("", value: "emptyKey")
            .build()
        
        XCTAssertNil(parameters[""], "The empty key should not be added to the parameters.")
    }
    
    func testBuildEmptyParameters() {
        let builder = Params()
        let parameters = builder.build()
        
        XCTAssertTrue(parameters.isEmpty, "The parameters dictionary should be empty.")
    }
    
    func testAddSingleParameter() {
        let parameters = Params()
            .add("username", value: "user123")
            .build()
        
        XCTAssertEqual(parameters["username"] as? String, "user123", "The 'username' parameter should be 'user123'.")
    }

    func testAddMultipleParameters() {
        let parameters = Params()
            .add(["username": "user123", "password": "pass123"])
            .build()
        
        XCTAssertEqual(parameters["username"] as? String, "user123", "The 'username' parameter should be 'user123'.")
        XCTAssertEqual(parameters["password"] as? String, "pass123", "The 'password' parameter should be 'pass123'.")
    }

    func testRemoveParameter() {
        let parameters = Params()
            .add("username", value: "user123")
            .remove(key: "username")
            .build()
        
        XCTAssertNil(parameters["username"], "The 'username' parameter should have been removed.")
    }

    func testClearParameters() {
        let parameters = Params()
            .add("username", value: "user123")
            .add("password", value: "pass123")
            .clear()
            .build()
        
        XCTAssertTrue(parameters.isEmpty, "The parameters dictionary should be empty after clearing.")
    }

    func testBuildParameters() {
        let builder = Params()
            .add("username", value: "user123")
            .add("age", value: 30)
        
        let parameters = builder.build()
        
        XCTAssertEqual(parameters.count, 2, "The parameters dictionary should have 2 items.")
        XCTAssertEqual(parameters["username"] as? String, "user123", "The 'username' parameter should be 'user123'.")
        XCTAssertEqual(parameters["age"] as? Int, 30, "The 'age' parameter should be 30.")
    }
}
