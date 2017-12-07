//
//  Transcript.swift
//  iOS-MultipeerConnectivity
//
//  Created by hryk224 on 2017/12/10.
//  Copyright © 2017年 hryk224. All rights reserved.
//

import Foundation
import MultipeerConnectivity

struct Transcript {

    enum Direction {
        case send
        case receive
        case local
    }

    let message: String?
    let peerID: MCPeerID
    let direction: Direction

    init(message: String, peerID: MCPeerID, direction: Direction) {
        self.message = message
        self.peerID = peerID
        self.direction = direction
    }

}

extension MCSessionState: CustomStringConvertible {

    public var description: String {
        switch self {
        case .connected:
            return "Connected"
        case .connecting:
            return "Connecting"
        case .notConnected:
            return "Not Connected"
        }
    }

}
