//
//  File.swift
//  
//
//  Created by 김인섭 on 9/15/24.
//

import Foundation
import Alamofire

func printApiLog<T: Codable>(
    _ response: AFDataResponse<T>,
    parameters: [String: Any]? = nil,
    object: Encodable? = nil,
    printResponse: Bool = true
) {
    #if DEBUG
    print("🛜 NETWORK LOG")
    
    // MARK: - Request
    if let request = response.request {
        if let url = request.url?.absoluteString {
            print(" • url:", url)
        }
        print(" • method:", request.httpMethod ?? "")
        print(" • headers:")
        request.headers.forEach { headers in
            print("  - \(headers.name):", headers.value)
        }
        if let parameters {
            print(" • parameters:", parameters)
        }
        if let object, let pretty = makePrettyJson(from: object.data) {
            print(" • object:", pretty)
        }
    }
    
    // MARK: - Response Status
    if let statusCode = response.response?.statusCode {
        print(" • status code:", statusCode)
    }
    
    // MARK: - Response Data
    if
        printResponse,
        let data = response.data,
        let string = makePrettyJson(from: data)
    {
        print(" • response:", string)
    }
    
    // MARK: - Response Error
    if let error = response.error {
        print(" • error:", error)
    }
    #endif
}

func makePrettyJson(from data: Data) -> String? {
    guard
        let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
        let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted])
    else {
        return nil
    }
    return String(data: prettyData, encoding: .utf8)
}
