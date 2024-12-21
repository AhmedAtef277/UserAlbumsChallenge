//
//  UIViewController + Extension.swift
//  UserAlbumsChallenge
//
//  Created by mac on 21/12/2024.
//

import UIKit

protocol ViewControllerType {
    func push(viewController: UIViewController, animated: Bool)
}

extension UIViewController: ViewControllerType {
    func push(viewController: UIViewController, animated: Bool) {
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
}
