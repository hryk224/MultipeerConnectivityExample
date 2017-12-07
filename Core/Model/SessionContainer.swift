//
//  SessionContainer.swift
//  iOS-MultipeerConnectivity
//
//  Created by hryk224 on 2017/12/10.
//  Copyright © 2017年 hryk224. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol SessionContainerDelegate: class {
    func sessionContainer(received transcript: Transcript)
}

final class SessionContainer: NSObject {

    let session: MCSession
    weak var delegate: SessionContainerDelegate?

    private let displayName: String
    private let advertiserAssistant: MCAdvertiserAssistant

    init(displayName: String, serviceType: String) {
        self.displayName = displayName

        let peerID = MCPeerID(displayName: displayName)
        session = MCSession(peer: peerID)
        
        advertiserAssistant = MCAdvertiserAssistant(serviceType: serviceType,
                                                    discoveryInfo: nil,
                                                    session: session)

        super.init()

        session.delegate = self
        advertiserAssistant.start()
    }

    deinit {
        advertiserAssistant.stop()
        session.disconnect()
    }

    func sendMessage(_ message: String) -> Transcript {
        let data = message.data(using: String.Encoding.utf8)
        try? session.send(data!, toPeers: session.connectedPeers, with: .reliable)
        let transcript = Transcript(message: message, peerID: session.myPeerID, direction: .send)
        return transcript
    }
}

// MARK: - MCSessionDelegate
extension SessionContainer: MCSessionDelegate {

    // Remote peer changed state.
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print(#function)
        guard state == .connected else { return }
        let transcript = Transcript(message: state.description, peerID: peerID, direction: .local)
        delegate?.sessionContainer(received: transcript)
    }

    // Received data from remote peer.
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print(#function)

        guard let message = String(data: data, encoding: .utf8) else { return }
        let transcript = Transcript(message: message, peerID: peerID, direction: .receive)
        delegate?.sessionContainer(received: transcript)
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

    // Received a byte stream from remote peer.
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print(#function)
    }

    // Made first contact with peer and have identity information about the
    // remote peer (certificate may be nil).
    //    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Swift.Void) {
    //        print(#function)
    //        print(certificate)
    //    }

}
