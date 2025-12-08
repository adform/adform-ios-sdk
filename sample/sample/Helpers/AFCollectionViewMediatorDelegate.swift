//
//  AFCollectionViewMediatorDelegate.swift
//  sample
//
//  Created by Laurynas Letkauskas on 2021-02-26.
//

import Foundation

protocol AFCollectionViewMediatorDelegate: AnyObject {
    /// Called to determine if ad should be displayed at the index path.
    /// - Parameters:
    ///   - mediator: A collection view mediator calling the method.
    ///   - indexPath: The index path at which an ad should be displayed.
    /// - Returns: A boolean value indicating if ad should be displayed at the index path.
    func collectionViewMediator(_ mediator: AFCollectionViewMediator, shouldShowAdAt indexPath: IndexPath) -> Bool
}

extension AFCollectionViewMediatorDelegate {
    func collectionViewMediator(_ mediator: AFCollectionViewMediator, shouldShowAdAt indexPath: IndexPath) -> Bool {
        false
    }
}
