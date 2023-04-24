//
//  DetailViewController.swift
//  InvioRickAndMorty
//
//  Created by Furkan Deniz Albaylar on 24.04.2023.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var specyLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var episodesLabel: UILabel!
    @IBOutlet weak var createdAtAPI: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
    var detail: DetailResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setView()
    }
    
    func setView() {
        configure(with: DetailModel(id: detail?.id, name: detail?.name, status: detail?.status, species: detail?.species, type: detail?.type, gender: detail?.gender, image: detail?.image, episode: detail?.episode, url: detail?.url, created: detail?.created))
    }

    func configure(with model: DetailModel) {
        let boldFont = UIFont.boldSystemFont(ofSize: 17)
        let regularFont = UIFont.systemFont(ofSize: 17)
        
        let statusAttributedText = NSMutableAttributedString(string: "Status: ", attributes: [NSAttributedString.Key.font: boldFont])
        statusAttributedText.append(NSAttributedString(string: "\(model.status ?? "")", attributes: [NSAttributedString.Key.font: regularFont]))
        statusLabel.attributedText = statusAttributedText
        
        let genderAttributedText = NSMutableAttributedString(string: "Gender: ", attributes: [NSAttributedString.Key.font: boldFont])
        genderAttributedText.append(NSAttributedString(string: "\(model.gender ?? "")", attributes: [NSAttributedString.Key.font: regularFont]))
        genderLabel.attributedText = genderAttributedText
        
        let speciesAttributedText = NSMutableAttributedString(string: "Species: ", attributes: [NSAttributedString.Key.font: boldFont])
        speciesAttributedText.append(NSAttributedString(string: "\(model.species ?? "")", attributes: [NSAttributedString.Key.font: regularFont]))
        specyLabel.attributedText = speciesAttributedText
        
        let createdAtDate = formatDate(dateString: model.created ?? "")
                let createdAtAttributedText = NSMutableAttributedString(string: "Created: ", attributes: [NSAttributedString.Key.font: boldFont])
                createdAtAttributedText.append(NSAttributedString(string: "\(createdAtDate)", attributes: [NSAttributedString.Key.font: regularFont]))
                createdAtAPI.attributedText = createdAtAttributedText
        nameLabel.text = model.name
        
        
        // originLabel.text = "Origin: \(model.origin?.name ?? "")"
        // locationLabel.text = "Location: \(model.location?.name ?? "")"
        
        if let episodeList = model.episode, !episodeList.isEmpty {
            let episodeNumbers = episodeList.map { $0.components(separatedBy: "/").last ?? "" }
            let episodesAttributedText = NSMutableAttributedString(string: "Episodes: ", attributes: [NSAttributedString.Key.font: boldFont])
            episodesAttributedText.append(NSAttributedString(string: "\(episodeNumbers.joined(separator: ", "))", attributes: [NSAttributedString.Key.font: regularFont]))
            episodesLabel.attributedText = episodesAttributedText
        } else {
            episodesLabel.text = ""
        }
        
        if let imageUrl = URL(string: model.image ?? "") {
            detailImageView.kf.setImage(with: imageUrl)
        }
        func formatDate(dateString: String) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if let date = dateFormatter.date(from: dateString) {
                dateFormatter.dateFormat = "dd MMM yyyy, HH:mm:ss"
                return dateFormatter.string(from: date)
            } else {
                return ""
            }
        }

        
    }


}

struct DetailModel {
    let id: Int?
    let name, status, species, type: String?
    let gender: String?
    
    let image: String?
    let episode: [String]?
    let url: String?
    let created: String?
}

struct LocationChar: Codable {
    let name: String?
    let url: String?
}




