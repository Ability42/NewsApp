//
//  MenuManager.swift
//  SPNewsApp
//
//  Created by Stepan Paholyk on 4/8/17.
//  Copyright © 2017 Stepan Paholyk. All rights reserved.
//

import UIKit

class MenuManager: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    let filterTableView = UITableView()
    let blackView = UIView()
    let categories = ["Business", "Entertainment", "Gaming", "General", "Science & Nature", "Music", "Sport", "Technology", "All"]
    
    public func openMenu() {
        if let window = UIApplication.shared.keyWindow {
            
            blackView.frame = window.frame
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.closeMenu)))
            
            // Configure TableView
            
            let height: CGFloat = 270
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
    
    override init() {
        super.init()
        
        filterTableView.delegate = self
        filterTableView.dataSource = self

        filterTableView.isScrollEnabled = false
        filterTableView.bounces = false
        
        filterTableView.register(CategoryViewCell.classForCoder(), forCellReuseIdentifier: "categoryCell")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseID = "categoryCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.item]
        
        return cell
    }

}
