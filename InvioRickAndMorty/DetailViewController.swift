//
//  DetailViewController.swift
//  InvioRickAndMorty
//
//  Created by Furkan Deniz Albaylar on 24.04.2023.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {

    @IBOutlet weak var detailGender: UILabel!
    @IBOutlet weak var detailName: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
    var detail: Character?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateData()

        // Do any additional setup after loading the view.
    }
    
    func updateData(){
        detailName.text = "Name : \(detail?.name ?? "")"
        detailGender.text = "Gender : \(detail?.gender ?? "")"
        
        
        // Pokemon verisinin yetenekleri varsa bunları bir dizi olarak birleştiririz ve abiltyName değişkenine atarız.Compact mapi kullanmamızın nedeni Optional değerleri filtrelemek ve dizideki nil değerleri çıkarmak için kullanıyoruz.


        
        //detailImageView.kf.setImage(with: detail?.image)
        
    }

}

