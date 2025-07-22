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
    var viewModel: RowViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCollectionView()
    }
    
    func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: TitleCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
    }
    func setupUI(){
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension CollectionViewTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let viewModel = self.viewModel as? CollectionViewTableViewCellViewModel {
            return viewModel.sectionViewModels?[section].rowViewModels.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let viewModel = self.viewModel as? CollectionViewTableViewCellViewModel {
            let row = viewModel.sectionViewModels?[indexPath.section].rowViewModels[indexPath.item]
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: row?.cellIdentifier() ?? "", for: indexPath) as? RowViewCell {
                cell.setup(with: row)
                return cell as? UICollectionViewCell ?? UICollectionViewCell()
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 120, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let viewModel = self.viewModel as? CollectionViewTableViewCellViewModel {
            let row = viewModel.sectionViewModels?[indexPath.section].rowViewModels[indexPath.item]
            if let rowIsPresssible = row as? CellPressible {
                rowIsPresssible.cellPressed()
            }
        }
    }
    
}

extension CollectionViewTableViewCell: RowViewCell {
    func setup(with viewModel: (any RowViewModel)?) {
        if let viewModel = viewModel as? CollectionViewTableViewCellViewModel {
            self.viewModel = viewModel
            self.movies = viewModel.movies
            viewModel.buildViewModels()
            self.setupUI()
        }
    }
}
