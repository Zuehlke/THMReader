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
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    // MARK: Properties
    
    @IBOutlet var tableView: WKInterfaceTable!

    var feed: RSSFeed?

    var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self
                session.activate()
            }
        }
    }
    
    // MARK: Lifecycle
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        if WCSession.isSupported() {
            session = WCSession.default()
        }

        let defaultUrl = URL(string: "https://www.tagesschau.de/xml/rss2")!
        loadData(fromUrl: defaultUrl)
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

    // MARK: DataLoading
    
    func loadData(fromUrl url: URL){
        FeedParser(URL: url)?.parse({ (result) in
            
            guard let feed = result.rssFeed, result.isSuccess else {
                print(result.error ?? "Unknown Error")
                return
            }
            
            self.feed = feed
            
            DispatchQueue.main.async {
                self.updateUI();
            }
        })
    }
    
    // MARK: UI
    
    func updateUI() {
        self.setTitle(self.feed?.title)
        self.tableView.setNumberOfRows((self.feed?.items?.count)!, withRowType: "ArticleRow")
        
        if let items = self.feed?.items?.enumerated(){
            for (index, article) in items {
                let row = self.tableView.rowController(at: index) as! ArticleRowControler
                row.textLabel.setText(article.title)
            }
        }
    }
    
    // MARK: WCSessionDelegate

    public func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        if let urlString = message["url"] as? String, let url = URL(string: urlString){
            loadData(fromUrl: url)
        }
    }

    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Session activated: \(activationState.rawValue)")
    }

    public func sessionReachabilityDidChange(_ session: WCSession) {
        print("sessionReachabilityDidChange: \(session.isReachable)")
    }
}
