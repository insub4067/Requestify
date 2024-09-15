// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Alamofire
#if canImport(UIKit)
import UIKit
#endif

public struct Requestify {
    
    var urlString: String = ""
    var method: HTTPMethod = .get
    var parameters: [String: Any]? = nil
    var headers: HTTPHeaders? = nil
    var printLog = true
    var printResponse = true
    
    var formDataBuilders: [(MultipartFormData) -> Void] = []
    var object: (any Encodable)?
    
    public init() { }
}

// MARK: - Builder Interfaces
public extension Requestify {
    
    func setURL(_ url: String) -> Requestify {
        var builder = self
        builder.urlString = url
        return builder
    }
    
    func setMethod(_ method: HTTPMethod) -> Requestify {
        var builder = self
        builder.method = method
        return builder
    }
    
    func setParameters(_ parameters: [String: Any]?) -> Requestify {
        var builder = self
        builder.parameters = parameters
        return builder
    }
    
    func setHeaders(_ headers: HTTPHeaders?) -> Requestify {
        var builder = self
        builder.headers = headers
        return builder
    }
    
    func setApiLog(_ printLog: Bool = true, printResponse: Bool = true) -> Requestify {
        var builder = self
        builder.printLog = printLog
        builder.printResponse = printResponse
        return builder
    }
    
    func addObject<T: Encodable>(_ object: T, withName name: String) -> Requestify {
        var builder = self
        builder.object = object
        builder.formDataBuilders.append { multipartFormData in
            multipartFormData.append(object.data, withName: name)
        }
        return builder
    }
    
    #if canImport(UIKit)
    func addImages(_ images: [UIImage?], withName name: String, compressionQuality: CGFloat = 0.8) -> Requestify {
        var builder = self
        builder.formDataBuilders.append { multipartFormData in
            images
                .compactMap { $0?.jpegData(compressionQuality: compressionQuality) }
                .forEach { data in
                    multipartFormData.append(
                        data,
                        withName: name,
                        fileName: "image.jpg",
                        mimeType: "image/jpeg"
                    )
                }
        }
        return builder
    }
    #endif
}

// MARK: - Network Interfaces
public extension Requestify {
    
    @discardableResult func request<R: Codable>(_ expect: R.Type) async throws -> R {
        try await withCheckedThrowingContinuation { continuation in
            AF.request(
                self.urlString,
                method: self.method,
                parameters: self.parameters,
                encoding: JSONEncoding.default,
                headers: self.headers
            )
            .responseDecodable(of: R.self) { response in
                if printLog {
                    printApiLog(response, printResponse: self.printResponse)
                }
                switch response.result {
                case .success(let result):
                    continuation.resume(returning: result)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    @discardableResult func requeust() async throws -> HTTPURLResponse {
        try await withCheckedThrowingContinuation { continuation in
            AF.request(
                self.urlString,
                method: self.method,
                parameters: self.parameters,
                encoding: JSONEncoding.default,
                headers: self.headers
            )
            .response { response in
                if printLog {
                    printApiLog(response)
                }
                guard let response = response.response else {
                    continuation.resume(throwing: RequestifyError.responseNotFound)
                    return
                }
                continuation.resume(returning: response)
                return
            }
        }
    }
    
    @discardableResult func upload<R: Codable>(_ expect: R.Type) async throws -> R {
        try await withCheckedThrowingContinuation { continuation in
            AF.upload(
                multipartFormData: { multipartFormData in
                    formDataBuilders.forEach {
                        $0(multipartFormData)
                    }
                },
                to: urlString,
                method: method,
                headers: headers
            )
            .responseDecodable(of: R.self) { response in
                if printLog {
                    printApiLog(response, object: object)
                }
                switch response.result {
                case .success(let result):
                    continuation.resume(returning: result)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    @discardableResult func upload() async throws -> HTTPURLResponse {
        try await withCheckedThrowingContinuation { continuation in
            AF.upload(
                multipartFormData: { multipartFormData in
                    formDataBuilders.forEach {
                        $0(multipartFormData)
                    }
                },
                to: urlString,
                method: method,
                headers: headers
            )
            .response { response in
                if printLog {
                    printApiLog(response, object: object)
                }
                guard let response = response.response else {
                    continuation.resume(throwing: RequestifyError.responseNotFound)
                    return
                }
                continuation.resume(returning: response)
                return
            }
        }
    }
}
