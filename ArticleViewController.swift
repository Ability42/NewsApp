//
//  ArticleViewController.swift
//  SPNewsApp
//
//  Created by Stepan Paholyk on 4/8/17.
//  Copyright © 2017 Stepan Paholyk. All rights reserved.
//

import UIKit
import SDWebImage

class ArticleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var articleFilter: UISegmentedControl!
    @IBOutlet weak var articleTableView: UITableView!
    var currentSource: Source?
    var articlesArray: [Article]? = []
    var avaliableSortFiters: [String]?
    var currentFilter: String?
    
    lazy var manager = ServerManager.sharedManager
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.title = currentSource?.kName
        self.fetchArticlesWithFilter(filter: (currentSource?.kSortBysAvaliable.first)!)
        self.currentFilter = currentSource?.kSortBysAvaliable.first
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.initialFilterSetup()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        webVC.urlToLoad = self.articlesArray?[indexPath.item].kUrl
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articlesArray!.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseID = "articleCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! ArticleViewCell
        
        // Setup cell controls
        cell.titleLabel.text = self.articlesArray?[indexPath.item].kTitle
        cell.authorLabel.text = self.articlesArray?[indexPath.item].kAuthor
        cell.descriptionLabel.text = self.articlesArray?[indexPath.item].kDescription
        cell.dateLabel.text = self.articlesArray?[indexPath.item].KPublishedAt
        
        if let urlToImage = self.articlesArray?[indexPath.item].kUrlToImage {
            cell.photoImageView.sd_setImage(with: URL(string: urlToImage), placeholderImage: #imageLiteral(resourceName: "Placeholder"))
        } else {
            cell.photoImageView.image = #imageLiteral(resourceName: "Placeholder")
        }
        
        cell.photoImageView.layer.masksToBounds = true; // ?
        cell.photoImageView.contentMode = .scaleAspectFill
        
        return cell
    }

    
    func initialFilterSetup() {
        for filterItem in avaliableSortFiters! {
            if filterItem == "top" {
                self.articleFilter.setEnabled(true, forSegmentAt: 0)
            }
            if filterItem == "latest" {
                self.articleFilter.setEnabled(true, forSegmentAt: 1)
            }
            if filterItem == "popular" {
                self.articleFilter.setEnabled(true, forSegmentAt: 2)
            }
        }
        
        for i in 0...2 {
            if self.currentFilter == self.articleFilter.titleForSegment(at: i)?.lowercased() {
                articleFilter.selectedSegmentIndex = i
            }
        }
    }
    
    
    @IBAction func chooseFilter(_ sender: UISegmentedControl) {
        self.articlesArray?.removeAll()
        fetchArticlesWithFilter(filter: (sender.titleForSegment(at: sender.selectedSegmentIndex)?.lowercased())!)
    }
    
    
    func fetchArticlesWithFilter(filter: String) {

        let source = currentSource!.kId
        let APIkey = "43060499d5354c6f8ecbc338180b0093"
        let stringURL = "https://newsapi.org/v1/articles?source=\(source)&sortBy=\(filter)&apiKey=\(APIkey)"
        
        
        
        self.manager.makeRequest(urlString: stringURL) { (data) in
            
            if !(data?.isEmpty)! {
                let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String : Any]
                let jsonArticles = json["articles"] as? [[String : Any]]
                
                for article in jsonArticles! {
                    if article["title"] != nil {
                        let articleObj = Article(withServer: article)
                        self.articlesArray?.append(articleObj)

                    } else {
                        print("Article is Nil")
                    }
                }
                
            }
            
            DispatchQueue.main.async {
                self.articleTableView.reloadData()
            }
        }
        
    }
}
