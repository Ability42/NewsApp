//
//  SourceViewController.swift
//  SPNewsApp
//
//  Created by Stepan Paholyk on 4/7/17.
//  Copyright © 2017 Stepan Paholyk. All rights reserved.
//

import UIKit
import SDWebImage
import Reachability

class SourceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var sourcesArray = [Source]()
    let kSourcesGet: String = "https://newsapi.org/v1/sources"
    var currentCategory: String?
    
    lazy var manager: ServerManager = ServerManager.sharedManager
    let menuManager = MenuManager()

    let reachability = Reachability()!


    var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var sourceTableView: UITableView!
    
    
    func setupActivityIndicator() {
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        sourceTableView.backgroundView = activityIndicatorView
        activityIndicatorView.hidesWhenStopped = true
        sourceTableView.separatorStyle = .none
    }
    
    override func loadView() {
        super.loadView()
        

        if reachability.isReachable {
            self.fetchSources(withCategory: currentCategory)
        } else {
            self.createAlertController()
        }
        
    }
    
    func createAlertController() {
        let alert = UIAlertController(title: "Network not avaliable", message: "Please, checkout you connection and restart app", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.setupActivityIndicator()
        activityIndicatorView.startAnimating()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.activityIndicatorView.stopAnimating()
        self.sourceTableView.separatorStyle = .singleLine
    }
    
    func setupTableView() {
        sourceTableView.estimatedRowHeight = 200
        sourceTableView.rowHeight = UITableViewAutomaticDimension
        sourceTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let articleVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ArticleViewController") as! ArticleViewController
        articleVC.currentSource = self.sourcesArray[indexPath.item]
        articleVC.avaliableSortFiters = self.sourcesArray[indexPath.item].kSortBysAvaliable

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

