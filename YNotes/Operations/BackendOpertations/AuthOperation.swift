//
//  AuthOperation.swift
//  YNotes
//
//  Created by Dzhek on 14/08/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import Foundation

//MARK: - • Class

class AuthOperation: BaseBackendOperation {
    
    //MARK: • Properties
    
    var result: Bool?
    
    private var endPoint = EndPoint()
    private let login: String?
    private let password: String?
    private var authData: AuthData?
    
    init(login: String, password: String ) {
        self.login = login
        self.password = password
        super.init()
    }
    
    //MARK: - • Methods
    
    override func main() {
        
        let urlString:String = endPoint.baseURL + endPoint.authorizations
        let method:String = HTTPMethod.post.rawValue
        
        guard let url = URL(string: urlString)
            else {
                NetworkError.message(funcName: "'Auth_Operation.main()'", info: "Bad 'url'")
                self.result = false
                return
            }

        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        let parameter = ["scopes": ["gist"],"note": Services.descriptionToken ] as [String : Any]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameter, options: []) else { return }
        request.httpBody = httpBody
        
        guard let login = self.login, let password = self.password
            else {
                NetworkError.message(funcName: "'Auth_Operation.main()'", info: "Bad 'login/ password'")
                self.result = false
                return }
        
        let loginPasswordString = "\(login):\(password)"
        let userPasswordData = loginPasswordString.data(using: String.Encoding.utf8)
        let base64EncodedCredential = userPasswordData!.base64EncodedString(options: [])
        let authString = "Basic \(base64EncodedCredential)"
        config.httpAdditionalHeaders = ["Authorization" : authString]
        let session = URLSession(configuration: config)
        
        session.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }

            if let response = response as? HTTPURLResponse {
                let status = response.statusCode
                switch status {
                case 200..<300:
                    logDebug("'Auth_Operation' ] -> [ Server response ] -> [ Successful: \(status)")
                default:
                    self.result = false
                    NetworkError.message(funcName: "'Auth_Operation.main()'", info: "failure ] -> [ Server response: \(status)")
                    return
                }
            }
            guard let data = data
                else {
                    NetworkError.message(funcName: "'Auth_Operation.main()'", info: "Bad Data")
                    self.result = false
                    return }
            do {
                self.authData = try newJSONDecoder().decode(AuthData.self, from: data)
                
                if self.authData?.token != nil, self.authData?.tokenID != nil {
                    Services.token = self.authData!.token
                    Services.tokenID = self.authData!.tokenID
                    self.result = true
                }
            } catch {
                self.result = false
                NetworkError.message(funcName: "'Auth_Operation.main()'", info: "Bad decoding")
            }
        }.resume()
        
        while self.result == nil {}
        finish()
    }
    
}
