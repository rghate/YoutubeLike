//
//  Extensions.swift
//  YouTube
//
//  Created by Rupali Ghate on 3/26/18.
//  Copyright © 2018 Rupali Ghate. All rights reserved.
//

import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

let imageCache = NSCache<NSString, AnyObject>()

class CustomImageView: UIImageView {
    
    var imageUrlString: String?
    
    func loadImageUsingUrlString(urlString: String) {
        
        imageUrlString = urlString
        
        let url = URL(string: urlString)
        
        //check if image is already available in cache
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        image = nil
        //if image is not in cache, download it from internet.
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            if let imgData = data {
                DispatchQueue.main.async {
                    let imageToCache = UIImage(data: imgData)
                    
                    //this is to make sure that the correct image is being displayed on the cell visible on screen even after scrolling.
                    if self.imageUrlString == urlString {
                        //display image
                        self.image = imageToCache
                    }
                    
                    // add downloaded image into cache
                    imageCache.setObject(imageToCache!, forKey: urlString as NSString)
                }
            }
        }).resume()
    }
}
