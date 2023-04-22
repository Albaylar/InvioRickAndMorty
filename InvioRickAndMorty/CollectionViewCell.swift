//
//  CollectionViewCell.swift
//  InvioRickAndMorty
//
//  Created by Furkan Deniz Albaylar on 18.04.2023.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var collectionCellButton: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    private let collectionView = HomeViewController()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configure(with model : locationModel) {
        locationLabel.text = model.name
        
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        
    }
    
}
struct locationModel {
    let name : String?
}
