//
//  WeatherCollectionViewCell.swift
//  MyWeather
//
//  Created by amr on 26/04/2022.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    
    let vC = ViewController()

    static let identifier = "WeatherCollectionViewCell"
    static func nib()-> UINib{
        return UINib(nibName: "WeatherCollectionViewCell", bundle: nil)
    }
    
    @IBOutlet var iconImageView :UIImageView!
    @IBOutlet var tempLable : UILabel!
    @IBOutlet var timeLabel : UILabel!
    
//    @IBOutlet var
    
    func configure(with model: HourlyWeather){
        self.tempLable.text = "\(Int(model.temp))°"
        self.iconImageView.contentMode = .scaleAspectFit
        self.iconImageView.image = UIImage(named: model.weather[0].main)
        self.timeLabel.text = getHourForData(Date(timeIntervalSince1970: Double(model.dt)))
        }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func getHourForData(_ date:Date?) -> String{
        guard let inputDate = date else{
//            /fatalError("Error!")
            return ""
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: inputDate)
        
        
        
        
        }
    

}
