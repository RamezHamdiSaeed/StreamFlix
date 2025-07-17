//
//  RandomMoviePreviewView.swift
//  StreamFlix
//
//  Created by Macbook on 23/05/2025.
//

import UIKit
import SwiftUI

class RandomMoviePreviewView: UIView {
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var gradiantLayerView: UIView!
    @IBOutlet weak var moviePlayButton: UIButton!
    @IBOutlet weak var movieDownlaodButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupUI() {
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor,
                                UIColor.clear.cgColor,
                                UIColor.systemBackground.cgColor]
        gradientLayer.frame = bounds
        self.gradiantLayerView.layer.addSublayer(gradientLayer)
        self.setupButton(button: self.moviePlayButton)
        self.setupButton(button: self.movieDownlaodButton)
    }
    func setupButton(button: UIButton) {
        button.tintColor = .white
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
    }
    
    static func loadViewFromNib() -> RandomMoviePreviewView {
        return UINib(nibName: "RandomMoviePreviewView", bundle: nil).instantiate(withOwner: self, options: .none).first as! RandomMoviePreviewView
    }
    
}

//class PreviewViewController : UIViewController {
//    private var viewPreview: RandomMoviePreviewView = {
//        return RandomMoviePreviewView(frame: .zero)
//    }()
//    
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        viewPreview.frame = view.frame
//        viewPreview = RandomMoviePreviewView.loadViewFromNib()
//        view.addSubview(viewPreview)
//    }
//    
//}
//
//struct RandomMoviePreviewViewRepresentable: UIViewControllerRepresentable {
//    
//    typealias UIViewControllerType = PreviewViewController
//
//    func makeUIViewController(context: Context) -> PreviewViewController {
//        return PreviewViewController()
//    }
//    
//    func updateUIViewController(_ uiViewController: PreviewViewController, context: Context) {
//        
//    }
//        
//}
//
//struct RandomMoviePreviewViewRepresentable_Preview: PreviewProvider {
//    static var previews: some View {
//        RandomMoviePreviewViewRepresentable()
//    }
//}
