//
//  SessionContainer2.swift
//  iOS-MultipeerConnectivity
//
//  Created by hryk224 on 2017/12/10.
//  Copyright © 2017年 hryk224. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol SessionContainer2Delegate: class {
    func sessionContainer(received capture: Capture)
}

final class SessionContainer2: NSObject {

    let session: MCSession
    weak var delegate: SessionContainer2Delegate?

    private let displayName: String
    // クライアント
    private let nearbyServiceAdvertiser: MCNearbyServiceAdvertiser

    init(displayName: String, serviceType: String) {
        self.displayName = displayName

        let peerID = MCPeerID(displayName: displayName)
        session = MCSession(peer: peerID)

        nearbyServiceAdvertiser = MCNearbyServiceAdvertiser(peer: peerID,
                                                            discoveryInfo: nil,
                                                            serviceType: serviceType)
        super.init()

        session.delegate = self
        nearbyServiceAdvertiser.delegate = self
        nearbyServiceAdvertiser.startAdvertisingPeer()
    }

    deinit {
        nearbyServiceAdvertiser.stopAdvertisingPeer()
        session.disconnect()
    }
}

// MARK: - MCSessionDelegate
extension SessionContainer2: MCSessionDelegate {

    // Remote peer changed state.
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("\(#function) \(peerID.description) \(state)")
    }

    // Received data from remote peer.
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print(#function)

        guard let image = UIImage(data: data) else {
            return
        }
        let capture = Capture(image: image, peerID: peerID, direction: .receive)
        delegate?.sessionContainer(received: capture)
        return
    }

    // Received a byte stream from remote peer.
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print(#function)
    }

    // Start receiving a resource from remote peer.
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print(#function)
    }

    // Finished receiving a resource from remote peer and saved the content
    // in a temporary location - the app is responsible for moving the file
    // to a permanent location within its sandbox.
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        print(#function)
    }

    // Made first contact with peer and have identity information about the
    // remote peer (certificate may be nil).
    //    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Swift.Void) {
    //        print(#function)
    //        print(certificate)
    //    }

}

// MARK: - MCNearbyServiceAdvertiserDelegate
extension SessionContainer2: MCNearbyServiceAdvertiserDelegate {

    // Incoming invitation request.  Call the invitationHandler block with YES
    // and a valid session to connect the inviting peer to the session.
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("\(#function) \(peerID.displayName)")
        invitationHandler(true, session)
    }

    // Advertising did not start due to an error.
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print(#function)
    }

}
