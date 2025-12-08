//
//  AdInlineTableViewController.swift
//  sample
//
//  Created by Laurynas Letkauskas on 2021-02-25.
//

import UIKit
import AdformAdvertising

fileprivate let kAdInlineTag = 101

class AdInlineTableViewController: UITableViewController {
    private var footers: [Int : UITableViewHeaderFooterView] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        9
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)

        // Just some dummy content.
        cell.textLabel?.text = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        sizeOfFooter(atSection: section)
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        // It is very important to reuse ad views. You can use the default table view caching mechanizm for that, but in this example
        // we use seperate dictionary. We need it for animations, we have to bind ads to sections. We check footer size based on ad state.
        var footerView = footers[section]

        var adInline: AFAdInline

        if footerView == nil {
            // If footer view is not retreived from cache, create a new one.
            footerView = UITableViewHeaderFooterView(reuseIdentifier: "header")

            // Create and setup a new adInline object.
            adInline = AFAdInline(masterTagId: masterTag(), presenting: self)

            // Center the ad in footer.
            var frame = adInline.frame
            frame.origin = CGPoint(x: ((footerView?.frame.size.width ?? 0.0) - (frame.size.width)) / 2, y: 0)
            adInline.frame = frame
            adInline.autoresizingMask = ([.flexibleLeftMargin, .flexibleRightMargin])

            // This line of code enables multiple ad size support.
            adInline.areAditionalDimmensionsEnabled = true

            adInline.delegate = self
            adInline.tag = kAdInlineTag

            // Add it to footer view and initiate ad loading.
            footerView?.contentView.addSubview(adInline)
            adInline.loadAd()

            footers[section] = footerView
        }

        return footerView
    }
    
    // MARK: - Content resizing
    
    /// Returns ad size, when ad is loaded otherwise 1.
    func sizeOfFooter(atSection section: Int) -> CGFloat {
        // Get ad from footer.
        let adInline = footers[section]?.viewWithTag(kAdInlineTag) as? AFAdInline
        
        // Return correct ad size only when adInline is not null and ad is loaded.
        // Ad is laoded if its state is AFAdStateVisible or AFAdStateInTransition (ad is going to be visible after animation).
        if let adInline = adInline,
           adInline.state == .visible ||
           adInline.state == .inShowTransition {
            return adInline.adSize.height
        } else {
            // There is an issue that if you return 0 here, 'tableView:viewForFooterInSection:' doesn't get called.
            return 1
        }
    }
    
    // MARK: - Helpers
    
    func masterTag() -> Int {
        987051
    }
}

extension AdInlineTableViewController: AFAdInlineDelegate {
    func adInlineWillShow(_ adInline: AFAdInline) {
        // When ad is about to begin presentation we just need to start table view updates.
        tableView.beginUpdates()
        tableView.endUpdates()
        print("Finish")
    }
}
