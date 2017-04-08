//
//  Article.swift
//  SPNewsApp
//
//  Created by Stepan Paholyk on 4/8/17.
//  Copyright © 2017 Stepan Paholyk. All rights reserved.
//

import UIKit

class Article: NSObject {
    
    var kAuthor: String?
    var kTitle: String?
    var kDescription: String?
    var kUrl: String?
    var kUrlToImage: String?
    var KPublishedAt: String?
    var kImage: UIImage? // ?
    
    
    init(withServer response:[String:Any]) {
        super.init()
        self.kTitle = response["title"] as? String
        self.kAuthor = response["author"] as? String
        self.kDescription = response["description"] as? String
        self.kUrl = response["url"] as? String
        self.KPublishedAt = response["publishedAt"] as? String
        self.kUrlToImage = response["urlToImage"] as? String
    }
}
