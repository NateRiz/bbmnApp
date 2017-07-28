//
//  OverviewViewController.swift
//  MealPrep
//
//  Created by Brian Lowen on 7/28/17.
//  Copyright © 2017 BBMN. All rights reserved.
//

import UIKit

class OverviewViewController: UIViewController {

    @IBOutlet weak var overviewlabel: UILabel!
    @IBAction func buttonpressed(_ sender: Any) {
        
        overviewlabel.text = "Hello Brian"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        overviewlabel.text = "Hello Nate"
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
