//
//  ViewController.swift
//  LicApp 0.1
//
//  Created by Максим on 30/08/2017.
//  Copyright © 2017 Максим. All rights reserved.

import UIKit

class ViewController: UITableViewController {
    let url = URL.init(string: "https://11licey.ru")
    let dataFetcher = DataFetcher()
    var posts : [Post] = []
    var pageCount : Float = 1
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.posts.count == 0{
            dataFetcher.fetchPosts(from : Int(pageCount)){(error) in
                if error != nil {print(error!)}
                self.posts += self.dataFetcher.posts!
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = posts.count - 1
        pageCount+=0.1
        if indexPath.row == lastElement {
            dataFetcher.fetchPosts(from : Int(pageCount)){(error) in
                if error != nil {print(error!)}
                self.posts += self.dataFetcher.posts!
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataFetcher.sema.wait()
        dataFetcher.sema.signal()
        return self.posts.count != 0 ? self.posts.count : 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath ) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Post", for: indexPath)
        
        let post = self.posts[indexPath.row]
        cell.textLabel?.text = post.title
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailScreen") as? DetailViewController{
            vc.postLink = self.posts[indexPath.row].link
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}


