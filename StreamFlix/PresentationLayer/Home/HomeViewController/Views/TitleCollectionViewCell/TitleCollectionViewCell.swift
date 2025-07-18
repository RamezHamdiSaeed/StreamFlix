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
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    public func configure(with movie: Movie) {
        guard let posterPath = movie.posterPath else  { return }
        let imageUrl = "\(Constants.imageBaseURL)\(posterPath)"
        if let url = URL(string: imageUrl) {
            imageView.sd_setImage(with: url, completed: nil)
        }
    }

}
