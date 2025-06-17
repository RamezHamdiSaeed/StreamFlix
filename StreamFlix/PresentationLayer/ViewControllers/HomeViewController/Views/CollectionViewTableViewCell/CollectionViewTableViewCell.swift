//
//  CollectionViewTableViewCell.swift
//  StreamFlix
//
//  Created by ramez Hamdy on 16/06/2025.
//

import UIKit

class CollectionViewTableViewCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    static let identifier = "CollectionViewTableViewCell"
    var movies = [Movie]()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setupUI()
    }

    func setupUI() {
        self.setupCollectionView()
    }
    func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: TitleCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
    }
    public func configure(with movies: [Movie]){
        self.movies = movies
        DispatchQueue.main.async{
            self.collectionView.reloadData()
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension CollectionViewTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell {
            cell.configure(with: movies[indexPath.item])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 100, height: 150)
    }
    
}
