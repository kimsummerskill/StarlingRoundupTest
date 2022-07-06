//
//  AccountsService.swift
//  StarlingRoundup
//
//  Created by Kim Summerskill on 27/06/2022.
//

import Foundation

typealias RequestResult = Result<Any>
typealias RequestCompletionHandler = (RequestResult) -> Void

class AccountsService {
    private let requestFactory = RequestFactory()

    // Error routes
    enum RequestError: Error {
        case invalidData
        case invalidResponse
        case unableToDecodeModels
        case invalidDataObject
        case invalidURLConstruct
        case failed
        case serviceError(error: Error)
    }

    // Retrieve our results, fire off completion when finished. Going to use the new Decodable that they added in Swift 4 for this rather
    // than using the older style 'JSONSerialization.jsonObject' as it is much better and will allow us to one line decode.
    // Note: In this case I am assuming all the data comng back is correct as this is just a test project. Generally you would add more
    // protective code as sometimes data can come back in the wrong format from API calls.
    func retrieveResults(with requestType: RequestFactory.RequestType, context: Any?, completion: @escaping RequestCompletionHandler) {

        guard let request = requestFactory.urlRequestFor(requestType: requestType, context: context) else {
            completion(RequestResult.failure(RequestError.invalidURLConstruct))
            return
        }

        let _ = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error -> Void in

            if let error = error {
                completion(RequestResult.failure(RequestError.serviceError(error: error)))
                return
            }

            if let data = data {
                do {
                    if let object = try? JSONSerialization.jsonObject(with: data, options: []),
                    let data1 = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
                       let prettyPrintedString = NSString(data: data1, encoding: String.Encoding.utf8.rawValue) {
                        print("\(prettyPrintedString)")
                    }

                    let resultObjects = try data.decodeDataToObjects(with: requestType)
                    completion(RequestResult.success(resultObjects))

                }
                catch let error {
                    completion(RequestResult.failure(error))
                    return
                }
            }
            else {
                completion(RequestResult.failure((RequestError.invalidData)))
            }

        }).resume()
    }
}

extension Data {
    // Going to use this to decode json data directly to objects using the new
    // Decodable that they added in Swift 4. Pretty convenient, who needs random parser x.
    func decodeDataToObjects(with requestType: RequestFactory.RequestType) throws -> Any {
        do {
            switch requestType {
            case .accounts:
                return try JSONDecoder().decode(Accounts.self, from: self)
            case .transactions:
                return try JSONDecoder().decode(FeedItems.self, from: self)
            case .balance:
                return try JSONDecoder().decode(Balance.self, from: self)
            case .createSavingsGoal:
                return try JSONDecoder().decode(SavingsGoal.self, from: self)
            case .addMoneyToSavingsGoal:

                let result = try JSONDecoder().decode(SavingsTransferSuccess.self, from: self)
                if !result.success {
                    throw AccountsService.RequestError.failed
                }

                return result
            }
        }
    }
}
