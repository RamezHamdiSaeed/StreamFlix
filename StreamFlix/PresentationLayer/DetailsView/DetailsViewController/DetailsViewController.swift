//
//  DetailsViewController.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 22/07/2025.
//

import UIKit

class DetailsViewController: UIViewController {
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var language: UILabel!
    @IBOutlet weak var detailsSectionView: UIView!
    
    var viewModel: DetailsViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func favoriteTapped(_ sender: UIButton) {
        
    }
}
