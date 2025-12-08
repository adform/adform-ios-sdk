//
//  CollectionPagerViewController.swift
//  sample
//
//  Created by Laurynas Letkauskas on 2021-02-26.
//

import UIKit
import AdformAdvertising


private let kMasterTag = 987063

class CollectionPagerViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, AFCollectionViewMediatorDelegate {
    
    private let datasource: [String] = DateFormatter().monthSymbols
    private var mediator: AFCollectionViewMediator?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create ad mediator for collection view.
        mediator = AFCollectionViewMediator(
            masterTagId: kMasterTag,
            adFrequency: 3,
            collectionView: collectionView,
            presenting: self)
        mediator?.delegate = self
        
      //  collectionView.delegate = self
       // collectionView.dataSource = self
    }

// MARK: - AFCollectionViewMediatorDelegate

    // Uncomment to show ads at specific pages.
    //- (BOOL )collectionViewMediator:(AFCollectionViewMediator *)mediator shouldShowAdAtIndexPath:(NSIndexPath *)indexPath {
    //
    //    return (indexPath.row == 1) || (indexPath.row == 5);
    //}
   // func collectionViewMediator(_ mediator: AFCollectionViewMediator, shouldShowAdAt indexPath: IndexPath) -> Bool {
        //return (indexPath.row == 1) || (indexPath.row == 5)
//    }
// MARK: - Collection view

    /// There can be any implementation of UICollectionView here.
    /// There is only one condition for it, collection view should
    /// show only one cell (page) at a time, otherwise mediator may work
    /// incorrectly.

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       datasource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = mediator?.collectionView.dequeueReusableCell(withReuseIdentifier: "CellIdentifier", for: indexPath) else {
            fatalError("Mediator failed to dequeue cell at indepath: \(indexPath)")
        }

        let label = cell.contentView.viewWithTag(1) as? UILabel
        label?.text = datasource[indexPath.row].uppercased()

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: self.collectionView.frame.size.width, height: self.collectionView.frame.size.height)
    }

    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        collectionView.performBatchUpdates({ [self] in
            collectionViewLayout.invalidateLayout()
            collectionView.reloadData()
        }) { [self] finished in
            if let firstObject = collectionView.indexPathsForVisibleItems.first {
                collectionView.scrollToItem(
                    at: firstObject,
                    at: .centeredHorizontally,
                    animated: true)
            }
        }
    }
}

