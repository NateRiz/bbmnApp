
var ings: [String] = [
"olive oil", 
"garlic", 
"potatoes", 
"chicken", 
"white wine", 
"chicken stock", 
"parsley", 
"oregano", 
"Salt and pepper", 
"frozen peas" 
]


func ndbRequest(food:String) -> [String : Int] {
	let apiKey="5pcSwVWh5dKjUq3REoxpZRLjUJWJT0qsub2vHtBw"
	let urlBuilder=URL("https://api.nal.usda.gov/ndb/search/?format=json&q=" + food + "&sort=r&max=1&offset=0&api_key="+apiKey + )
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
                            
                            if let results = jsonResult["list"] as? NSArray
							{
								if let result = results["item"] as? [String : Any]
								{
									if let ndbno = result["ndbno"] as? String{
										return searchByNDBNO(query:ndbno)
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

func searchByNDBNO(query: String) -> [String : Int] {
	let apiKey="5pcSwVWh5dKjUq3REoxpZRLjUJWJT0qsub2vHtBw"
	let urlBuilder=URL("https://api.nal.usda.gov/ndb/reports/?ndbno=" + query + "&type=b&format=json&api_key="+apiKey)
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
                            
                            if let results = jsonResult["list"] as? NSArray
							{
								if let result = results["item"] as? [String : Any]
								{
									if let ndbno = result["ndbno"] as? String{
										return searchByNDBNO(query:ndbno)
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


