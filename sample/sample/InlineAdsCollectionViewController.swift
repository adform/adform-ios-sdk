//
//  InlineAdsCollectionViewController.swift
//  sample
//
//  Created by Vladas Drejeris on 17/11/2017.
//  Copyright © 2017 adform. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
private let footerReuseIdentifier = "Footer"

class InlineAdsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, AFAdInlineDelegate {
    
    lazy var months: [String] = {
        let dateFormatter = DateFormatter()
        let dates = dateFormatter.monthSymbols!
        return dates
    }()
    
    var masterTag: Int {
        return 142493
    }
    
    var footerSize: CGSize = CGSize(width: 1, height: 1)
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.register(BannerFooter.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerReuseIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MonthCell
    
        let month = months[indexPath.section * 4 + indexPath.row]
        cell.set(title: month)
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerReuseIdentifier, for: indexPath) as! BannerFooter
        
        footer.loadAd(masterTag: masterTag, presenter: self, delegate: self)
        
        return footer
    }

    // MARK: UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dimension = collectionView.bounds.width - 60
        return CGSize(width: dimension, height: dimension)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return footerSize
    }
    
    func adInlineWillShow(_ adInline: AFAdInline!) {
        footerSize = adInline.adSize
        
        UIView.animate(withDuration: 0.3) {
            self.collectionView?.collectionViewLayout.invalidateLayout()
        }
    }
    
}

class MonthCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func set(title: String) {
        titleLabel.text = title
    }
    
}

class BannerFooter: UICollectionReusableView {

    var adInline: AFAdInline?
    
    
    func loadAd(masterTag: Int, presenter viewController: UIViewController, delegate: AFAdInlineDelegate) {
        if self.adInline != nil {
            // Only load ad once.
            return
        }
        
        let adInline = AFAdInline(masterTagId: masterTag, presenting: viewController)!
        adInline.areAditionalDimmensionsEnabled = true
        adInline.delegate = delegate
        adInline.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin, .flexibleTopMargin]
        adInline.center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        addSubview(adInline)
        adInline.loadAd()
        
        self.adInline = adInline
    }
    
}

