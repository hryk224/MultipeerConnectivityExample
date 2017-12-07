//
//  CaptureReceiverViewController.swift
//  iOS-MultipeerConnectivity
//
//  Created by hryk224 on 2017/12/10.
//  Copyright © 2017年 hryk224. All rights reserved.
//

import MultipeerConnectivity
import UIKit

final class CaptureReceiverViewController: UIViewController {

    @IBOutlet fileprivate weak var imageView: UIImageView!

    private let sessionContainer: SessionContainer2 = {
        return .init(displayName: Const.displayName, serviceType: Const.serviceType)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        sessionContainer.delegate = self
        title = ""
    }
}

// MARK: - SessionContainerDelegate
extension CaptureReceiverViewController: SessionContainer2Delegate {

    func sessionContainer(received capture: Capture) {
        DispatchQueue.main.async {
            self.imageView.image = capture.image
        }
    }

}
