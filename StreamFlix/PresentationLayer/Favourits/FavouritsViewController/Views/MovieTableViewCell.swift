//
//  MovieTableViewCell.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 26/07/2025.
//

import UIKit
import Combine

class MovieTableViewCell: UITableViewCell, RowViewCell {
    static let identifier = "MovieTableViewCell"
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var favoriteUnFavoritButton: UIButton!

    var viewModel: RowViewModel?
    var cancellables = Set<AnyCancellable>()

    func setupBinding() {
        if let viewModel = self.viewModel as? MovieTableViewModel {
            viewModel.$isFavorite.receive(on: DispatchQueue.main).dropFirst().sink { [weak self] isFavorite in
                if isFavorite {
                    self?.favoriteButtonUI()
                } else {
                    self?.unFavoriteButtonUI()
                }
            }
            .store(in: &cancellables)
        }
    }

    func setupUI() {
        if let viewModel = self.viewModel as? MovieTableViewModel {
            guard let posterPath = viewModel.movie.posterPath else { return }
            let imageUrl = "\(Constants.imageBaseURL)\(posterPath)"
            if let url = URL(string: imageUrl) {
                posterImageView.sd_setImage(with: url, completed: nil)
            }
            self.titleLabel.text = viewModel.movie.title ?? "unknown"
            self.releaseDateLabel.text = viewModel.movie.releaseDate ?? "unknown"
            self.rateLabel.text = "\(String(format: "%.1f", viewModel.movie.voteAverage ?? 0))"
             self.favoriteUnFavoritButton.layer.cornerRadius = 12
             self.layer.cornerRadius = 12
        }
   }

    func unFavoriteButtonUI() {
        self.favoriteUnFavoritButton.setImage(UIImage(systemName: "heart"), for: .normal)
    }

    func favoriteButtonUI() {
        self.favoriteUnFavoritButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
    }

    @IBAction func favoriteTapped(_ sender: UIButton) {
        if let viewModel = self.viewModel as? MovieTableViewModel {
            if viewModel.isFavorite {
                viewModel.unFavoriteMovie()
            } else {
                viewModel.favoriteMovie()
            }
        }
    }

    func setup(with viewModel: (any RowViewModel)?) {
        if let viewModel = viewModel as? MovieTableViewModel {
            self.viewModel = viewModel
            self.setupBinding()
            self.setupUI()
            viewModel.isFavoriteMovie()
        }
    }
}
