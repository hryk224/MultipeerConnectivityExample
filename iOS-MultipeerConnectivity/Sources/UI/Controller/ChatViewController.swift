//
//  ViewController.swift
//  iOS-MultipeerConnectivity
//
//  Created by hryk224 on 2017/12/10.
//  Copyright © 2017年 hryk224. All rights reserved.
//

import MultipeerConnectivity
import Photos
import UIKit

final class ChatViewController: UIViewController, KeyboardObservable {

    var keyboardObservers: [Any] = []

    @IBOutlet weak var textField: UITextField!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet fileprivate weak var toolBarBottomConstraint: NSLayoutConstraint!

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

    @IBAction func sendMessage(_ sender: UIBarButtonItem) {
        guard let message = textField.text, !message.isEmpty else {
            return
        }

        let transcript = sessionContainer.sendMessage(message)
        insertTranscript(transcript)

        textField.resignFirstResponder()
        textField.text = ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        sessionContainer.delegate = self
        title = ""
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        addKeyboardObservers()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        removeKeyboardObservers()
    }

    func insertTranscript(_ transcript: Transcript) {
        DispatchQueue.main.async {
            let messageView = ChatMessageView.makeFromNib()
            messageView.insertTranscript(transcript)
            self.stackView.addArrangedSubview(messageView)
        }
    }
}

// MARK: - KeyboardObservable
extension ChatViewController {

    func keyboardWillShow(_ notification: Notification) {
        toolBarBottomConstraint.constant = -((notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0)
        UIView.animate(withDuration: 0.3, animations: view.layoutIfNeeded)
    }

    func keyboardDidShow(_ notification: Notification) {}

    func keyboardWillHide(_ notification: Notification) {
        toolBarBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3, animations: view.layoutIfNeeded)
    }

    func keyboardDidHide(_ notification: Notification) {}

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
