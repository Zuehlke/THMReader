//
//  ArticleInterfaceController.swift
//  THMReader
//
//  Created by Jonas Wisplinghoff on 09/05/2017.
//  Copyright © 2017 Zühlke Engineering GmbH. All rights reserved.
//

import Foundation
import WatchKit
import FeedKit

class ArticleInterfaceController: WKInterfaceController {
    @IBOutlet var titleLabel: WKInterfaceLabel!
    @IBOutlet var bodyLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        guard let article = context as? RSSFeedItem else {
            return
        }
        
        self.titleLabel.setText(article.title)
        self.bodyLabel.setText(article.description)
    }
}
