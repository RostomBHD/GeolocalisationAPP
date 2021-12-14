//
//  Artwork MapTableViewController.swift
//  Assignement2
//
//  Created by Benhamada, Rostom on 29/11/2021.
// Rostom Benhamada 201531997

import UIKit
import MapKit
import CoreLocation

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}


class ArtworkMapTableViewController: UIViewController , UITableViewDelegate , UITableViewDataSource, MKMapViewDelegate , CLLocationManagerDelegate {
    
    
    var Arts:AllCampusArts? = nil
    
    @IBOutlet weak var myMap: MKMapView!
    @IBOutlet weak var myTable: UITableView!
    
    
    
    var locationManager = CLLocationManager()
    var firstRun = true
    var startTrackingTheUser = false
    
    var titleOfArt : String?
    var lat : String?
    var long : String?
    var places_location = (title : [String]() , lat : [String]() , long : [String]() , location_art : [String]() ) //to store title, lat , long and location of the arts  of the places in this tuple .
    
    var places_loc = [String]()
    
    
    let SectionHeaderHeight: CGFloat = 25
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string:"https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP228/artworksOnCampus/data.php?class=campusart&lastModified=2020-10-15") {
            let session = URLSession.shared
            session.dataTask(with: url) { [self] (data, response, err) in
                guard let jsonData = data else {
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let reportList = try decoder.decode(AllCampusArts.self, from: jsonData)
                    self.Arts = reportList
                    
                    for x in 0...((Arts?.campusart.count)! - 1 )    {    //inserting elements (title , lat , long , location_art) in the tuple to save them for future work
                        places_location.title.append((Arts?.campusart[x].title)!)
                        places_location.lat.append((Arts?.campusart[x].lat)!)
                        places_location.long.append((Arts?.campusart[x].long)!)
                        places_location.location_art.append((Arts?.campusart[x].location)!)
                        
                        
                        let formatter = NumberFormatter() // convert coordinates into double values
                        formatter.locale = NSLocale(localeIdentifier: "en_GB") as Locale
                        let double_lat = formatter.number(from: places_location.lat[x])
                        let double_long = formatter.number(from: places_location.long[x])
                        
                       
                        let places = MKPointAnnotation()  // append the informations needed for annotations to be displayed in the map .
                        places.title = places_location.title[x]
                        places.coordinate = CLLocationCoordinate2D(latitude: double_lat as! CLLocationDegrees , longitude: double_long as! CLLocationDegrees)
                        places.subtitle = Arts?.campusart[x].locationNotes
                        myMap.addAnnotation(places) 
                        
                        places_loc.append(places_location.location_art[x])
                        
                        
                        /**func distance_differennce () {
                         var art_location = CLLocationCoordinate2D(latitude: places_location.lat[x] , longitude :places_location.long[x] )
                         let distance = user_location.distance(to: art_location)
                         
                         } **/
                        
                    }
                    
                    
                    let groups = Dictionary(grouping: self.Arts!.campusart) { (building) in // grouping the buildings according to their location notes into sections
                        return building.locationNotes
                    }
                    sections = groups.map { (key, values) in
                        return location_section(building: key, artwork_info: values)
                    }
                    
                    sections = groups.map(location_section.init(building:artwork_info:))
                    
                    
                    
                    DispatchQueue.main.async {
                        self.updateTheTable()
                    }
                } catch let jsonErr {
                    print("Error decoding JSON", jsonErr)
                }
            }.resume()
        }
        
        
        locationManager.delegate = self as CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        myMap.showsUserLocation = true
        
        
        
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {    //number of selection in the table

        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = sections[section]
        let building = section.building
        return building
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let section = sections[section]
        return section.artwork_info.count
    }
    
    
    
    @IBOutlet weak var picture: UITableView!
    
    
    var headline_at_index = [unicampusart]()
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! DetailsOfCell
        
        let section = sections[indexPath.section]
        headline_at_index = section.artwork_info
        
        cell.TitleOfArtwork.text = headline_at_index[indexPath.row].title   // inserting a value to title of work in the cell
        cell.Author.text = headline_at_index[indexPath.row].artist          // inserting a value to author in the cell
        
        let base_url = "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP228/artwork_images/"
        var img_url = base_url + (headline_at_index[indexPath.row].thumbnail)    // the optional URL for each picture in the json .
        img_url = img_url.replacingOccurrences(of: " ", with: "%20")             // to delete the spaces and add 20%
        
        
        let image_url = URL(string: headline_at_index[indexPath.row].thumbnail)
        cell.picture?.load(url: image_url!)                                 // Load the image using the URL
        
        return cell
    }
    
    
    func distance_differennce () {
        
        //for z in 0...headline_at_cell.
        
        //var art_location = CLLocationCoordinate2D(latitude: headline_at_cell?.lat , longitude: headline_at_cell?.long)
        //let distance = user_location.distance(to: headline_at_cell.)
    }
    
    
    var headline_at_cell: unicampusart?
    
    var tapped_cell_index : Int?        // to store the index of which cell was tapped in the table
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tapped_cell_index = indexPath.row
        let section = sections[indexPath.section]
        headline_at_cell = section.artwork_info[indexPath.row]          //didSelect , then stored in the var declared (headline_at_cell)
        
        performSegue(withIdentifier:"segue", sender: nil)
    }
    
    //ar art_lat = self().headlineIndex?.lat
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segue" {
            let destination = segue.destination as! ViewController
            destination.Arts = Arts
            destination.headline_at_cell = headline_at_cell
            
        }
    }
    
    
    
    func updateTheTable () {
        myTable.reloadData()
    }
    
    
    
    //var art_location = CLLocationCoordinate2D (latitude: headlineIndex?.lat , longitude: headlineIndex?.long)
    var user_location : CLLocationCoordinate2D?
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])  { // show the user location
        let locationOfUser = locations[0]
        let latitude = locationOfUser.coordinate.latitude
        let longitude = locationOfUser.coordinate.longitude
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        user_location = location
        if firstRun {
            firstRun = false
            let latDelta: CLLocationDegrees = 0.0025
            let lonDelta: CLLocationDegrees = 0.0025
            let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
            let region = MKCoordinateRegion(center: location, span: span)
            self.myMap.setRegion(region, animated: true)
            
            _ = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(startUserTracking), userInfo: nil, repeats: false)
        }
        if startTrackingTheUser == true {
            myMap.setCenter(location, animated: true)
        }
        
    }
    
    @objc func startUserTracking() {
        startTrackingTheUser = true
    }
    
    
    var transmittedArts : [unicampusart]? // store info about the different arts that are grouped in one section
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) { // to access more detaild about the annotations into more view controllers
        let annotation = view.annotation
        
        for i in 0 ..< sections.count {
            if sections[i].building == annotation?.subtitle {
                let section = sections[i]
                let num_artworks = section.artwork_info.count
                for section in sections {
                    transmittedArts = section.artwork_info
                }
                if num_artworks == 1 {     // if there is only one art in the section
                    performSegue(withIdentifier:"toDetail", sender: nil)  // display further details
                    for x in 0..<sections[i].artwork_info.count {
                        if section.artwork_info[x].title == annotation?.title {
                            func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                                if segue.identifier == "toDetail" {
                                    let destination = segue.destination as! annot_detailsViewController
                                    destination.information2 = section.artwork_info[x].title!
                                    //destination.headline_at_cell = headline_at_cell
                                    
                                }
                            }
                        }
                        
                    }
                    
                    
                }
                if num_artworks > 1 {     // if there are more than 1 arts in the section
                    performSegue(withIdentifier:"toTransition", sender: nil)  // display further details
                }
            }
        }
        
        
        
    }
}
