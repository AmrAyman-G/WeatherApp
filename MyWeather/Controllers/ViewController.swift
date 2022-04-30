//
//  ViewController.swift
//  MyWeather
//
//  Created by amr on 24/04/2022.
//

import UIKit
import CoreLocation

protocol reloadData{
    func reload()
    
}

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate {
    
    //MARK:  IBOutlet -
    @IBOutlet weak var backGroundGif: UIImageView!
    @IBOutlet var table : UITableView!
    //MARK: Varibales & Constents
    var model = [DailyWeather]()
    var hourlyModel = [HourlyWeather]()
    let locationManger = CLLocationManager()
    var currentLocation : CLLocation?
    var currentW : CurrentWeather?
    var wRespons : WeatherRespons?
    var degreeType: String?
    var index1 = IndexPath()
    
    //MARK: - View Did Load Function -
    override func viewDidLoad() {
        super.viewDidLoad()
        // Regester Cell
        table.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
        table.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        backGroundGif.loadGif(name: "BackGround")
        table.separatorColor = UIColor.gray
        degreeType = "metric"

    }
    //MARK: - View Did Appear -
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpLocation()
    }
    
    //MARK: - Location Function -
    func setUpLocation(){
        locationManger.delegate = self
        locationManger.requestWhenInUseAuthorization()
        locationManger.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManger.stopUpdatingLocation()
            requestWeatherForLocation()
        }
    }
    
    
    
    
    //MARK: - Degree Type Selectoer -
    @IBAction func degreeTypeSelectoer(_ sender: UISegmentedControl) {

        
        switch  sender.selectedSegmentIndex{
            
        case 0:
           
            degreeType = "metric"
            requestWeatherForLocation()
            
        case 1:
            degreeType = "standard"
           
            requestWeatherForLocation()
           
          
            
        default:
            break
        }
    }
    
    
    //MARK: - API Request Function -
    func requestWeatherForLocation(){
        guard let currentLocation = currentLocation else {
            return
        }
        
        let long = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
        let url = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(long)&exclude=&appid=b09b8d090807690809f825e392998091&units=\(self.degreeType!)"
        print(degreeType!,"##########")
        
        if let url = URL(string: url){
            let urlSession = URLSession(configuration: .default)
            let task = urlSession.dataTask(with: url) { data, response, error in
                // Validation
                if let safeData = data {
                // Convert data to model/some object
                    let decoder = JSONDecoder()
                    do {
                        let   decodedData = try decoder.decode(WeatherRespons.self, from: safeData )
                        let weatherDayData = decodedData.daily
                        let daysEntries = weatherDayData
                        let weatherhourData = decodedData.hourly
                        let hourEntries = weatherhourData
                        let respons = decodedData
                        self.currentW = respons.current
                        self.wRespons = respons
                
                        DispatchQueue.main.sync {
                            self.model.removeAll()
                            self.model.append(contentsOf: daysEntries)
                           // print(self.model)
                            self.hourlyModel.removeAll()
                            self.hourlyModel.append(contentsOf: hourEntries)
                           // print(self.hourlyModel)
                            self.table.tableHeaderView = self.createTableViewHeader()
                           
                        }
                    }catch{
                        print("Error1: \(error)")
                    }
                    
                }else{
                    print("Data Error : \(error!)")
                }
            }
            task.resume()
            self.table.reloadData()
        }
    }
    
    //MARK: - Table View UI Function -
    
    
    func createTableViewHeader() -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width))
        let locationLabel = UILabel(frame: CGRect(x: 10, y: 10, width: view.frame.size.width-20 , height: headerView.frame.size.height/5))
        let summaryLabel = UILabel(frame: CGRect(x: 10, y: 50+locationLabel.frame.size.height, width: view.frame.size.width-20 , height: headerView.frame.size.height/5))
        let tempLabel = UILabel(frame: CGRect(x: 10, y: 20+locationLabel.frame.size.height+summaryLabel.frame.size.height, width: view.frame.size.width-20 , height: headerView.frame.size.height/2))
        let iconImage = UIImageView(frame: CGRect(x: 155, y: 155-summaryLabel.frame.size.height, width:100, height: 100))
        let degryType = UILabel(frame: CGRect(x: 314.2, y: -8.1, width: 50, height: 50))
        
      
        headerView.addSubview(degryType)
        headerView.addSubview(locationLabel)
        headerView.addSubview(summaryLabel)
        headerView.addSubview(tempLabel)
        headerView.addSubview(iconImage)
        
        
        locationLabel.textAlignment = .center
        degryType.textAlignment = .center
        locationLabel.font = UIFont.systemFont(ofSize: 30)
        summaryLabel.textAlignment = .center
        tempLabel.textAlignment = .center
        locationLabel.textColor = .white
        summaryLabel.textColor = .white
        tempLabel.textColor = .white
        
        iconImage.image = UIImage(named: "Clouds")
        locationLabel.text = wRespons?.timezone
        summaryLabel.text = self.currentW?.weather[0].main
        if let temps =  self.currentW?.temp {
            tempLabel.text = "\(String(format: "%.f", temps))°"
        }
        
        
        tempLabel.font = UIFont(name: "Helvetica-Bold", size: 32)
        self.table.reloadData()
        return headerView
    }
    
    //MARK: TableVIew Dalegate & DataSource Function
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        return model.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        index1 = indexPath
        print(index1)
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.identifier, for: indexPath) as! HourlyTableViewCell
            cell.configure(with: hourlyModel)
            cell.backgroundColor = UIColor.clear
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as? WeatherTableViewCell else {
            fatalError("cell error ")
        }
