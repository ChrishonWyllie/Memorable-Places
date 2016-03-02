//
//  ViewController.swift
//  Memorable Places
//
//  Created by Chrishon Wyllie on 2/26/16.
//  Copyright © 2016 Chrishon Wyllie. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    var manager: CLLocationManager!
    
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        //If there is no active place yet, ask the user for their location
        //and begin to update their location
        if activePlace == -1 {
            
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
            
        } else {
            //else if there is an activePlace
            //You create a double (latitude coordinates are in double format)
            //from a String.
            //However, in order to do this, you must cast it as an NSString first
            //Then casting it as a double like so: string -> NSString -> double
            let latitude = NSString(string: places[activePlace]["lat"]!).doubleValue
            
            let longitude = NSString(string: places[activePlace]["lon"]!).doubleValue

            
            
            //This centers the screen on the user's special place. (The one that has been tapped in the tableView)
            var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            
            var latDelta: CLLocationDegrees = 0.01
            var lonDelta: CLLocationDegrees = 0.01
            
            var span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
            
            var region: MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
            
            self.map.setRegion(region, animated: true)
            
            //Creates an annotation (little red pin)
            var annotation = MKPointAnnotation()
            
            //Sets the coordinate of the red pin to the coordinate of the touchPoint
            annotation.coordinate = coordinate
            
            //The title is the text that appears above the red pin on the map
            //Usually the address of the place or some text that the user enters
            annotation.title = places[activePlace]["name"]
            
            //Adds the annotation to the map
            //The little red pin will now actually appear on the screen at the place
            //where the screen was long pressed
            self.map.addAnnotation(annotation)
            
        }
        
        //Remember to use the colon to pass on the necessary information. ie the parameters in the action method
        var uilgpr = UILongPressGestureRecognizer(target: self, action: "action:")
        
        uilgpr.minimumPressDuration = 1.2
        
        map.addGestureRecognizer(uilgpr)
        
    }
    
    
    func action(gestureRecognizer: UIGestureRecognizer) {
        
        //Avoids the issue of a gesture being recognized multiple times and creating
        //more than one gesture(memorable place on the map)
        //Looks for only the first gesture
        //Any code within this if statement will be run once per long press
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            
            //Gets the location that the user pressed on in the map view
            var touchPoint = gestureRecognizer.locationInView(self.map)
            
            //Converts the point on the map view into a coordinate
            var newCoordinate = self.map.convertPoint(touchPoint, toCoordinateFromView: self.map)
            
            //In order to use the CLGeocoder method, you must have a variable of the right CLLocation type.
            //You would not be able to use newCoordinate variable as it would give an error.
            //In order to get around this, You have created a new variable called location with the correct type
            //and used it in the CLGeocoder method
            var location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            
            //This will be used to get the real-world address of the long pressed location
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                
                
                //You create a string variable that will soon hold the title
                var title = ""
                
                if (error == nil) {
                    
                    if let p = placemarks?[0] {
                        
                        //You create two String variables that will soon hold the text that
                        //describes both the subThoroughfare and thoroughfare of the location
                        //In simpler terms, these are the roads on which the location exists
                        var subThoroughfare: String = ""
                        var thoroughfare: String = ""
                        
                        if p.subThoroughfare != nil {
                            
                            subThoroughfare = p.subThoroughfare!
                            
                        }
                        
                        if p.thoroughfare != nil {
                            
                            thoroughfare = p.thoroughfare!
                            
                        }
                        
                        
                        title = "\(subThoroughfare) \(thoroughfare)"
                        
                    }
                    
                }
                
                //The purpose of this is if the title could not be created
                //In other words, the subThoroughfare and thoroughfare text could not be generated
                //because the location exists in an area that does not have such roads
                //As a failsafe, you made the title show the date that it was added instead
                if title == "" {
                    
                    title = "Added \(NSDate())"
                    
                }
                
                //
                places.append(["name":title,"lat":"\(newCoordinate.latitude)","lon":"\(newCoordinate.longitude)"])
                
                //Creates an annotation (little red pin)
                var annotation = MKPointAnnotation()
                
                //Sets the coordinate of the red pin to the coordinate of the touchPoint
                annotation.coordinate = newCoordinate
                
                //The title is the text that appears above the red pin on the map
                //Usually the address of the place or some text that the user enters
                annotation.title = title
                
                //Adds the annotation to the map
                //The little red pin will now actually appear on the screen at the place
                //where the screen was long pressed
                self.map.addAnnotation(annotation)
                
            })
            
            /*IMPORTANT*/
            //Saves data
            //This updates the places table every time the user longpresses somewhere
            NSUserDefaults.standardUserDefaults().setObject(places, forKey: "places")
            
            
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        var userLocation:CLLocation = locations[0]
        
        var latitude = userLocation.coordinate.latitude
        
        var longitude = userLocation.coordinate.longitude
        
        var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        var latDelta: CLLocationDegrees = 0.01
        var lonDelta: CLLocationDegrees = 0.01
        
        var span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        
        var region: MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
        
        self.map.setRegion(region, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

