//
//  MessageContextMenuWindow.swift
//  WiseChat GPT
//
//  Created by Md Murad Hossain on 6/3/23.
//

import UIKit

final class MessageContextMenuWindow: UIWindow {
    override var windowLevel: UIWindow.Level {
        get {
            return UIWindow.Level(rawValue: CGFloat.greatestFiniteMagnitude - 1)
        }
        set { }
    }
}

extension MessageContextMenuWindow: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
