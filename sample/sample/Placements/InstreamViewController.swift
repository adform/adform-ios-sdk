//
//  InstreamViewController.swift
//  sample
//
//  Created by Jaroslav on 2022-05-30.
//

import UIKit
import AVKit
import AdformAdvertising

class InstreamViewController: UIViewController {
    
    let kPreRollMid = 1203459
    let kMidRollMid = 1203459
    let kPostRollMid = 1203459
    
    var afVideoPlayer: AFVideoPlayerController?
    var avVideoPlayer: AVPlayerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func showAVPlayer(_ sender: Any) {
        guard let url = contentURL() else {
            return
        }
        afVideoPlayer?.stop()
        afVideoPlayer?.view.removeFromSuperview()
        
        let player = AVPlayerViewController()
        player.player = AVPlayer(url: url)
        avVideoPlayer = player
        let playBack = AFAVPlayerViewControllerPlayback(player: player)
        let afPlayer = AFVideoPlayerController(container: player.view,
                                               andContentPlayback: playBack)
        afPlayer.preRollMId = kPreRollMid
        afPlayer.midRollMId = kMidRollMid
        afPlayer.postRollMId = kPostRollMid
        afVideoPlayer = afPlayer
        self.present(player, animated: true, completion: nil)
    }
    
    @IBAction func showSDKPlayer(_ sender: Any) {
        guard let url = contentURL() else {
            return
        }
        afVideoPlayer?.stop()
        afVideoPlayer?.view.removeFromSuperview()
        
        let player = AFVideoPlayerController(url: url)
        player.preRollMId = kPreRollMid
        player.midRollMId = kMidRollMid
        player.postRollMId = kPostRollMid
        player.view.frame = CGRect(x: 0,
                                   y: 200,
                                   width: view.frame.size.width,
                                   height: view.frame.size.width)
        view.addSubview(player.view)
        afVideoPlayer = player
        afVideoPlayer?.play()
    }
    
    func contentURL() -> URL? {
        return URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4")
    }

}
