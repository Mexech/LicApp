import Foundation
import SwiftSoup

class DataFetcher{
    
    private var htmlPostDoc : Document?
    
    var sema = DispatchSemaphore(value: 1)
    var posts : [Post]?
    var content : [String]?
    var imageLinks : [String]?

    private func isPost(_ rawPost : Element) -> Bool{
        let post = try! rawPost.getElementsByAttributeValueStarting("class", "entry post")
        if post.array().count != 0{
            return true
        }else{
            return false
        }
    }
    
//    private func getImageBy(_ link : String){
//        let imageLink = URL.init(string: link)!
//        
//        URLSession.shared.dataTask(with : imageLink){(data : Data? ,response: URLResponse?, error: Error?)  in
//            if error != nil{
//                print(error!)
//            }else{
//                if let image = UIImage(data : data!) {
//                    self.images?.append(image)
//                }
//            }
//        }.resume()
//    }
    
    private func retrieveHtmlAsStringBy(_ url: URL, completionHandler: @escaping (Error?, String?) -> Void){
        var htmlAsString : String?
        
        URLSession.shared.dataTask(with: url) {(data: Data!, response: URLResponse!, error: Error!) in
            if error != nil {
                completionHandler(error, nil)
            }else{
                if (data) != nil {
                    htmlAsString = String(data: data, encoding: .utf8)//TODO: Some error catching
                    completionHandler(nil, htmlAsString)
                }else{
                    print("No data")
                    completionHandler(error, nil)
                }
            }
        }.resume()
    }
    
    func getContentBy(_ link : String, _ collectionView : UICollectionView){
        self.sema.wait()
        retrieveHtmlAsStringBy(URL.init(string : link)!){(error, htmlAsString) in
            
            if error != nil{
                print(error!)
            }else{
                self.htmlPostDoc = try! SwiftSoup.parse(htmlAsString!)
                let content = try! self.htmlPostDoc?.body()?.select("div.post-content > *")
                self.content = []
                self.imageLinks = []
                for block in content!{
                    let contentBlock = try! block.select("p").text()
                    var imageLink = try! block.select("img").attr("src")
                    
                    print(imageLink)
                    if let dotRange = imageLink.range(of: "?"){
                        imageLink.removeSubrange(dotRange.lowerBound ..< imageLink.endIndex)
                    }
                    self.content?.append(contentBlock)
                    if imageLink != ""{
                        self.imageLinks?.append(imageLink)
                    }
                }
                DispatchQueue.main.async {
                    collectionView.reloadData()
                }
            }
            self.sema.signal()
        }
    }
    
//    func fetchImagesBy(_ link : String, completionHandler: @escaping (Error?)->Void){
//        self.sema.wait()
//        let content = try! htmlPostDoc?.body()?.select("div.post-content > *")
//        let imageCompletion = DispatchSemaphore(value : 1)
//        
//        for block in content!{
//            var imageLink = try! block.select("img").attr("src")
//            if let dotRange = imageLink.range(of: "?"){
//                imageLink.removeSubrange(dotRange.lowerBound ..< imageLink.endIndex)
//            }
//            
//            if imageLink != "" {
//                self.images = []
//                let imageUrl = URL.init(string : imageLink)
//                
//              imageCompletion.wait()
//                URLSession.shared.dataTask(with : imageUrl!) {(data : Data?, response: URLResponse?, error: Error?)  in
//                    if error != nil{
//                        completionHandler(error!)
//                    }else{
//                        if let image = UIImage(data : data!) {
//                            self.images?.append(image)
//                            imageCompletion.signal()
//                        }
//                    }
//                }.resume()
//            }
//        }
//        imageCompletion.wait()
//        self.sema.signal()
//        imageCompletion.signal()
//        completionHandler(nil)
//    }
    
    func fetchPosts(from page : Int, completionHandler: @escaping (Error?) -> Void){
        self.sema.wait()
        let url = URL.init(string: "https://11licey.ru/page/" + String(page))
        
        retrieveHtmlAsStringBy(url!){ (error, htmlAsString) in
            
            if error != nil{
                completionHandler(error)
            }else{
            
                let htmlDoc = try! SwiftSoup.parse(htmlAsString!)
                let hub = try! htmlDoc.select("div#primary > *")
                
                self.posts = []
                for rawPost in hub {
                    if self.isPost(rawPost){
                        let title = try! rawPost.select("div.post-meta > h2").text()
                        let link = try! rawPost.select("div.post-meta > h2 > a").attr("href")
                        let post = Post(title: title, link : link)
                        self.posts?.append(post)
                    }
                }
                self.sema.signal()
                completionHandler(nil)
            }
        }
    }
}
