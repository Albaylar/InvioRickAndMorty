//
//  TableViewCell.swift
//  InvioRickAndMorty
//
//  Created by Furkan Deniz Albaylar on 18.04.2023.
//

import UIKit
import Kingfisher

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var charLabel: UILabel!
    @IBOutlet weak var charImage: UIImageView!
    @IBOutlet weak var genderImage: UIImageView!
    
    var button: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    func configure(with model: CharacterModel) {
        charLabel.text = model.name
        if let imageUrl = model.image {
            charImage.kf.setImage(with: imageUrl)
        }
    }

    struct CharacterModel {
        let image: URL?
        let name: String?
        let gender : String?
    }
}
