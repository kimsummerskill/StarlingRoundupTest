//
//  RequestFactory.swift
//  StarlingRoundup
//
//  Created by Kim Summerskill on 05/07/2022.
//

import Foundation

class RequestFactory {

    private let baseURL = "https://api-sandbox.starlingbank.com"
    private let userAgent = "Kims user agent"
    private var accept = "application/json"
    private let accountUidPlaceholder = "{accountUid}"
    private let categoryUidPlaceholder = "{categoryUid}"
    private let savingsGoalUidPlaceholder = "{savingsGoalUid}"
    private let transferUidPlaceholder = "{transferUid}"

    private let authorization = "Bearer eyJhbGciOiJQUzI1NiIsInppcCI6IkdaSVAifQ.H4sIAAAAAAAA_31Uy5KbMBD8lS3Oqy1eFja33PID-YBhNNgqC4mShDdbqfx7BBLGeF25ubvn0aMZ_CeTzmVtBqNkggbz4TxYJfW5A339QDNk75mbuhCRH_KqbwSx-tSXrO6PJesIjkxgUZAoiDecQjD9HrO24IemOJRNXb9nEnwkcs6rmQBEM2n_0yhB9pcUoXZXiTqvjjWrylPO6rIGBnkfah8ENU3H6-bUhdreXEnHDH4iLPHIWYEcWd0IZKcKkUHfH6lrCp4DhIww1g9Eci5mNYI3pzLnjKpjw2rMa9aV4VdeHnjFqWpEIeaB0Yw0P0p0ylAZR6K1BOJt5S6LfaZhoJeC_xqfBClIe9lLsnteSed3TAJC2GC8JSH9HUTFe8DLQPfIDX9a6ekNJn8xVrqwRia1kDcpJlAxuAMFGpM1BCsYGu2tUbHRzCTN6F7aAbw0mpme9ZMW7i65e_cVxNY4OW-GdUQaQKbCioIRfW5hHNXXHS1RA2gBnlpBikKJFSbNXsnPg4yWerIUvLv_SdFG1EYFSOEFPJ3tMsdj4ncxpZLFC6zTDeQhuIEWA1zUhJehRvgiWqUI0hARbEFMDnBOMyUidLZ6XUuMf5C9Be0AN9eBZt2kru26XdqozUHEm4mI1wLzjYR7G6TfaiqDwcRDhYVgZj6SZzZlWdNLtY4UZ9xRS5QlJDn6HXB7KT74sjwLKokObmGnjp3NZmvHpeF23LfM-H6h8KsSm_ii1ibGonghMSkSLL1fosn7MO80JjjC-k2FP9Dltpmx4qH9nl377tkX-cx86jvvaVkgutszNYo-UVPn0IbHne9m7fLILVGPx7Xs7_nasr__AErMvmgZBgAA.cc5xPUIE7QD16795lXtsMThdgDuKQu-J11tikETpHo8wyym6WHoNmQZUScL48yLB5zjUHltoLmB9t-e82oaEfA2YLTz0w-8Cu81k_VmqSLxgUEm0YIXyd32fXnw_Qkf94cVwMGW4gyubMOJYHkAW3J6B8Cde4fEB9ekpfKS8EicfOYBZSXItKYBst-2a993ZRIWPoo6IrsMXXodRagkX61Lv7_tCZo8AmA1K0OhshtkJ8XzZT3tDcNtWYztDNRYCk5S95WhW2AJ7oJKzupGFn17ek9mr4NRtQH-u2RvTHWicmO68m_5dhTgT6kQR5n2VzhpbuWWsgl_LE52XcCwL-YFwdd6U5VO60BsPZd0bBZaVjwWgQeJqU0dLRl5KwCpQLeHotaApaDS9ITjpX4NQ1zOEn24DXLDRO5YhQGFM1qd_pnyODUXYqLCKiGvqCoMd_X_4aWsG-ljuXkeNpYNFz8yQMzExDW1k-0ZlY5DAvub1GFfKKTo9bKRCmUmghT6yvG5nLPwTZoueK3J4ePOLfr8y3C7VLtxDIvSOzzWuesUazAA2sW0zE7m28RNTy4czijdDGkXDgAzIj_0lKr0ZbUBfL1YcgitAWL_v5sYdEGc40QhY5Z8LFZEGxnvgiINXe-P9g1hg1Wcm6ku26dT_YdlF1kUGEPr9wO-VxMtzGGk"
    
