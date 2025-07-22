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
    @IBOutlet weak var favoriteButton: UIButton!
    static let identifier = "TitleCollectionViewCell"
    var movie: Movie?
    var viewModel: RowViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
     func setupUI() {
        guard let posterPath = movie?.posterPath else  { return }
        let imageUrl = "\(Constants.imageBaseURL)\(posterPath)"
        if let url = URL(string: imageUrl) {
            imageView.sd_setImage(with: url, completed: nil)
        }
         self.titleLabel.text = movie?.title ?? "unknown"
         self.releaseDateLabel.text = movie?.releaseDate ?? "unknown"
         self.rateLabel.text = "\(String(format: "%.1f", movie?.voteAverage ?? 0))"
         self.favoriteButton.layer.cornerRadius = 12
         self.layer.cornerRadius = 12
    }
    
    @IBAction func favoriteTapped(_ sender: UIButton) {
        
    }

}

extension TitleCollectionViewCell: RowViewCell {
    func setup(with viewModel: (any RowViewModel)?) {
        if let viewModel = viewModel as? TitleCollectionViewCellViewModel {
            self.viewModel = viewModel
            self.movie = viewModel.movie
            self.setupUI()
        }
    }
}
