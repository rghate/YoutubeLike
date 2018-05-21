//
//  Video.swift
//  YouTube
//
//  Created by Rupali Ghate on 3/26/18.
//  Copyright © 2018 Rupali Ghate. All rights reserved.
//

import UIKit

class SafeJsonObject: NSObject {
    
    override func setValue(_ value: Any?, forKey key: String) {
        
        //convert fist characher of the key parameter to uppercase. This is done to concatinate it later with 'set' to create a selector string.
        //e.g. for key number_of_likes the selector string should be "setNumber_of_likes:"
        let uppercasedFirstCharacter = String(key.first!).uppercased()
        
        let range = key.startIndex...key.startIndex
        let selectorString = key.replacingCharacters(in: range, with: uppercasedFirstCharacter)

        //form selector method call to invoke it later
        let selector = NSSelectorFromString("set\(selectorString):")
        let responds = self.responds(to: selector)
        
        if !responds {
            return
        }
        
        super.setValue(value, forKey: key)
    }
    
}
class Video: SafeJsonObject {

    var thumbnail_image_name: String?
    var title: String?
    var number_of_views: NSNumber?
    var uploadDate: NSDate?
    var duration: NSNumber?
    
    var channel: Channel?

    
}
//    override func setValue(_ value: Any?, forKey key: String) {
//        if key == "channel" {
//            //custom channel setup
//            self.channel = Channel()
//            self.channel?.setValuesForKeys(value as! [String: Any])
//        } else {
//            super.setValue(value, forKey: key)
//        }
//    }
//    
//    init(dictionary: [String: Any]) {
//        super.init()
//        setValuesForKeys(dictionary)
//    }


class Channel: SafeJsonObject {
    var name: String?
    var profile_image_name: String?
}