    enum RequestType: String {
        case accounts = "/api/v2/accounts"
        case transactions = "/api/v2/feed/account/{accountUid}/category/{categoryUid}"
        case balance = "/api/v2/accounts/{accountUid}/balance"
        case createSavingsGoal = "/api/v2/account/{accountUid}/savings-goals"
        case addMoneyToSavingsGoal = "/api/v2/account/{accountUid}/savings-goals/{savingsGoalUid}/add-money/{transferUid}"
    }
    
    // Create a nice URL for our request type, take any parameters in context. Can split these requests out into their own files to tidy it up a bit more.
    func urlRequestFor(requestType: RequestType, context: Any?) -> URLRequest? {

        var urlString = "\(baseURL)\(requestType.rawValue)"
        var urlRequest: URLRequest?

        switch requestType {
        case .accounts:
            if let requestURL = URL(string: urlString) {
                urlRequest = URLRequest(url: requestURL)
                urlRequest?.httpMethod = "GET"
            }
        case .transactions:
            if let context = context as? TransactionsContext {

                urlString = urlString.replacingOccurrences(of: accountUidPlaceholder, with: context.accountUid)
                urlString = urlString.replacingOccurrences(of: categoryUidPlaceholder, with: context.categoryUId)

                if let requestURL = URL(string: urlString), var components = URLComponents(url: requestURL, resolvingAgainstBaseURL: false) {
                    components.queryItems = context.parameters().map { (key, value) in
                        URLQueryItem(name: key, value: value)
                    }

                    if let url = components.url {
                        urlRequest = URLRequest(url: url)
                        urlRequest?.httpMethod = "GET"
                    }
                }
            }
        case .balance:
            if let context = context as? String {

                urlString = urlString.replacingOccurrences(of: accountUidPlaceholder, with: context)

                if let requestURL = URL(string: urlString) {
                    urlRequest = URLRequest(url: requestURL)
                    urlRequest?.httpMethod = "GET"
                }
            }
        case .createSavingsGoal:
            if let context = context as? SavingsGoalContext {
                urlString = urlString.replacingOccurrences(of: accountUidPlaceholder, with: context.accountUid)

                if let requestURL = URL(string: urlString), let savingsGoal = context.jsonData() {
                    urlRequest = URLRequest(url: requestURL)
                    urlRequest?.httpMethod = "PUT"
                    urlRequest?.httpBody = savingsGoal
                }
            }

        case .addMoneyToSavingsGoal:
            if let context = context as? SavingsGoalAddContext {
                urlString = urlString.replacingOccurrences(of: accountUidPlaceholder, with: context.accountUid)
                urlString = urlString.replacingOccurrences(of: savingsGoalUidPlaceholder, with: context.savingsGoalUid)
                urlString = urlString.replacingOccurrences(of: transferUidPlaceholder, with: context.transferUid)

                if let requestURL = URL(string: urlString), let transferJson = context.jsonData() {
                    urlRequest = URLRequest(url: requestURL)
                    urlRequest?.httpMethod = "PUT"
                    urlRequest?.httpBody = transferJson
                }
            }
        }

        urlRequest?.setValue(accept, forHTTPHeaderField: "Content-Type")
        urlRequest?.setValue(authorization, forHTTPHeaderField: "Authorization")
        urlRequest?.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        urlRequest?.timeoutInterval = 60.0

        return urlRequest
    }
}
