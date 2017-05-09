//
//  InterfaceController.swift
//  THMReader WatchKit Extension
//
//  Created by Jonas Wisplinghoff on 08/05/2017.
//  Copyright © 2017 Zühlke Engineering GmbH. All rights reserved.
//

import WatchKit
import Foundation
import FeedKit

class InterfaceController: WKInterfaceController {
    @IBOutlet var tableView: WKInterfaceTable!

    var feed: RSSFeed?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        loadData()
    }
    
    func loadData(){
        //let url = URL(string: "https://www.thm.de/site/?format=feed&type=rss")!
        let url = URL(string: "https://www.tagesschau.de/xml/rss2")!
        
        FeedParser(URL: url)?.parse({ (result) in
            
            guard let feed = result.rssFeed, result.isSuccess else {
                print(result.error ?? "Unknown Error")
                return
            }
            
            self.feed = feed
            
            self.setTitle(feed.title)
            
            self.tableView.setNumberOfRows((feed.items?.count)!, withRowType: "ArticleRow")
            for (index, article) in feed.items!.enumerated() {
                let row = self.tableView.rowController(at: index) as! ArticleRowControler
                row.textLabel.setText(article.title)
                
            }
            
        })
    }

    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        switch segueIdentifier {
        case "ShowArticle":
            let article = self.feed?.items?[rowIndex]
            return article
            
        default:
            return nil
        }
    }
}
