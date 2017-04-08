//
//  Source.swift
//  SPNewsApp
//
//  Created by Stepan Paholyk on 4/8/17.
//  Copyright © 2017 Stepan Paholyk. All rights reserved.
//

import UIKit

class Source: NSObject {

    let kId: String
    let kName: String
    let kDescription: String
    let kURL: URL
    let kUrlsToLogo: [String : String]
    let kSortBysAvaliable: [String]
    
    
    init(withServer response:[String:Any])  {
        
        self.kId = response["id"] as! String
        self.kName = response["name"] as! String
        self.kDescription = response["description"] as! String
        self.kURL = URL(string: response["url"] as! String)!
        self.kUrlsToLogo = response["urlsToLogos"] as! [String : String]
        self.kSortBysAvaliable = response["sortBysAvailable"] as! [String]
        
    }
    
}
