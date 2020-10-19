//
//  UIApplication.swift
//  MyPodcastApp
//
//  Created by Pradeep Gianchandani on 16/10/20.
//

import UIKit

extension UIApplication {
    static func mainTabBarController() -> MainTabBarController? {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        return window?.rootViewController as? MainTabBarController
    }
}
