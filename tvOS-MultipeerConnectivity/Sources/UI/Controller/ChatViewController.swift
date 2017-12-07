//
//  ViewController.swift
//  tvOS-MultipeerConnectivity
//
//  Created by hryk224 on 2017/12/10.
//  Copyright © 2017年 hryk224. All rights reserved.
//

import MultipeerConnectivity
import UIKit

final class ChatViewController: UIViewController {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var textField: UITextField! {
        didSet {
            textField.isHidden = true
            textField.delegate = self
        }
    }

    private let sessionContainer: SessionContainer = {
        return .init(displayName: Const.displayName, serviceType: Const.serviceType)
    }()

    @IBAction func browseForPeers(_ sender: UIBarButtonItem) {
        let browserViewController: MCBrowserViewController = .init(serviceType: Const.serviceType, session: sessionContainer.session)
        browserViewController.delegate = self
        browserViewController.minimumNumberOfPeers = kMCSessionMinimumNumberOfPeers
        browserViewController.maximumNumberOfPeers = kMCSessionMaximumNumberOfPeers
        present(browserViewController, animated: true, completion: nil)
    }

    @IBAction func sendMessageTrigger(_ sender: UIBarButtonItem) {
        textField.becomeFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        sessionContainer.delegate = self
        title = ""
    }

    func insertTranscript(_ transcript: Transcript) {
        DispatchQueue.main.async {
            let messageView = ChatMessageView.makeFromNib()
            messageView.insertTranscript(transcript)
            self.stackView.addArrangedSubview(messageView)
        }
    }
}

// MARK: - UITextFieldDelegate
extension ChatViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let message = textField.text, !message.isEmpty else {
            return true
        }

        let transcript = sessionContainer.sendMessage(message)
        insertTranscript(transcript)

        textField.resignFirstResponder()
        textField.text = ""

        return true
    }

}

// MARK: - SessionContainerDelegate
extension ChatViewController: SessionContainerDelegate {

    func sessionContainer(received transcript: Transcript) {
        insertTranscript(transcript)
    }

}

// MARK: - MCBrowserViewControllerDelegate
extension ChatViewController: MCBrowserViewControllerDelegate {

    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true, completion: nil)
    }

    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true, completion: nil)
    }

    func browserViewController(_ browserViewController: MCBrowserViewController, shouldPresentNearbyPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) -> Bool {
        return true
    }

}
