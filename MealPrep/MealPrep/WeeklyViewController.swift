//
//  WeeklyViewController.swift
//  MealPrep
//
//  Created by Brian Lowen on 8/3/17.
//  Copyright © 2017 BBMN. All rights reserved.
//

import UIKit

class WeeklyViewController: UIViewController {
    
    var macros = [String : Float]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func test(_ sender: Any) {
        if self.macros.count == 0{
            ndbRequest(food: "ham")
        }
        else{
            for (macro, value) in self.macros{
                print(macro + ": ",value, " \n")
            }
        }
    }
    
    
    
    func ndbRequest(food:String){
        
        
        let apiKey="5pcSwVWh5dKjUq3REoxpZRLjUJWJT0qsub2vHtBw"
        let urlBuilder=URL(string: "https://api.nal.usda.gov/ndb/search/?format=json&q=" + food + "&sort=r&max=1&offset=0&api_key=" + apiKey)
        if let url = urlBuilder{
            let task = URLSession.shared.dataTask(with: url)
            {
                (data, response, error) in
                if error != nil
                {
                    
                    print(error!)
                }
                else
                {
                    if let usableData = data
                    {
                        print(usableData) //JsonSerialization
                        
                        do
                        {
                            let jsonResult = try JSONSerialization.jsonObject(with: usableData, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                            
                            if let results = jsonResult["list"] as? [String : Any]
                            {
                                if let result = results["item"] as? [[String : Any]]
                                {
                                    if let ndbno = result[0]["ndbno"] as? String{
                                        self.searchByNDBNO(query:ndbno)
                                    }
                                }
                            }
                            
                        }
                        catch
                        {
                            print("JSON processing failed...")
                        }
                        
                        
                    }
                    
                }
            }
            
            task.resume()
            
        }
        
    }
    
    
    
    func searchByNDBNO(query: String){
        //TODO: search by macro. [[String:Any]] not in order .. eg: 2,3,4
        
        let apiKey="5pcSwVWh5dKjUq3REoxpZRLjUJWJT0qsub2vHtBw"
        let urlBuilder=URL(string: "https://api.nal.usda.gov/ndb/reports/?ndbno=" + query + "&type=b&format=json&api_key="+apiKey)
        if let url = urlBuilder{
            let task = URLSession.shared.dataTask(with: url)
            {
                (data, response, error) in
                if error != nil
                {
                    
                    print(error!)
                }
                else
                {
                    if let usableData = data
                    {
                        print(usableData) //JsonSerialization
                        
                        do
                        {
                            let jsonResult = try JSONSerialization.jsonObject(with: usableData, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                            
                            if let report = jsonResult["report"] as? [String : Any]
                            {
                                print(1)
                                if let food = report["food"] as? [String: Any]
                                {
                                    if let nutrients = food["nutrients"] as? [[String : Any]]
                                    {
                                        print(2)
                                        let proteinNutrient = nutrients[2]
                                        
                                        print(3)
                                        if let protein = proteinNutrient["value"] as? String
                                        {
                                           self.macros["protein"]=Float(protein)
                                        }
                                        
                                        let fatNutrient = nutrients[3]
                                        
                                        if let fat = fatNutrient["value"] as? String
                                        {
                                            self.macros["fat"]=Float(fat)

                                        }
                                        
                                        let carbNutrient = nutrients[4]
                                        
                                        if let carb = carbNutrient["value"] as? String
                                        {
                                            self.macros["carb"]=Float(carb)
                                        }
                                        
                                        
                                    }
                                }
                            }
                            
                            
                        }
                        catch
                        {
                            print("JSON processing failed...")
                        }
                        
                        
                    }
                    
                }
            }
            print("done")
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
