//
//  PodiumRivalDetailsViewController.swift
//  WatchMeGo
//
//  Created by Liza on 20/06/2025.
//

import UIKit

class PodiumRivalDetailsViewController: UIViewController {
    
    private let detailsView = PodiumRivalDetailsView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view = detailsView
    }
}
