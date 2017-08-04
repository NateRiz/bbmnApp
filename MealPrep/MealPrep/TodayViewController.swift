//
//  TodayViewController.swift
//  MealPrep
//
//  Created by Brian Lowen on 7/28/17.
//  Copyright © 2017 BBMN. All rights reserved.
//

import UIKit

class TodayViewController: UIViewController {
    @IBOutlet weak var recipeLabel: UILabel!
    @IBOutlet weak var ingredientsListLabel: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    
    var ingredientsList = ""
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
                            
                            //print(jsonResult)
                            
                            if let hits = jsonResult["hits"] as? NSArray {
                                if let hit = hits[0] as? [String: Any]{
                                    if let recipe = hit["recipe"] as? [String: Any] {
                                        if let imageURL = recipe["image"] as? String {
                                            self.getImage(imageURL)
                                        }
                                        
                                        if let label0 = recipe["label"] as? String {
                                            print(label0)
                                            DispatchQueue.main.async {
                                                self.recipeLabel.text = label0
                                            }
                                        }
                                        
                                        if let ingredients = recipe["ingredientLines"] as? NSArray{
                                            print(ingredients)
                                            for ingredient in ingredients {
                                                
                                                self.ingredientsList += "\(ingredient)\n"
                                                
                                            }
                                            DispatchQueue.main.async {
                                                self.ingredientsListLabel.text = self.ingredientsList
                                            }
                                        }
                                    }
                                }
                            }
                            
                        } catch {
                            
                            print("JSON processing failed!")
                            
                        }
                        
                    }
                }
            }
            task.resume()
        }
        
    }
    
    func getImage(_ imageURL: String) {
        let url = URL(string: imageURL)!
        let request = NSMutableURLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                
                if let data = data {
                    if let image = UIImage(data: data) {
                        
                        DispatchQueue.main.async {
                            self.recipeImage.image = image
                        }
                    }
                }
            }
        }
        
        task.resume()
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
