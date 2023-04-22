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
        let selectedLocation = locations[indexPath.row]
        print("Selected Location: \(selectedLocation.name)")
        
        if selectedIndexPath == indexPath {
            // If user tapped on the same cell again, we don't need to fetch data again
            return
        }
        
        selectedIndexPath = indexPath
        
        if selectedLocation.residents.isEmpty {
            showError("No residents found.")
        } else {
            setSelectedLocation(for: selectedLocation.id) // Seçilen lokasyonu güncelle
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
            let char = characters[indexPath.row]
            print("Selected Character: \(char.name)")
   
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        let character = characters[indexPath.row]
        let model = TableViewCell.CharacterModel(image: URL(string: character.image), name: character.name)
        cell.configure(with: model)

        return cell
    }
}
extension HomeViewController {
    private func setLocations() {
            NetworkManager.shared.getLocations { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let apiData):
                    let locations = apiData.results ?? []
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

        
    private func getCharacters(for location: Location) {
        characters = []

        let residentUrls = location.residents.map { URL(string: $0) }

        let validUrls = residentUrls.compactMap { $0 }

        let residentIds = validUrls.map { $0.lastPathComponent }.joined(separator: ",")

        NetworkManager.shared.getCharacters(from: residentIds) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let apiData):
                let characters = apiData.results ?? []

                self.characters = characters

                DispatchQueue.main.async {
                    self.charTableView.reloadData()
                }
            case .failure(let error):
                print(error)
                self.showError(error.localizedDescription)
            }
        }
    }

    private func setSelectedLocation(for locationId: Int) {
        let selectedLocation = locations.first { $0.id == locationId }
        self.selectedLocationId = selectedLocation?.id
        
        if let selectedLocation = selectedLocation {
            self.selectedLocation = [selectedLocation]
            getCharacters(for: selectedLocation)
        } else {
            self.selectedLocation = []
            characters = []
            charTableView.reloadData()
        }
    }


}

