//
//  ChatMessageView.swift
//  tvOS-MultipeerConnectivity
//
//  Created by hryk224 on 2017/12/10.
//  Copyright © 2017年 hryk224. All rights reserved.
//

import UIKit

final class ChatMessageView: UIView {

    static func makeFromNib() -> ChatMessageView {
        let nib = UINib(nibName: "ChatMessageView", bundle: Bundle(for: self))
        return nib.instantiate(withOwner: self, options: nil)[0] as! ChatMessageView
    }

    @IBOutlet private weak var messageButton: UIButton! {
        didSet {
            messageButton.isHidden = true
        }
    }
    @IBOutlet weak var selfMessageButton: UIButton! {
        didSet {
            selfMessageButton.isHidden = true
        }
    }

    private var buttonWidth: CGFloat {
        return UIScreen.main.bounds.width - 80
    }

    override var canBecomeFocused: Bool {
        return true
    }

    func insertTranscript(_ transcript: Transcript) {
        switch transcript.direction {
        case .send:
            selfMessageButton.setTitle(transcript.message, for: [])
            selfMessageButton.isHidden = false
            let height = selfMessageButton.sizeThatFits(.init(width: buttonWidth, height: .leastNonzeroMagnitude)).height
            heightAnchor.constraint(equalToConstant: height).isActive = true
        case .receive, .local:
            messageButton.setTitle(transcript.message, for: [])
            messageButton.isHidden = false
            let height = messageButton.sizeThatFits(.init(width: buttonWidth, height: .leastNonzeroMagnitude)).height
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}
