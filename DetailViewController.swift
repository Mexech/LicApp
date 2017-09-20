import UIKit

class DetailViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var imageCollection: UICollectionView!

    var postLink : String?
    var dataFetcher = DataFetcher()
    var imageLinks : [String] = []
    
//    func loadImages(){
//        if let imageLinks = dataFetcher.imageLinks{
//            for imageLink in imageLinks{
//                
//            }
//        }
//    }
    
    func fillWithContent(){
        dataFetcher.getContentBy(postLink!, imageCollection)
        dataFetcher.sema.wait()
        for contentBlock in dataFetcher.content!{
            if contentBlock != ""{
                contentLabel.text?.append(contentBlock+"\n\n")
            }
        }
        if let imgLinks = dataFetcher.imageLinks{
            self.imageLinks+=imgLinks
        }
        contentLabel.sizeToFit()
        dataFetcher.sema.signal()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fillWithContent()
//        dataFetcher.fetchImagesBy(postLink!){(error) in
//            if error != nil {print(error!)}
//            if let images = self.dataFetcher.images{
//                self.images += images
//                self.imageCollection.reloadData()
//            }
//        }
        imageCollection.delegate = self
        imageCollection.dataSource = self
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataFetcher.sema.wait()
        dataFetcher.sema.signal()
        return imageLinks.count != 0 ? imageLinks.count : 0
    }
    
    func collectionView(collectionView : UICollectionView, layout colllectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexpath:IndexPath) -> CGSize{
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        print(dataFetcher.imageLinks?.count)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCell
        let imageLink = dataFetcher.imageLinks?[indexPath.item]
        
        cell.link = imageLink
        
        return cell
    }
    

}





