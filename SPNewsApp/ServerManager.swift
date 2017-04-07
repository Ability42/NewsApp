//
//  ServerManager.swift
//  SPNewsApp
//
//  Created by Stepan Paholyk on 4/7/17.
//  Copyright © 2017 Stepan Paholyk. All rights reserved.
//

import UIKit

class ServerManager: NSObject {

    static let sharedManager = ServerManager()
    
    func makeRequest(urlString: String, completionHandler: @escaping (Data?) -> ()) {
        
        let targetURL = URL.init(string: urlString)
        var request = URLRequest.init(url: targetURL!)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                completionHandler(Data())
            } else {
                completionHandler(data!)
            }
            }.resume()
        
    }

    
}
