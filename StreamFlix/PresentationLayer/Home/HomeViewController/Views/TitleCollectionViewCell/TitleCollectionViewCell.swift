//
//  TitleCollectionViewCell.swift
//  StreamFlix
//
//  Created by ramez Hamdy on 16/06/2025.
//

import UIKit
import SDWebImage
class TitleCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var favoriteUnFavoritButton: UIButton!
    static let identifier = "TitleCollectionViewCell"
    var viewModel: RowViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
     func setupUI() {
         if let viewModel = self.viewModel as? TitleCollectionViewCellViewModel {
             guard let posterPath = viewModel.movie.posterPath else  { return }
             let imageUrl = "\(Constants.imageBaseURL)\(posterPath)"
             if let url = URL(string: imageUrl) {
                 imageView.sd_setImage(with: url, completed: nil)
             }
             self.titleLabel.text = viewModel.movie.title ?? "unknown"
             self.releaseDateLabel.text = viewModel.movie.releaseDate ?? "unknown"
             self.rateLabel.text = "\(String(format: "%.1f", viewModel.movie.voteAverage ?? 0))"
              self.favoriteUnFavoritButton.layer.cornerRadius = 12
              self.layer.cornerRadius = 12
         }
    }
    
    func setupBinding() {
        if let viewModel = self.viewModel as? TitleCollectionViewCellViewModel {
            viewModel.isFavorite.addObserver(isFiringNow: false) { [weak self] isFavorite in
                if isFavorite {
                    self?.favoriteButtonUI()
                } else {
                    self?.unFavoriteButtonUI()
                }
            }
        }
    }
    
    func unFavoriteButtonUI() {
        self.favoriteUnFavoritButton.setImage(UIImage(systemName: "heart"), for: .normal)
    }
    
    func favoriteButtonUI() {
        self.favoriteUnFavoritButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
    }
    
    @IBAction func favoriteUnFavoritTapped(_ sender: UIButton) {
        if let viewModel = self.viewModel as? TitleCollectionViewCellViewModel {
            if viewModel.isFavorite.value {
                viewModel.unFavoriteMovie()
            } else {
                viewModel.favoriteMovie()
            }
        }
    }

}

extension TitleCollectionViewCell: RowViewCell {
    func setup(with viewModel: (any RowViewModel)?) {
        if let viewModel = viewModel as? TitleCollectionViewCellViewModel {
            self.viewModel = viewModel
            self.setupBinding()
            self.setupUI()
            viewModel.isFavoriteMovie()
        }
    }
}
