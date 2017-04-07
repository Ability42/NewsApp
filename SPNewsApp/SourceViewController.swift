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
    
    @IBOutlet weak var sourceTableView: UITableView!
    
    override func loadView() {
        super.loadView()
        self.fetchSources(withCategory: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func setupTableView() {

    }
    
    func setupActivityIndicator() {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sourcesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseID = "sourceCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! SourceCell
        
        
        // Cell setup
        cell.sourceLabel.text = self.sourcesArray[indexPath.item]
        cell.sourceImageView.sd_setImage(with: URL(string: self.sourcesImageArray[indexPath.item])!)
        
        return cell
    }
    
    let menuManager = MenuManager()
    
    
    @IBAction func openFilterMenu(_ sender: Any) {
        menuManager.openMenu() 
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
                    let smallImageUrl = jsonLogos["medium"]
                    
                    self.sourcesImageArray.append(smallImageUrl!)
//                    print(smallImageUrl!)
                    print(sourceName)
                }
                print(self.sourcesArray.count)
                print(self.sourcesImageArray.count)
                
            }
            DispatchQueue.main.async {
                self.sourceTableView.reloadData()
            }
        })

    }

}

