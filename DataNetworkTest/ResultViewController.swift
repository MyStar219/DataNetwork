//
//  ResultViewController.swift
//  DataNetworkTest
//
//  Created by administrator on 8/9/17.
//  Copyright © 2017 administrator. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet weak var ip_Lbl: UILabel!
    @IBOutlet weak var hostName_Lbl: UILabel!
    @IBOutlet weak var city_Lbl: UILabel!
    @IBOutlet weak var region_Lbl: UILabel!
    @IBOutlet weak var country_Lbl: UILabel!
    @IBOutlet weak var location_Lbl: UILabel!
    @IBOutlet weak var org_Lbl: UILabel!
    
    var IP: String = ""
    var HostName: String = ""
    var City: String = ""
    var Region: String = ""
    var Country: String = ""
    var Location: String = ""
    var Org: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ip_Lbl.text = self.IP
        hostName_Lbl.text = self.HostName
        city_Lbl.text = self.City
        region_Lbl.text = self.Region
        country_Lbl.text = self.Country
        location_Lbl.text = self.Location
        org_Lbl.text = self.Org
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func BackButtonClicked(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
