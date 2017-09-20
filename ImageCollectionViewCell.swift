//
//  ImageCollectionViewCell.swift
//  LicApp 0.1
//
//  Created by Максим on 15/09/2017.
//  Copyright © 2017 Максим. All rights reserved.
//

import UIKit

class GenericCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}

class ImageCell: GenericCollectionViewCell{
    @IBOutlet weak var imageView: UIImageView!
    var link : String? {
        didSet{
            loadImage()
        }
    }
    
    func loadImage(){
//        print(link)
        URLSession.shared.dataTask( with : URL.init( string : link! )! ) {(data : Data?, response: URLResponse?, error: Error?)  in
            if error != nil{
                print(error!)
            }else{
                if let image = UIImage(data : data!) {
                    DispatchQueue.main.async{
                        self.imageView.image = image
                    }
                }
            }
        }.resume()
    }
}

/*Get all image links;
  Give those to cells;
  Utilize them and show image;
 */
