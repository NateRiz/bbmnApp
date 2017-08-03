//: Playground - noun: a place where people can play

import UIKit

let query = "chicken"
let APPID = "4474418e"
let APPKEY = "af7d9dd7a8371d144724086c9d95b91e"
let urlBuilder = "https://api.edamam.com/search?q="+query+"&app_id="+APPID+"&app_key=" + APPKEY

if let url = urlBuilder {
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        if error != nil {
            print(error)
        } else {
            if let usableData = data {
                print(usableData) //JSONSerialization
            }
        }
    }
    task.resume()
