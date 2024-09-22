//
//  File.swift
//  
//
//  Created by 김인섭 on 9/15/24.
//

import Foundation

public struct Params {

    var parameters: [String: Any] = [:]

    public init() { }

    public func add(_ key: String, value: Any) -> Params {
        var builder = self
        if !key.isEmpty {
            builder.parameters[key] = value
        }
        return builder
    }

    public func add(_ params: [String: Any]) -> Params {
        var builder = self
        for (key, value) in params {
            if !key.isEmpty {
                builder.parameters[key] = value
            }
        }
        return builder
    }

    public func remove(key: String) -> Params {
        var builder = self
        builder.parameters.removeValue(forKey: key)
        return builder
    }

    public func clear() -> Params {
        var builder = self
        builder.parameters.removeAll()
        return builder
    }

    public func build() -> [String: Any] {
        return parameters
    }
}
