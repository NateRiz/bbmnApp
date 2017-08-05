//
//  RecipeListViewController.swift
//  MealPrep
//
//  Created by Matthew Rizik on 8/4/17.
//  Copyright © 2017 BBMN. All rights reserved.
//

import UIKit

class RecipeListViewController: UIViewController {
    

    
    @IBOutlet weak var recipeVerticalStack: UIStackView!
    
    var imgCanvas = [UIImageView]()
    
    var hits: NSArray?
    var query: String?
    
    
    var APPKEY: String = "af7d9dd7a8371d144724086c9d95b91e"
    var APPID: String = "4474418e"
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        apiRequest()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    
    func fillCollectionView()
    /*
        >To fill scroll view with retrieved data from apiRequest()
        >fills with UIImageViews, UIImages, Labels
    */
    {
    
        guard let hits=self.hits else {print("hits nil"); return}
        if (hits.count == 0) {print("hits empty"); return}
        
        
        for i in 0..<hits.count
        {
            if let hit = hits[i] as? [String : Any]{
                if let recipe = hit["recipe"] as? [String : Any]{
                    if let imageURL = recipe["image"] as? String{
                        //let recipeView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 148))
                        self.imgCanvas.append(UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 148)))
                        getImage(imageURL, i)
                    }
                }
            }
            
        }
        DispatchQueue.main.async {
            for i in 0..<self.imgCanvas.count{
                self.recipeVerticalStack.addArrangedSubview(self.imgCanvas[i])
            
            }
        }
        
    }
    
    
    
    
    func apiRequest()
    /*
         >Need to call api to get recipe data based on search data
         >if query is nil defaults to chicken
    */
    
    {
        let query: String = self.query != nil ? self.query! : "Chicken"
        
        let urlBuilder = URL(string: "https://api.edamam.com/search?q="+query+"&app_id="+self.APPID+"&app_key="+self.APPKEY)
        if let url = urlBuilder
        {
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

                            self.hits = jsonResult["hits"] as? NSArray
                            print(self.hits!.count, "<<<")
                            self.fillCollectionView()
        
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
    
    func getImage(_ imageURL: String, _ canvasID: Int){
        let url = URL(string: imageURL)!
        let request = NSMutableURLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                
                if let data = data {
                    if let image = UIImage(data: data) {
                        
                        DispatchQueue.main.async {
                            self.imgCanvas[canvasID].image = image
                        }
                    }
                }
            }
        }
        
        task.resume()
    }

}
