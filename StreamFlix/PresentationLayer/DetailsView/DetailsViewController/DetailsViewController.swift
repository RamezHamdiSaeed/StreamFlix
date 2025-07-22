//
//  DetailsViewController.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 22/07/2025.
//

import UIKit
import SDWebImage

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
        self.setupUI()
    }
    
    func setupUI() {
        self.detailsSectionView.layer.cornerRadius = 25
        self.language.text = self.viewModel?.movie.originalLanguage?.uppercased() ?? ""
        self.overviewLabel.text = self.viewModel?.movie.overview ?? "UnKnown"
        self.releaseDateLabel.text = self.viewModel?.movie.releaseDate ?? "UnKnows"
        let imageUrl = "\(Constants.imageBaseURL)\(self.viewModel?.movie.posterPath ?? "")"
        if let url = URL(string: imageUrl) {
            self.posterImageView.sd_setImage(with: url)
        }
        self.titleLabel.text = self.viewModel?.movie.title ?? "UnKnown"
        self.ratingLabel.text = "\(String(format: "%.1f", self.viewModel?.movie.voteAverage ?? 0))"
    }

    @IBAction func favoriteTapped(_ sender: UIButton) {
        
    }
}
