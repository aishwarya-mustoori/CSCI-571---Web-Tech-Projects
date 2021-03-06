//
//  BusinessView.swift
//  IOSApp
//
//  Created by Aishwarya Mustoori on 4/19/20.
//  Copyright © 2020 Aishwarya Mustoori. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftSpinner
import Alamofire
import SwiftyJSON
class BusinessView: UIViewController,IndicatorInfoProvider,UITableViewDelegate,UITableViewDataSource {
    
   
    @IBOutlet weak var businessResultsTable: UITableView!
    
  var selected = ""
    
    var refreshControl = UIRefreshControl()
    var businessResults : [[String : String]] = [[:]]
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
  
        SwiftSpinner.show("Loading BUSINESS Headlines..")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        businessResultsTable.addSubview(refreshControl)
        businessResultsTable.isHidden = false
        businessResultsTable.delegate = self
        businessResultsTable.dataSource = self
        
        AF.request("https://amustoori.azurewebsites.net/searchSections?section=business").responseJSON { (responseData) -> Void in
       
            if((responseData) != nil) {
                
                let swiftyJsonVar = JSON(responseData.data)
             
                self.businessResults=[]
                for values in swiftyJsonVar
                {
                 
                    self.businessResults.append([
                        "image" : values.1[4]["url"].string!,
                        "id" : values.1[0]["id"].string!,
                        "sectionId" : values.1[1]["section"].string!,
                        "date": values.1[2]["date"].string!,
                        "webTitle": values.1[3]["title"].string!,
                        "webUrl" : values.1[5]["idUrl"].string!
                        
                    ])
                    
                }
                
                DispatchQueue.global(qos: .background).async {
                    
                    // Background Thread
                    
                    DispatchQueue.main.async {
                        // Run UI Updates
                        self.businessResultsTable.reloadData()
                        
                        SwiftSpinner.hide()
                    }
                }
            }
            
            
            
        }
        
      
    }
    
