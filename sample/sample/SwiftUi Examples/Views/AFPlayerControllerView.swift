//
//  AFPlayerController.swift
//  ios-advertising-sample-swiftui
//
//  Created by Jaroslav on 2022-06-17.
//

import UIKit
import SwiftUI
import AdformAdvertising


struct AFPlayerControllerView: UIViewRepresentable {
    
    let player = AFVideoPlayerController()
    
    func makeUIView(context: Context) -> UIView {
        guard let controller = UIApplication.shared.rootViewController else {
            fatalError()
        }
        player.view.frame = CGRect(x: 0,
                                   y: 200,
                                   width: controller.view.frame.size.width,
                                   height: controller.view.frame.size.width)
        player.view.setContentHuggingPriority(.required, for: .horizontal)
        player.view.setContentHuggingPriority(.required, for: .vertical)
        player.view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        player.view.setContentCompressionResistancePriority(.required, for: .vertical)
        player.view.translatesAutoresizingMaskIntoConstraints = false
        return player.view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        player.contentURL = contentURL()
        player.preRollMId = 1203459
        player.midRollMId = 1203459
        player.postRollMId = 1203459
        player.play()
    }
    
    func contentURL() -> URL? {
        return URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4")
    }
}
