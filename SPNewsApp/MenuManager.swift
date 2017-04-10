//
//  MenuManager.swift
//  SPNewsApp
//
//  Created by Stepan Paholyk on 4/8/17.
//  Copyright © 2017 Stepan Paholyk. All rights reserved.
//

import UIKit

class MenuManager: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var filterTableView: UITableView
    var blackView: UIView
    let categories: [String]
    
    var mainVC: SourceViewController?

    func setUpMenu() {
        filterTableView.delegate = self
        filterTableView.dataSource = self
        filterTableView.isScrollEnabled = false
        filterTableView.bounces = false
        filterTableView.separatorStyle = .none
        filterTableView.register(CategoryViewCell.classForCoder(), forCellReuseIdentifier: "categoryCell")
    }
    
    override init() {

        self.filterTableView = UITableView()
        self.blackView = UIView()
        self.categories = ["Business", "Entertainment", "Gaming", "General", "Science-and-Nature", "Music", "Sport", "Technology", "All"]
        
        super.init()
        
        self.setUpMenu()
    }
    
    
    public func openMenu() {
        if let window = UIApplication.shared.keyWindow {
            
            blackView.frame = window.frame
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.closeMenu)))

            let height: CGFloat = 36 * 9
            let y = window.frame.height - height
            
            filterTableView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)

            window.addSubview(blackView)
            window.addSubview(filterTableView)
            
            UIView.animate(withDuration: 0.4, animations: { 
                self.blackView.alpha = 1
                self.filterTableView.frame.origin.y = y
            })
        }
    }

    
    public func closeMenu() {
        UIView.animate(withDuration: 0.45) { 
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.filterTableView.frame.origin.y = window.frame.height
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = mainVC {
            
            let category = categories[indexPath.item].lowercased()
            vc.currentCategory = category
            vc.sourcesArray.removeAll()

            if category == "all" {
                vc.fetchSources(withCategory: nil)
            } else {
                vc.fetchSources(withCategory: category)
            }
            
            closeMenu()
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 36
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseID = "categoryCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath)
        cell.textLabel?.text = categories[indexPath.item]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = UIFont(name: "Menlo", size: 15)
        return cell
    }

}
