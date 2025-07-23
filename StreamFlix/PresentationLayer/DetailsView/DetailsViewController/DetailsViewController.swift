//
//  DetailsViewController.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 22/07/2025.
//

import UIKit
import SDWebImage
import Combine

class DetailsViewController: UIViewController {
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var language: UILabel!
    @IBOutlet weak var detailsSectionView: UIView!
    @IBOutlet weak var favoriteUnFavoritButton: UIButton!
    
    var viewModel: DetailsViewModel?
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewModel?.isFavoriteMovie()
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

    
    func setupBinding() {
        self.viewModel?.$isFavorite.receive(on: DispatchQueue.main).dropFirst().sink { [weak self] isFavorite in
                if isFavorite {
                    self?.favoriteButtonUI()
                } else {
                    self?.unFavoriteButtonUI()
                }
            }
        .store(in: &cancellables)
    }
    
    func unFavoriteButtonUI() {
        self.favoriteUnFavoritButton.setImage(UIImage(systemName: "heart"), for: .normal)
    }
    
    func favoriteButtonUI() {
        self.favoriteUnFavoritButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
    }
    
    @IBAction func favoriteTapped(_ sender: UIButton) {
        if self.viewModel?.isFavorite ?? false {
                viewModel?.unFavoriteMovie()
            } else {
                viewModel?.favoriteMovie()
            }
        
    }
}
