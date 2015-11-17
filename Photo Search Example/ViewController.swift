//
//  ViewController.swift
//  Photo Search Example
//
//  Created by Jose Andrade-Sinning on 11/16/15.
//  Copyright © 2015 Timeplify, LLC. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire


class ViewController: UIViewController, UISearchBarDelegate{
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let YOUR_API_CLIENT = "fe6790bf1f764c6d9d4f5d5cf8364d39"
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        for subview in self.scrollView.subviews {
            subview.removeFromSuperview()
        }
        
        searchBar.resignFirstResponder()
        
        let URLtoCall = "https://api.instagram.com/v1/tags/\(searchBar.text!)/media/recent?client_id=\(YOUR_API_CLIENT)"
        
        makeAPICallToThisURL(URLtoCall)
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let URLtoCall = "https://api.instagram.com/v1/tags/clararockmore/media/recent?client_id=\(YOUR_API_CLIENT)"
        
        makeAPICallToThisURL(URLtoCall)
        
    }
        
    
    
    func makeAPICallToThisURL(URLtoCall: String){
        
        Alamofire.request(.GET, URLtoCall).responseJSON{ response in
            
            let json = JSON(response.result.value!)
            
            if let dataArray = json["data"].arrayObject{
                
               // print("dataArray = \(dataArray)")
                
                var urlArray:[String] = []                  //1
                
                for dataObject in dataArray {               //2
                    if let imageURLString = dataObject.valueForKeyPath("images.standard_resolution.url") as? String { //3
                        urlArray.append(imageURLString)     //4
                    }
                }
                // print("urlArray = \(urlArray)")
                self.scrollView.contentSize = CGSizeMake(320, 320 * CGFloat(dataArray.count))
                
                for var i = 0; i < urlArray.count; i++ {
                    let imageData = NSData(contentsOfURL: NSURL(string: urlArray[i])!)         //1
                    if let imageDataUnwrapped = imageData {                                     //2
                        let imageView = UIImageView(image: UIImage(data: imageDataUnwrapped))   //3
                        imageView.frame = CGRectMake(0, 320 * CGFloat(i), 320, 320)               //4
                        self.scrollView.addSubview(imageView)                                        //5
                    }
                }
                
            }
            
        
    }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

