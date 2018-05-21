//
//  ApiService.swift
//  YouTube
//
//  Created by Rupali Ghate on 3/29/18.
//  Copyright © 2018 Rupali Ghate. All rights reserved.
//

import UIKit

class ApiService: NSObject {
    
    static let sharedInstance = ApiService()
    let baseUrl = "https://s3-us-west-2.amazonaws.com/youtubeassets"
    
    private override init() {
        super.init()
    }
    
    func fetchVideos(completion: @escaping ([Video]) -> ()) {
        fetchFeedForUrlString(urlString: "\(baseUrl)/home.json", completion: completion)
    }

    func fetchTrendingFeed(completion: @escaping ([Video]) -> ()) {
        fetchFeedForUrlString(urlString: "\(baseUrl)/trending.json", completion: completion)
    }

    func fetchSubscriptionFeed(completion: @escaping ([Video]) -> ()) {
        fetchFeedForUrlString(urlString: "\(baseUrl)/subscriptions.json", completion: completion)
    }
    
    func fetchFeedForUrlString(urlString: String, completion: @escaping ([Video])->()) {
        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            do {
                if let unwrappedData = data, let jsonDictionaries = try JSONSerialization.jsonObject(with: unwrappedData, options: .mutableContainers) as? [[String: Any]] {


                    //first approach
//                    let videos = jsonDictionaries.map({ return Video(dictionary: $0)})
//                    DispatchQueue.main.async {
///*                     to use this block - uncomment the setValue and init method in Video class as well */
//                        completion(jsonDictionaries.map({ return Video(dictionary: $0)}))
//                    }

                    //second approach - alternate block
                    var videos = [Video]()
                    for dict in jsonDictionaries  {
                        let video = Video()

                        video.title = dict["title"] as? String
                        video.thumbnail_image_name = dict["thumbnail_image_name"] as? String

                        let channelDictionary = dict["channel"] as! [String: Any]
                        let channel = Channel()
                        channel.name = channelDictionary["name"] as? String
                        channel.profile_image_name = channelDictionary["profile_image_name"] as? String

                        video.channel = channel

                        videos.append(video)
                    }

                    DispatchQueue.main.async {
                        completion(videos)
                    }
                }
                
            }catch let jsonError {
                print(jsonError)
            }
        }.resume()
    }

    
}
