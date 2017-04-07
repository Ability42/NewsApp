//
//  SourceViewController.swift
//  SPNewsApp
//
//  Created by Stepan Paholyk on 4/7/17.
//  Copyright © 2017 Stepan Paholyk. All rights reserved.
//

import UIKit
import SDWebImage

class SourceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var sourcesArray = [String]()
    var sourcesImageArray = [String]()
    let kSourcesGet: String = "https://newsapi.org/v1/sources"
    lazy var manager: ServerManager = ServerManager.init()
    let menuManager = MenuManager()
    var currentCategory: String?
    
    @IBOutlet weak var sourceTableView: UITableView!
    
    override func loadView() {
        super.loadView()
        self.fetchSources(withCategory: currentCategory)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
    }
    
    func setupTableView() {
        sourceTableView.estimatedRowHeight = 200
        sourceTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sourcesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseID = "sourceCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! SourceCell
        
        // Cell setup
        cell.sourceLabel.text = self.sourcesArray[indexPath.item]
        cell.sourceLabel.sizeToFit()
        
        cell.sourceImageView.sd_setImage(with: URL(string: self.sourcesImageArray[indexPath.item])!)
        cell.sourceImageView.contentMode = .center
        
        return cell
    }
    
    
    @IBAction func openFilterMenu(_ sender: Any) {
        menuManager.openMenu()
        menuManager.mainVC = self
    }
    
    func fetchSources(withCategory category: String?) {
        
        var urlString = ""
        
        if let categoryToGet = category {
            urlString = self.kSourcesGet + "?category=" + categoryToGet
        } else {
            urlString = self.kSourcesGet
        }
        
        self.manager.makeRequest(urlString: urlString, completionHandler: { (data) in
            if !(data?.isEmpty)! {
                //print(urlString)
                let jsonResponse = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String : Any]
                let jsonSources = jsonResponse["sources"] as? [[String : Any]]
                
                for source in jsonSources! {
                    let sourceName = source["name"] as! String
                    self.sourcesArray.append(sourceName) // append in array
                    
                    let jsonLogos = source["urlsToLogos"] as! [String : String]
                    let smallImageUrl = jsonLogos["small"]
                    
                    self.sourcesImageArray.append(smallImageUrl!)
//                    print(smallImageUrl!)
                    print(sourceName)
                }
                print(self.sourcesArray.count)
                
            }
            DispatchQueue.main.async {
                self.sourceTableView.reloadData()
            }
        })

    }

}

