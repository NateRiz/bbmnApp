//
//  TodayViewController.swift
//  MealPrep
//
//  Created by Brian Lowen on 7/28/17.
//  Copyright © 2017 BBMN. All rights reserved.
//

import UIKit

class TodayViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func apiCall(_ sender: Any) {
        
//        let query = "chicken"
//        let APPID = "4474418e"
//        let APPKEY = "af7d9dd7a8371d144724086c9d95b91e"
        let urlBuilder = URL(string:"https://api.edamam.com/search?q=chicken&app_id=4474418e&app_key=af7d9dd7a8371d144724086c9d95b91e")
        
        if let url = urlBuilder {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                } else {
                    if let usableData = data {
                        print(usableData) //JSONSerialization
                        
                        do {
                            
                            let jsonResult = try JSONSerialization.jsonObject(with: usableData, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                            
                            print(jsonResult)
                            
                            print(jsonResult["name"])
                            
                        } catch {
                            
                            print("JSON processing failed!")
                            
                        }
                        
                    }
                }
            }
            task.resume()
        }
        
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
