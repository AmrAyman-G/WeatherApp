//
//  WeatherTableViewCell.swift
//  MyWeather
//
//  Created by amr on 24/04/2022.

import UIKit

class WeatherTableViewCell: UITableViewCell ,UITableViewDelegate{

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var dayLabel:UILabel!
    @IBOutlet weak var maxTemp:UILabel!
    @IBOutlet weak var minTemp:UILabel!
    @IBOutlet weak var iconImage:UIImageView!
    let vC = ViewController()

    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    static let identifier = "WeatherTableViewCell"
    static func nib() -> UINib{
        return UINib(nibName: "WeatherTableViewCell", bundle: nil)
    }
    
    func configure(with model: DailyWeather , and respons: WeatherRespons ){
        
        self.maxTemp.textAlignment = .center
        self.minTemp.textAlignment = .center
         var toDay : String?
        var days: String?
        toDay = getDayForData(Date(timeIntervalSince1970:Double(respons.current.dt)))
        days = getDayForData(Date(timeIntervalSince1970: Double(model.dt)))
        self.maxTemp.text = ("\(Int(model.temp.max))°")
        self.minTemp.text = ("\(Int(model.temp.min))°")
        if days == toDay {
            self.dayLabel.text = "Today"
        }
        else{
            self.dayLabel.text = days
        }
        
       
        
        
        self.iconImage.image = UIImage(named: model.weather[0].main)
        self.iconImage.contentMode = .scaleAspectFit
       
    }
        
    func getDayForData(_ date:Date?) -> String{
        guard let inputDate = date else{
//            /fatalError("Error!")
            return ""
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM d"
    
        return formatter.string(from: inputDate)
        
        }
    
}
