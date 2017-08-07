//
//  RecipeListViewController.swift
//  MealPrep
//
//  Created by Matthew Rizik on 8/4/17.
//  Copyright © 2017 BBMN. All rights reserved.
//

import UIKit

class RecipeListViewController: UIViewController {
    

    @IBOutlet weak var recipeScrollView: UIScrollView!
    @IBOutlet weak var recipeStackView: UIStackView!

    var horizontalStackImageHolder = [String:UIImageView]()
    
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
    
    
    @IBAction func exitButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
                    if let label = recipe["label"] as? String{
                        if let imageURL = recipe["image"] as? String{
                            print("getting image")
                            getImage(imageURL, label)
                        }
                    }

                }
            }
            
        }
        /*DispatchQueue.main.async
        {
            
         
         
            
            
            var increment: Int = 0
            for (key, _) in self.imgCanvas
            {
                self.imgCanvas[key]!.frame=CGRect(x: increment % 2 == 0 ? 4 : 8 + pictureSize, y: 5 + (increment/2)*(pictureSize+10 + 50), width: pictureSize, height:pictureSize)
                self.recipeScrollView.addSubview(self.imgCanvas[key]!)
                
                let recipeLabel = UILabel()
                recipeLabel.text = key
                recipeLabel.frame = CGRect(x: increment % 2 == 0 ? 4 : 8 + pictureSize, y: 5+(increment/2)*(pictureSize+10 + 50)+pictureSize, width: pictureSize, height: 50)
                
                self.recipeScrollView.addSubview(recipeLabel)
                
                
                increment+=1
            }
        }*/
        
    }
    
    
    
    
    
    
    func getImage(_ imageURL: String, _ recipeLabel: String){
        let newImageView = UIImageView()
        
        
        let url = URL(string: imageURL)!
        let request = NSMutableURLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                
                if let data = data {
                    if let image = UIImage(data: data) {
                        
                        newImageView.image=image
                        print("appending")
                        self.horizontalStackImageHolder["label"] = newImageView
                        if self.horizontalStackImageHolder.count == 2
                        {
                            print("calling")
                            self.createNewStack(imgViews: self.horizontalStackImageHolder)
                            self.horizontalStackImageHolder.removeAll()
                        }
                        

                    }
                }
            }
        }
        
        task.resume()
    }
    
    
    func createNewStack(imgViews: [String:UIImageView])
    {
        if imgViews.count != 2{print("Function: CreateNewStack given unsupported imgviews count:",imgViews.count) ; return}
        
        var labels = [String]()
        
        for (label, _) in imgViews
        {
            labels.append(label)
        }
        print(labels[0] + ":" + labels[1])
        
        
        DispatchQueue.main.async
            {
                
                let pictureSize: Int = (Int(self.recipeScrollView.frame.width) - 4 - 4 - 4) / 2
                imgViews[labels[0]]!.frame = CGRect(x:0, y:0, width:pictureSize, height:pictureSize)
                imgViews[labels[1]]!.frame = CGRect(x:0, y:0, width:pictureSize, height:pictureSize)
                self.recipeScrollView.contentSize.height=CGFloat(pictureSize*(1+self.recipeStackView.subviews.count))
                
                
                let newHorizStack=UIStackView()
                newHorizStack.axis = UILayoutConstraintAxis(rawValue: 0)!
                newHorizStack.frame = CGRect(x:CGFloat(0), y:CGFloat(self.recipeStackView.subviews.count * pictureSize), width:self.recipeStackView.frame.width, height: CGFloat(pictureSize))
                newHorizStack.spacing = 4
                
                let leftVertStack = UIStackView()
                leftVertStack.axis = UILayoutConstraintAxis(rawValue: 1)!
                leftVertStack.frame = CGRect(x:0, y:0, width:pictureSize, height:pictureSize)
                leftVertStack.addSubview(imgViews[labels[0]]!)
                /*let leftLabel=UILabel()
                leftLabel.text=labels[0]
                leftVertStack.addSubview(leftLabel)
                newHorizStack.addSubview(leftVertStack)
                 */
                let rightVertStack = UIStackView()
                rightVertStack.axis = UILayoutConstraintAxis(rawValue: 1)!
                rightVertStack.frame = CGRect(x:pictureSize, y:0, width:pictureSize, height:pictureSize)
                rightVertStack.addSubview(imgViews[labels[1]]!)
                /*let rightLabel=UILabel()
                rightLabel.text=labels[0]
                leftVertStack.addSubview(rightLabel)
                newHorizStack.addSubview(rightVertStack)
                */
                
                
                self.recipeStackView.addSubview(newHorizStack)
                print("added")
                
                
        }
        
    }

}
