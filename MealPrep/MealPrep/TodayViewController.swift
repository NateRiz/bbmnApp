//
//  TodayViewController.swift
//  MealPrep
//
//  Created by Brian Lowen on 7/28/17.
//  Copyright © 2017 BBMN. All rights reserved.
//

import UIKit

class TodayViewController: UIViewController {
    @IBOutlet weak var foodStack: UIStackView!
    
    var labelToURL = [String:String]()
    var labelToIMG = [String:UIImageView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.apiCall(){
            () in
            var i = 0
            DispatchQueue.main.async {
                for (_,_) in self.labelToURL
                {
                    i+=1
                    let HStack = UIStackView(frame:CGRect(x:0, y:0, width:self.foodStack.frame.width, height: 30))
                    HStack.axis = .horizontal
                    HStack.backgroundColor=[UIColor.red,UIColor.green][i%2]
                    self.foodStack.addArrangedSubview(HStack)
                    
                    //let imgView = UIImageView()
                    //imgView.contentMode = UIViewContentMode(rawValue: 0)!
                    //imgView.frame = CGRect(x:0, y:0, width:300, height:20)
                    //imgView.backgroundColor = [UIColor.red,UIColor.green][i%2]
                    //self.foodStack.addArrangedSubview(imgView)
                    //self.getImage(imageURL: url, imageView: imgView)
                    
                }
            }

        }
        print("Done")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func apiCall(completion: @escaping ()->Void) {
        
//        let query = "chicken"
//        let APPID = "4474418e"
//        let APPKEY = "af7d9dd7a8371d144724086c9d95b91e"
        let urlBuilder = URL(string:"https://api.edamam.com/search?q=sushi&app_id=4474418e&app_key=af7d9dd7a8371d144724086c9d95b91e")
        
        if let url = urlBuilder {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                } else {
                    if let usableData = data {
                        print(usableData) //JSONSerialization
                        
                        do {
                            
                            let jsonResult = try JSONSerialization.jsonObject(with: usableData, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                            
                            //print(jsonResult)
                            for i in 0..<10
                            {
                                if let hits = jsonResult["hits"] as? NSArray {
                                    if let hit = hits[i] as? [String: Any]{
                                        if let recipe = hit["recipe"] as? [String: Any] {
                                            if let imageURL = recipe["image"] as? String {
                                                if let label = recipe["label"] as? String {
                                                    self.labelToURL[label]=imageURL
                                                }
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
                completion()
            }.resume()
        }
        
    }
    
    func getImage(imageURL:String, imageView:UIImageView){
        let url = URL(string: imageURL)!
        let request = NSMutableURLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                
                if let data = data {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            imageView.image=image
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
