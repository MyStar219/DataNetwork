//
//  ViewController.swift
//  DataNetworkTest
//
//  Created by administrator on 8/9/17.
//  Copyright © 2017 administrator. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration
import SwiftSocket



class ViewController: UIViewController {
    var defaultURL: String = ""
    var defaultURLRequest: String = ""
    var anyURL: String = ""
    var anyURLRequest: String = ""
    var IP: String = ""
    var HostName: String = ""
    var City: String = ""
    var Region: String = ""
    var Country: String = ""
    var Location: String = ""
    var Org: String = ""
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var url_TField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        url_TField.attributedPlaceholder = NSAttributedString(string: "ipinfo.io", attributes: [NSForegroundColorAttributeName: UIColor.darkText])
        defaultURL = url_TField.placeholder!
        defaultURLRequest = "https://" + defaultURL + "/json"
        anyURL = url_TField.placeholder!
        anyURLRequest = "https://" + anyURL + "/json"
        print(defaultURLRequest)
        print(anyURLRequest)
        activityIndicator.isHidden = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func DefaultNetworkButtonClicked(_ sender: UIButton) {
        
        Global.GlobalVariable.hostName=defaultURL
        NetworkReachability()
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
        updateUserInterface()
        
        self.HostName = defaultURL
        
        if (Global.GlobalVariable.networkCheck == "wifi") {
            
            // Wifi Network
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            WifiResponse()
        } else {
           
            if (Global.GlobalVariable.networkCheck == "wwan") {
                
                // Carrier Data Network
                activityIndicator.isHidden = false
                activityIndicator.startAnimating()
                CarrierDataNetworkResponse()
                
            } else {
                let alert = UIAlertController(title: "Alert", message: "Network Error", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    

    @IBAction func CarrierDataNetworkButtonClicked(_ sender: UIButton) {
        if (url_TField.text == "") {
            anyURL = url_TField.placeholder!
            anyURLRequest = "https://" + anyURL + "/json"
            print(anyURLRequest)
        } else {
            anyURL = url_TField.text!
            anyURLRequest = "https://" + anyURL + "/json"
            print(anyURLRequest)
        }
        
            Global.GlobalVariable.hostName=anyURL
            NetworkReachability()
            NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
            updateUserInterface()

        if (Global.GlobalVariable.networkCheck == "unreachable") {
            let alert = UIAlertController(title: "Alert", message: "Network Error", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            if (Global.GlobalVariable.networkCheck == "wifi") {
                let alert = UIAlertController(title: "Alert", message: "Please turn off the Wifi.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else if (Global.GlobalVariable.networkCheck == "wwan") {
                // Carrier Data Network
                // disable Wifi
                
                activityIndicator.isHidden = false
                activityIndicator.startAnimating()
                CarrierDataNetworkResponse()
            }
        }
    }
    
    func stringClassFromString(_ className: String) -> AnyClass! {
        
        /// get namespace
        let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String;
        
        /// get 'anyClass' with classname and namespace
        let cls: AnyClass = NSClassFromString("\(namespace).\(className)")!;
        
        // return AnyClass!
        return cls;
    }

    func updateUserInterface() {
        guard let status = Network.reachability?.status else { return }
        switch status {
        case .unreachable:
            Global.GlobalVariable.networkCheck = "unreachable"
        case .wifi:
            Global.GlobalVariable.networkCheck = "wifi"
        case .wwan:
            Global.GlobalVariable.networkCheck = "wwan"
        }
        print("Reachability Summary")
        print("Status:", status)
        print("HostName:", Network.reachability?.hostname ?? "nil")
        print("Reachable:", Network.reachability?.isReachable ?? "nil")
        print("Wifi:", Network.reachability?.isReachableViaWiFi ?? "nil")
    }
    func statusManager(_ notification: NSNotification) {
        updateUserInterface()
    }
    
    func NetworkReachability() {
        do {
            Network.reachability = try Reachability(hostname:  Global.GlobalVariable.hostName)
            do {
                try Network.reachability?.start()
            } catch let error as Network.Error {
                print(error)
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
    
    func WifiResponse() {
        let url = URL(string: defaultURLRequest)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if let mydata = data {
                do {
                    let myjson = try JSONSerialization.jsonObject(with: mydata, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                    print(myjson)
                    if let ip = myjson["ip"] as! NSString? {
                        self.IP = ip as String
                    }
                    if let city = myjson["city"] as! NSString? {
                        self.City = city as String
                    }
                    if let region = myjson["region"] as! NSString? {
                        self.Region = region as String
                    }
                    if let country = myjson["country"] as! NSString? {
                        self.Country = country as String
                    }
                    if let loc = myjson["loc"] as! NSString? {
                        self.Location = loc as String
                    }
                    if let org = myjson["org"] as! NSString? {
                        self.Org = org as String
                    }
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden=true
                    let viewController =  self.storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
                    viewController.IP = self.IP
                    viewController.HostName = self.HostName
                    viewController.City = self.City
                    viewController.Region = self.Region
                    viewController.Country = self.Country
                    viewController.Location = self.Location
                    viewController.Org = self.Org
                    self.navigationController?.pushViewController(viewController, animated: true)
                } catch {
                    //catch error
                }
            }
        }
        task.resume()
    }
    func CarrierDataNetworkResponse() {
        HostName = self.anyURL
        let url = URL(string: anyURLRequest)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if let mydata = data {
                do {
                    let myjson = try JSONSerialization.jsonObject(with: mydata, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                    print(myjson)
                    if let ip = myjson["ip"] as! NSString? {
                        self.IP = ip as String
                    }
                    if let city = myjson["city"] as! NSString? {
                        self.City = city as String
                    }
                    if let region = myjson["region"] as! NSString? {
                        self.Region = region as String
                    }
                    if let country = myjson["country"] as! NSString? {
                        self.Country = country as String
                    }
                    if let loc = myjson["loc"] as! NSString? {
                        self.Location = loc as String
                    }
                    if let org = myjson["org"] as! NSString? {
                        self.Org = org as String
                    }
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    let viewController =  self.storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
                    viewController.IP = self.IP
                    viewController.HostName = self.HostName
                    viewController.City = self.City
                    viewController.Region = self.Region
                    viewController.Country = self.Country
                    viewController.Location = self.Location
                    viewController.Org = self.Org
                    self.navigationController?.pushViewController(viewController, animated: true)
                } catch {
                    //catch error
                }
            }
        }
        task.resume()
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}

