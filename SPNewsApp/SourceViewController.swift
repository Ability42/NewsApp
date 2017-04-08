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

    
    var sourcesArray = [Source]()
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    func setupTableView() {
        sourceTableView.estimatedRowHeight = 200
        sourceTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func setupActivityIndicator() {
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let articleVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ArticleViewController") as! ArticleViewController
        articleVC.currentSource = self.sourcesArray[indexPath.item]
        self.navigationController?.pushViewController(articleVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sourcesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseID = "sourceCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! SourceCell
        
        // Cell setup
//        cell.sourceLabel.text = self.sourcesArray[indexPath.item].kName
//        cell.sourceLabel.sizeToFit()

        
        cell.sourceImageView.sd_setImage(with: URL(string: self.sourcesArray[indexPath.item].kUrlsToLogo["small"]!), placeholderImage: #imageLiteral(resourceName: "Placeholder"))
        //cell.sourceImageView.contentMode = .center
        //cell.sourceImageView.layer.masksToBounds = true
        
        cell.selectionStyle = .none
        
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
                
                let jsonResponse = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String : Any]
                let jsonSources = jsonResponse["sources"] as? [[String : Any]]
                
                for item in jsonSources! {
                    let source = Source(withServer: item)
                    self.sourcesArray.append(source)
                }

            }
            DispatchQueue.main.async {
                self.sourceTableView.reloadData()
            }
        })

    }

}

