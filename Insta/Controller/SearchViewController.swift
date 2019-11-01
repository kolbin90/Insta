//
//  SearchViewController.swift
//  Insta
//
//  Created by Apple User on 11/1/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    var searchBar = UISearchBar()
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search"
        searchBar.frame.size.width = view.frame.size.width - 60
        let searchItem = UIBarButtonItem(customView: searchBar)
        navigationItem.rightBarButtonItem = searchItem
    }


}