//        let model = self.model[indexPath.row]
    
        cell.configure(with: model[indexPath.row],and: wRespons!)
//        self.table.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
//        cell.maxTemp.text = ""
//        cell.maxTemp.text    = ("\(Int(model.temp.max))°")
//
//        cell.minTemp.text    = ("\(Int(model.temp.min))°")
//        cell.iconImage.image = UIImage(named: model.weather[0].main)
        cell.backgroundColor = UIColor.clear
        dismiss(animated: true)
        return cell
    }
    
    
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}


//MARK: - JSON Codable Structs -


struct WeatherRespons : Codable{
    let lat : Float
    let lon : Float
    let timezone : String
    let timezone_offset: Int
    let current : CurrentWeather
    let hourly : [HourlyWeather]
    let daily : [DailyWeather]
}

struct CurrentWeather:Codable{
    let dt : Int
    let sunrise : Double
    let sunset: Double
    let temp: Double
    let feels_like: Double
    let pressure:Double
    let humidity:Double
    let dew_point:Double
    let uvi: Double
    let clouds:Double
    let visibility:Double
    let wind_speed:Double
    let wind_deg:Double
    let wind_gust:Double
    let weather : [Weather]
}
struct HourlyWeather : Codable {
    let  dt : Int
    let temp : Double
    let feels_like : Double
    let pressure  : Double
    let humidity : Double
    let dew_point : Double
    let uvi : Float
    let clouds : Float
    let visibility:Double
    let wind_speed:Double
    let wind_deg:Double
    let wind_gust:Double
    let weather : [Weather]
}
struct DailyWeather : Codable{
    let dt : Int
    let sunrise : Double
    let sunset: Double
    let moonrise:Double
    let moonset :Double
    let moon_phase:Double
    let temp: Temps
    let feels_like : FeelsLike
    let pressure: Double
    let humidity : Double
    let dew_point : Double
    let wind_speed:Double
    let wind_deg:Double
    let wind_gust:Double
    let weather : [Weather]
    let clouds : Float
    let pop : Float
    let uvi : Float
    
}
struct Temps : Codable{
    let day : Float
    let min : Float
    let max : Float
    let night : Float
    let eve : Float
    let morn :Float
}
struct FeelsLike : Codable {
    let day : Float
    let night : Float
    let eve : Float
    let morn :Float
}

struct Weather:Codable {
    let id : Int
    let main: String
    let description:String
    let icon: String
}



