//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

class TokenService {
    private var communicationTokenFetchUrl: String
    private var getAuthTokenFunction: () -> String?

    init(communicationTokenFetchUrl: String, getAuthTokenFunction: @escaping () -> String?) {
        self.communicationTokenFetchUrl = communicationTokenFetchUrl
        self.getAuthTokenFunction = getAuthTokenFunction
    }

    func getCommunicationToken(completionHandler: @escaping (String?, Error?) -> Void) {
        let json: [String: Any] = ["acsmri": "8:acs:e7d15876-7f5f-4005-850d-c96843c48666_0000000f-198c-b6fd-99bf-a43a0d002a48"]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        let url = URL(string: communicationTokenFetchUrl)!
        var urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = jsonData
        //urlRequest.httpMethod = "GET"
        //if let authToken = getAuthTokenFunction() {
        //    urlRequest.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        //}

        URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            if let error = error {
                print(error)
            } else if let data = data {
                do {
                    let res = try JSONDecoder().decode(TokenResponse.self, from: data)
                    print(res.token)
                    completionHandler(res.token, nil)
                } catch let error {
                    print(error)
                }
            }
        }.resume()
    }
}

private struct TokenResponse: Decodable {
    var token: String

    private enum CodingKeys: String, CodingKey {
        case token
    }
}
