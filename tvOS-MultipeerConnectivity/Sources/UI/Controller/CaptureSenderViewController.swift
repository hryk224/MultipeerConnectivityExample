//
//  CaptureSenderViewController.swift
//  tvOS-MultipeerConnectivity
//
//  Created by hryk224 on 2017/12/10.
//  Copyright © 2017年 hryk224. All rights reserved.
//

import AVKit
import MultipeerConnectivity
import UIKit

final class CaptureSenderViewController: UIViewController {

    @IBAction func browseForPeers(_ sender: UIBarButtonItem) {
        sessionContainer.nearbyServiceBrowser.startBrowsingForPeers()

        self.sessionContainer.startCapture()

        self.present(playerViewController, animated: true) {
            self.player.play()
        }
    }

    @IBOutlet weak var playerView: UIView!

    private let sessionContainer: SessionContainer2 = {
        return .init(displayName: Const.displayName, serviceType: Const.serviceType)
    }()

    private let mediaURL = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_ts/master.m3u8")!
    private lazy var asset: AVAsset = {
        return AVAsset(url: self.mediaURL)
    }()

    private lazy var playerItem: AVPlayerItem = {
        let playerItem = AVPlayerItem(asset: asset)
        return playerItem
    }()

    private lazy var player: AVPlayer = {
        return AVPlayer(playerItem: playerItem)
    }()

    // Create and present an `AVPlayerViewController`.
    private lazy var playerViewController: AVPlayerViewController = {
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        return playerViewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = ""
    }
}
