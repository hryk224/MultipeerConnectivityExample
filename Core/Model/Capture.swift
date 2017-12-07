//
//  Capture.swift
//  iOS-MultipeerConnectivity
//
//  Created by hryk224 on 2017/12/10.
//  Copyright © 2017年 hryk224. All rights reserved.
//

import MultipeerConnectivity
import UIKit

struct Capture {

    enum Direction {
        case send
        case receive
        case local
    }

    let peerID: MCPeerID
    let direction: Direction
    let image: UIImage

    init(image: UIImage, peerID: MCPeerID, direction: Direction) {
        self.peerID = peerID
        self.direction = direction
        self.image = image
    }
}
