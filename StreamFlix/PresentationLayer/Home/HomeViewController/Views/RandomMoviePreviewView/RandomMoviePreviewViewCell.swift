//
//  RandomMoviePreviewView.swift
//  StreamFlix
//
//  Created by Macbook on 23/05/2025.
//

import UIKit
import SDWebImage

class RandomMoviePreviewViewCell: UITableViewCell, RowViewCell {
    
    static let identifier = "RandomMoviePreviewViewCell"
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var gradiantLayerView: UIView!
    @IBOutlet weak var moviePlayButton: UIButton!
    @IBOutlet weak var movieFavouritButton: UIButton!
    var viewModel: RowViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupUI(with imageUrl: String) {
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor,
                                UIColor.clear.cgColor,
                                UIColor.systemBackground.cgColor]
        gradientLayer.frame = bounds
        self.gradiantLayerView.layer.addSublayer(gradientLayer)
        self.setupButton(button: self.moviePlayButton)
        self.setupButton(button: self.movieFavouritButton)
        self.setupImage(with: imageUrl)
    }
    
    func setupImage(with imageUrl: String) {
        let imageUrl = "\(Constants.imageBaseURL)\(imageUrl)"
        if let url = URL(string: imageUrl) {
            movieImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    func setupButton(button: UIButton) {
        button.tintColor = .white
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
    }
    
    func setup(with viewModel: (any RowViewModel)?) {
        if let viewModel = viewModel as? RandomMoviePreviewViewModel {
            self.viewModel = viewModel
            self.setupUI(with: viewModel.randomMovie.posterPath ?? "")
        }
    }
}
