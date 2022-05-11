//
//  HourlyTableViewCell.swift
//  MyWeather
//
//  Created by amr on 24/04/2022.
//

import UIKit

class HourlyTableViewCell: UITableViewCell, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout  {
    
    
    
    

    @IBOutlet var CollectionView : UICollectionView!
    
    
    var models = [HourlyWeather]()
    override func awakeFromNib() {
        super.awakeFromNib()
        CollectionView.register(WeatherCollectionViewCell.nib(), forCellWithReuseIdentifier: WeatherCollectionViewCell.identifier)
        CollectionView.delegate = self
        CollectionView.dataSource = self
        CollectionView.reloadData()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       
        // Configure the view for the selected state
    }
    
    static let identifier = "HourlyTableViewCell"
    static func nib() -> UINib{
        return UINib(nibName: "HourlyTableViewCell", bundle: nil)
    }
    
    func configure (with models:[HourlyWeather]){
        self.models = models
        CollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.identifier, for: indexPath) as! WeatherCollectionViewCell
        cell.configure(with: models[indexPath.row])
        return cell
    }
    
    
    
}
