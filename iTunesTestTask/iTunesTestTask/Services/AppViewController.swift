//
//  AppViewController.swift
//  iTunesTestTask
//
//  Created by Кирилл Клименков on 7/14/20.
//  Copyright © 2020 Kirill Klimenkov. All rights reserved.
//

import UIKit

enum AppViewController {
    case media
    case favorite
    
    var viewController: UIViewController {
        var navigationController: UINavigationController
        switch self {
        case .media:
            let mediaViewController = MediaViewController(nib: R.nib.mediaViewController)
            navigationController = UINavigationController(rootViewController: mediaViewController)
            navigationController.navigationBar.topItem?.title = R.string.localizable.mediaTitle()
            
            let tabItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)
            navigationController.tabBarItem = tabItem
            
        case .favorite:
            let favoriteViewController = FavoriteViewController(nib: R.nib.favoriteViewController)
            navigationController = UINavigationController(rootViewController: favoriteViewController)
            navigationController.navigationBar.topItem?.title = R.string.localizable.favoriteTitle()
            
            let tabItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
            navigationController.tabBarItem = tabItem
        }
        return navigationController
    }
}
