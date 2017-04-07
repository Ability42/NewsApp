//
//  SourceViewController.swift
//  SPNewsApp
//
//  Created by Stepan Paholyk on 4/7/17.
//  Copyright © 2017 Stepan Paholyk. All rights reserved.
//

import UIKit

class SourceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var sourcesArray = [String]()
    var sourcesImageArray: UIImage?
    
    let kSourcesGet: String = "https://newsapi.org/v1/sources"
    
    
    lazy var manager: ServerManager = ServerManager.init()
    
    @IBOutlet weak var sourceTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchSources(withCategory: nil)
        self.sourcesArray.removeAll()
        self.fetchSources(withCategory: "gaming")
        self.sourcesArray.removeAll()
        self.fetchSources(withCategory: "business")
        self.sourcesArray.removeAll()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseID = "sourceCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath)
        return cell
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
                print(urlString)
                let jsonResponse = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String : Any]
                let jsonSources = jsonResponse["sources"] as? [[String : Any]]
                
                for source in jsonSources! {
                    let sourceName = source["name"] as! String
                    self.sourcesArray.append(sourceName)
                }
                print(self.sourcesArray.count)
                
            }
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
