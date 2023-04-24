//
//  ViewController.swift
//  InvioRickAndMorty
//
//  Created by Furkan Deniz Albaylar on 18.04.2023.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {

    @IBOutlet weak var rickandmortyImageView: UIImageView!
    @IBOutlet weak var charTableView: UITableView!
    @IBOutlet weak var locationCollectionView: UICollectionView!

    private var selectedIndexPath: IndexPath?
    private var selectedLocationId: Int?
    private var selectedLocation : [Location] = []
    
    private var locations: [Location] = []
    private var characters: [Character] = []
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        setUpTableView()
        setUpCollectionView()
        setLocations()
 
        
    }

    private func setUpCollectionView() {
        locationCollectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        locationCollectionView.delegate = self
        locationCollectionView.dataSource = self
    }

    private func setUpTableView() {
        charTableView.delegate = self
        charTableView.dataSource = self
        charTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let location = locations[indexPath.row]
        let selectedLocation = location.id
        print("Selected Location: \(location.name)")
        
        if selectedIndexPath == indexPath {
            // If user tapped on the same cell again, we don't need to fetch data again
            return
        }
        
        selectedIndexPath = indexPath
        
        if location.residents.isEmpty {
            showError("No residents found.")
        } else {
            setSelectedLocation(for: selectedLocation) // Seçilen lokasyonu güncelle
        }
        
        collectionView.reloadData()
        
    }
}



extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locations.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        collectionCell.layer.borderWidth = 5
        collectionCell.layer.cornerRadius = 20

        let loc = locations[indexPath.row]

        collectionCell.configure(with: locationModel(name: loc.name))

        // Seçilen hücrenin kenarlığını kırmızı yap
        if selectedIndexPath == indexPath {
            collectionCell.layer.borderColor = UIColor.red.cgColor
        } else {
            collectionCell.layer.borderColor = UIColor.darkGray.cgColor
        }

        return collectionCell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let character = characters[indexPath.row]
            let detailVC = DetailViewController()
        detailVC.detail = character // Seçilen karakteri DetailViewController'a aktarın
            navigationController?.pushViewController(detailVC, animated: true) 
            
   
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        let character = characters[indexPath.row]
        let model = TableViewCell.CharacterModel(image: character.image, name: character.name)
        cell.configure(with: model)

        return cell
    }

}
extension HomeViewController {
    
    private func setLocations() {
        NetworkManager.shared.getLocations { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let locations):
                self.locations = locations
                
                // Set the default location to the previously selected location
                if let selectedLocationId = self.selectedLocationId {
                    self.setSelectedLocation(for: selectedLocationId)
                } else {
                    self.locationCollectionView.reloadData()
                }
                
            case .failure(let error):
                print(error)
                self.showError(error.localizedDescription)
            }
        }
    }
    
    
    func setSelectedLocation(for locationID: Int) {
        NetworkManager.shared.getLocation(id: locationID) { [weak self] result in
            switch result {
            case .success(let locations):
                // Seçilen konumu alın
                guard let selectedLocation = locations.first else {
                    print("Selected location not found.")
                    return
                }
                
                
                let residentURLs = selectedLocation.residents
                print(residentURLs)
                let residentIDs = residentURLs.compactMap({Int($0.split(separator: "/").last ?? "")})
                print(residentIDs)
                //let residentIDStrings = residentIDs.map { String($0) }
                var residentIDStrings: String = ""
                              residentIDs.forEach { residentId in
                                if residentIDs.first == residentId {
                                  residentIDStrings = "[\(residentId)"
                                }else {
                                  residentIDStrings = "\(residentIDStrings),\(residentId)"
                                }
                              }
                              residentIDStrings = "\(residentIDStrings)]"
                
                //let lastURL = "https://rickandmortyapi.com/api/character/\(residentIDs)"
                //print(lastURL)

                
                // Karakterleri alma isteği oluştur
                NetworkManager.shared.getMultipleCharacters(ids: residentIDStrings) { result in
                    switch result {
                    case .success(let characterResponse):
                        
                        let characters = characterResponse
                        self?.characters = characters 
                        
                        // Reload the table view data to display the character information
                        DispatchQueue.main.async {
                            self?.charTableView.reloadData()
                        }
                        
                        print("Characters in \(selectedLocation.name):")
                        for character in self?.characters ?? [] {
                            print(character.name)
                        }
                        
                    case .failure(let error):
                        print("Error fetching character details: \(error.localizedDescription)")
                        // Handle the error here
                    }
                }
                
            case .failure(let error):
                print(error)
                self?.showError(error.localizedDescription)
            }
        }
    }
}