@objc func refresh() {
    


    AF.request("https://amustoori.azurewebsites.net/searchSections?section=business").responseJSON { (responseData) -> Void in
       
        if((responseData.data) != nil) {
        
            let swiftyJsonVar = JSON(responseData.data)
            
            self.businessResults=[]
            for values in swiftyJsonVar
            {
                self.businessResults.append([
                    "image" : values.1[4]["url"].string!,
                    "id" : values.1[0]["id"].string!,
                    "sectionId" : values.1[1]["section"].string!,
                    "date": values.1[2]["date"].string!,
                    "webTitle": values.1[3]["title"].string!,
                    "webUrl" : values.1[5]["idUrl"].string!
                    
                ])
                
            }
     
            DispatchQueue.global(qos: .background).async {
                
                // Background Thread
                
                DispatchQueue.main.async {
                    // Run UI Updates
                    self.businessResultsTable.reloadData()
              
                    SwiftSpinner.hide()
                }
            }
            
            
            
            
        }
  
    
        
        self.refreshControl.endRefreshing()
        
        
    }
}
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.businessResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "businessCells",for: indexPath) as! WorldCells
       cell.contentView.layer.borderWidth = 0.6
     cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
               cell.contentView.layer.cornerRadius = 12
               cell.contentView.layer.masksToBounds = true
      
        if(businessResults != nil && businessResults[indexPath.row] != nil && businessResults[indexPath.row] != nil && businessResults[indexPath.row]["image"] != nil && !businessResults[indexPath.row]["image"]!.contains("not present")){
            
            var url = NSURL(string :businessResults[indexPath.row]["image"]!)
            let imgData = NSData.init(contentsOf: url! as URL)
            cell.worldImage.image = UIImage(data :imgData! as Data)
        }else{
            
            cell.worldImage.image =  UIImage(named : "default-guardian")!
        }
        if(businessResults != nil && businessResults[indexPath.row] != nil && businessResults[indexPath.row]["date"] != nil){
            
            let date = businessResults[indexPath.row]["date"]!
            let dateFormatter = ISO8601DateFormatter()
             let webDate = dateFormatter.date(from:date)!
             let today = Date()
             var diff = ""
            let dayHourMinuteSecond: Set<Calendar.Component> = [.hour, .minute, .second]
             let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: webDate, to: today)
           
             if(difference.hour! > 0 ){
                 diff = String(difference.hour!) + "h ago"
             }
             else if(difference.minute! > 0) {
                 diff = String(difference.minute!) + "m ago"
             }else if(difference.second! > 0) {
                 diff = String(difference.second!) + "s ago"
             }
            cell.worldTime.text = diff
            
        }
        if(businessResults != nil && businessResults[indexPath.row] != nil && businessResults[indexPath.row]["sectionId"] != nil){
     
            var section = businessResults[indexPath.row]["sectionId"]!
            cell.worldSection.text = "| " + section

            
        }
        
        if(businessResults != nil && businessResults[indexPath.row] != nil && businessResults[indexPath.row]["webTitle"] != nil){
            
            if(cell.worldTitle != nil){
                cell.worldTitle.text = businessResults[indexPath.row]["webTitle"]!
                
            }}
        var defaults = UserDefaults.standard
         
          defaults.synchronize()
          var data = defaults.array(forKey: "bookmarkData")
          var addOrDelete = false
        if(data != nil && businessResults[0]["id"] != nil){
          
          for datas in JSON(data!) {
              if( datas.1.count != 0 && datas.1["id"].string!  == self.businessResults[indexPath.row]["id"]! ){
                  addOrDelete = true
                  break;
              }
          }
          }
        
          if(addOrDelete)
          {
              cell.worldBookmark.setImage(UIImage(systemName: "bookmark.fill"), for: UIControl.State.normal)
                             
          }else{
            
           cell.worldBookmark.setImage(UIImage(systemName: "bookmark"), for: UIControl.State.normal)
                             
          }

          cell.worldBookmark.tag = indexPath.row
          cell.worldBookmark.addTarget(self, action: #selector(buttonClicked), for: UIControl.Event.touchUpInside)
        
        return cell;
        
        
    }
    @objc func buttonClicked(sender:UIButton) {
              
              let buttonRow = sender.tag
              let defaults = UserDefaults.standard
              var data = defaults.array(forKey: "bookmarkData")
          
        

              if(data == nil || data?.count == 0)
              {
                  self.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view", duration: 2.0)
                 
                  
                  var data1  = [
                      "id" : self.businessResults[buttonRow]["id"]!,
                      "image" :self.businessResults[buttonRow]["image"]!,
                      "sectionId" : self.businessResults[buttonRow]["sectionId"]!,
                      "date": self.businessResults[buttonRow]["date"]!,
                      "webTitle": self.businessResults[buttonRow]["webTitle"]!,
                      "webUrl" : self.businessResults[buttonRow]["webUrl"]!,
                      ]


                  defaults.set([data1], forKey: "bookmarkData")
                  defaults.synchronize()
                  self.businessResultsTable.reloadData()


              }else {
                  var data1  = [
                                   "id" : self.businessResults[buttonRow]["id"]!,
                                   "image" :self.businessResults[buttonRow]["image"]!,
                                   "sectionId" : self.businessResults[buttonRow]["sectionId"]!,
                                   "date": self.businessResults[buttonRow]["date"]!,
                                   "webTitle": self.businessResults[buttonRow]["webTitle"]!,
                                   "webUrl" : self.businessResults[buttonRow]["webUrl"]!,
                                   ]
               var deletedData = [[]];
                  var addOrDelete = false
                  var index = 0
                  for datas in JSON(data!) {

                      if( datas.1.count != 0 && datas.1["id"] != nil  && datas.1["id"].string!  == self.businessResults[buttonRow]["id"]! ){
                          addOrDelete = true
                          break;
                      }else{
                          index = index + 1
                      }
                  }
               
                  if(addOrDelete)
                  {
                      self.view.makeToast("Article Removed from Bookmarks", duration: 2.0)
                      data!.remove(at: index)
                    
                      
                  }else{
                  data!.append(data1)
                      self.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view", duration: 2.0)
                      

                  }

                  defaults.set(data, forKey: "bookmarkData")
                   defaults.synchronize()
                  self.businessResultsTable.reloadData()

              }

              
          }
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "BUSINESS")
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          
        selected = self.businessResults[indexPath.row]["id"]!
                performSegue(withIdentifier: "detailedArticle", sender: self)
    
            }
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if(segue.identifier == "detailedArticle"){
                
                var vc = segue.destination as! HomeResultsDetailedArticle
                vc.id = selected
                }
               
            }
            override func viewWillAppear(_ animated: Bool) {
                   super.viewWillAppear(true)
                   self.businessResultsTable.reloadData()
               }
    
   
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
             
             
             let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { actions -> UIMenu? in
                 let twitter = UIAction(title: "Share with Twitter", image: UIImage(named: "twitter"), identifier: nil) { action in
                     let textString = self.businessResults[indexPath.row]["webUrl"]! + "#CSCI_571_NewsApp"
                     let tweetUrl = self.businessResults[indexPath.row]["webTitle"]
                     
                     let shareString = "https://twitter.com/intent/tweet?text=\(textString)"
                     
                     // encode a space to %20 for example
                     let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                     
                     // cast to an url
                     let url = URL(string: escapedShareString)
                     
                     // open in safari
                     //UIApplication.shared.openURL(url!)
                     UIApplication.shared.open(url!)
                 }
                 var defaults = UserDefaults.standard
                 defaults.synchronize()
                 var data = defaults.array(forKey: "bookmarkData")
                 
                  var data1  = [
                     "id" : self.businessResults[indexPath.row]["id"]!,
                     "image" :self.businessResults[indexPath.row]["image"]!,
                     "sectionId" : self.businessResults[indexPath.row]["sectionId"]!,
                     "date": self.businessResults[indexPath.row]["date"]!,
                     "webTitle": self.businessResults[indexPath.row]["webTitle"]!,
                     "webUrl" : self.businessResults[indexPath.row]["webUrl"]!,
                 ]
                 
                 var deletedData = [[]];
                 var addOrDelete = false
                 var index = 0
                if(data == nil || data?.count == 0)
                      {
                          self.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view", duration: 2.0)
                          
                          
                          var data1  = [
                             "id" : self.businessResults[indexPath.row]["id"]!,
                              "image" :self.businessResults[indexPath.row]["image"]!,
                              "sectionId" : self.businessResults[indexPath.row]["sectionId"]!,
                              "date": self.businessResults[indexPath.row]["date"]!,
                              "webTitle": self.businessResults[indexPath.row]["webTitle"]!,
                              "webUrl" : self.businessResults[indexPath.row]["webUrl"]!,
                          ]
                          
                          
                          defaults.set([data1], forKey: "bookmarkData")
                          defaults.synchronize()
                          let delay = 0.4
                          DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                                                  self.businessResultsTable.performBatchUpdates({
                                                    self.businessResultsTable.reloadRows(at : [indexPath], with: UITableView.RowAnimation.none)
                                                    })
                                                }
                                      
                          
                }else{
                 for datas in JSON(data!) {
                     
                     if(datas.1.count != 0 && datas.1["id"].string!  == self.businessResults[indexPath.row]["id"] ){
                         addOrDelete = true
                         break;
                     }else{
                         index = index + 1
                     }
                 }
                 }
                 var imgName = ""
                 if(addOrDelete)
                 {
                     imgName = "bookmark.fill"
                     
                 }else{
                    
                     imgName = "bookmark"
                     
                 }
                 
                 
                 let bookmark = UIAction(title: "Bookmark", image: UIImage(systemName: imgName), identifier: nil) { action in
                     
                     if(addOrDelete)
                     {
                         self.view.makeToast("Article Removed from Bookmarks", duration: 2.0)
                         data!.remove(at: index)
                         
                         
                     }else{
                          if(data != nil){
                                            data!.append(data1)
                                            }else{
                                                data = []
                                                data!.append(data1)
                                            }
                         self.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view", duration: 2.0)
                         
                         
                     }
                     defaults.set(data, forKey: "bookmarkData")
                     defaults.synchronize()
                     let delay = 0.4
                        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                                                self.businessResultsTable.performBatchUpdates({
                                                  self.businessResultsTable.reloadRows(at : [indexPath], with: UITableView.RowAnimation.none)
                                                  })
                                              }
                                    

    
                     
                     
                 }
                 
                 
                 let edit = UIMenu(__title: "Edit", image: nil, identifier: nil, children:[twitter,bookmark])
                 return UIMenu(__title: "Menu", image: nil, identifier: nil, children:[twitter, bookmark])
             }
             return configuration
         }
        

}




