//
//  Result.swift
//  StarlingRoundup
//
//  Created by Kim Summerskill on 27/06/2022.
//
// A sensible 'Result' enum to deal with our results in a consistent manner

enum Result<Value> {
    case success(Value)
    case failure(Error)

    // Return 'true' if the result is a success, 'false' otherwise.
    public var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }

    // Inverse of 'isSuccess' above
    public var isFailure: Bool {
        return !isSuccess
    }

    // Returns the associated value if the result is a success, 'nil' otherwise.
    public var value: Value? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }

    // Returns the associated error value if the result is a failure, 'nil' otherwise.
    public var error: Error? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}
