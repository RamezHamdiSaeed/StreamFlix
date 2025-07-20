//
//  TitleCollectionViewCell.swift
//  StreamFlix
//
//  Created by ramez Hamdy on 16/06/2025.
//

import UIKit
import SDWebImage
class TitleCollectionViewCell: UICollectionViewCell {
    static let identifier = "TitleCollectionViewCell"
    var movie: Movie?
    var viewModel: RowViewModel?
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
     func setupUI() {
        guard let posterPath = movie?.posterPath else  { return }
        let imageUrl = "\(Constants.imageBaseURL)\(posterPath)"
        if let url = URL(string: imageUrl) {
            imageView.sd_setImage(with: url, completed: nil)
        }
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
