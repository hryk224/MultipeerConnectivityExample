//
//  SessionContainer2.swift
//  tvOS-MultipeerConnectivity
//
//  Created by hryk224 on 2017/12/10.
//  Copyright © 2017年 hryk224. All rights reserved.
//

import CoreMedia
import Foundation
import MultipeerConnectivity
import ReplayKit

final class SessionContainer2: NSObject {

    let session: MCSession

    private let displayName: String
    // ホスト
    private let peerID = MCPeerID(displayName: Const.displayName)
    private(set) lazy var nearbyServiceBrowser: MCNearbyServiceBrowser = {
        return MCNearbyServiceBrowser(peer: self.peerID, serviceType: Const.serviceType)
    }()

    // MARK: - Queued for Buffer
    private let bufferQueue: DispatchQueue = {
        let queue = DispatchQueue(label: "jp.hryk224.bufferQueue")
        return queue
    }()

    init(displayName: String, serviceType: String) {
        self.displayName = displayName

        session = MCSession(peer: peerID)

        super.init()

        nearbyServiceBrowser.delegate = self
    }

    deinit {
        RPScreenRecorder.shared().stopCapture(handler: nil)
        nearbyServiceBrowser.stopBrowsingForPeers()
        session.disconnect()
    }

    func startCapture() {
        RPScreenRecorder.shared().startCapture(handler: { [weak self] (sampleBuffer: CMSampleBuffer, _, error) in
            guard let me = self, error == nil else { return }
            me.bufferQueue.async { [weak self] in
                guard let me = self else { return }
                guard let image = self?.makeImage(fromCMSampleBuffer: sampleBuffer),
                    let data = UIImageJPEGRepresentation(image, 1) else {
                    return
                }
                try? me.session.send(data, toPeers: me.session.connectedPeers, with: .reliable)
            }
        }, completionHandler: nil)
    }

    private func makeImage(fromCMSampleBuffer buffer: CMSampleBuffer)-> UIImage? {
        guard let imageBuffer: CVImageBuffer = CMSampleBufferGetImageBuffer(buffer) else {
            return nil
        }
        let ciImage = CIImage(cvImageBuffer: imageBuffer)
        let pixelBufferWidth = CGFloat(CVPixelBufferGetWidth(imageBuffer))
        let pixelBufferHeight = CGFloat(CVPixelBufferGetHeight(imageBuffer))
        let imageRect = CGRect(x: 0 ,y: 0 , width: pixelBufferWidth, height: pixelBufferHeight)
        let ciContext = CIContext()
        guard let cgimage = ciContext.createCGImage(ciImage, from: imageRect) else {
            return nil
        }
        let image = UIImage(cgImage: cgimage)
        return image
    }
}

// MARK: - MCBrowserViewControllerDelegate
extension SessionContainer2: MCNearbyServiceBrowserDelegate {

    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("\(#function) \(peerID.displayName))")
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 30)
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print(#function)
    }

    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print(#function)
    }

}
