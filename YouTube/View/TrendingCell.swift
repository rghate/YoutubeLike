//
//  TrendingCell.swift
//  YouTube
//
//  Created by Rupali Ghate on 4/8/18.
//  Copyright © 2018 Rupali Ghate. All rights reserved.
//

import UIKit

class TrendingCell: FeedCell {
    override func fetchVideos() {
        
        ApiService.sharedInstance.fetchTrendingFeed { (videos: [Video]) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }
}
