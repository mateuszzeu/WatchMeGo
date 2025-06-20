//
//  PodiumAllyDetailsViewController.swift
//  WatchMeGo
//
//  Created by Liza on 20/06/2025.
//

import UIKit

class PodiumAllyDetailsViewController: UIViewController {
    
    private let detailsView = PodiumAllyDetailsView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view = detailsView
    }
}
