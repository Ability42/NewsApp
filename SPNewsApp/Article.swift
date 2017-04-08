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
        if let title = response["title"] as? String,
            let author = response["author"] as? String,
            let description = response["description"] as? String,
            let url = response["url"] as? String,
            let imageUrl = response["urlToImage"] as? String,
            let publishedAt = response["publishedAt"] as? String {
            
            self.kTitle = title
            self.kAuthor = author
            self.kDescription = description
            self.kUrl = url
            self.KPublishedAt = publishedAt
            self.kUrlToImage = imageUrl
        }
    }
}
