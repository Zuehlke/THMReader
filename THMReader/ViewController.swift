//
//  ViewController.swift
//  THMReader
//
//  Created by Jonas Wisplinghoff on 08/05/2017.
//  Copyright © 2017 Zühlke Engineering GmbH. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WCSessionDelegate {

    // MARK: Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self
                session.activate()
            }
        }
    }

    let feeds: [FeedItem] = [FeedItem(title: "THM", url: URL(string: "https://www.thm.de/site/?format=feed&type=rss")!),
                             FeedItem(title: "Zühlke Blog", url: URL(string: "http://blog.zuehlke.com/feed/")!),
                             FeedItem(title: "Tagesschau", url: URL(string: "https://www.tagesschau.de/xml/rss2")!),
                             FeedItem(title: "BBC World News", url: URL(string: "https://feeds.bbci.co.uk/news/world/rss.xml")!)]
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        if WCSession.isSupported() {
            session = WCSession.default()
        }

        tableView.delegate = self
        tableView.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UITableViewDelegate + DataSource
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reusableCell = tableView.dequeueReusableCell(withIdentifier: "feedRow")
        
        if let cell = reusableCell{
            cell.textLabel?.text = feeds[indexPath.row].title
            cell.detailTextLabel?.text = feeds[indexPath.row].url.absoluteString
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = feeds[indexPath.row].url.absoluteString

        session?.sendMessage(["url":url], replyHandler: nil)

        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: WCSessionDelegate
    
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Session activated: \(activationState)")
    }

    public func sessionDidBecomeInactive(_ session: WCSession) {
        print("SessionDidBecomeInactive")
    }

    public func sessionDidDeactivate(_ session: WCSession) {
        print("SessionDidDeactivate")
    }

}

