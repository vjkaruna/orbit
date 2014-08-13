//
//  MasterViewController.swift
//  stellar-ios
//
//  Created by Vijay Karunamurthy on 8/3/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit
import WebKit

class MasterViewController: UITableViewController, WKScriptMessageHandler {

    var detailViewController: DetailViewController? = nil
    var wallet: Wallet? = nil
    var trustlines = [Trustline]()
    var wallpaper: UIImageView?
    
    var webView: WKWebView?
    var origView: UIView?
    
    func userContentController(userContentController: WKUserContentController!, didReceiveScriptMessage message:WKScriptMessage!){
        
        
        // println("got message: \(message.body)")
        /**
        var mystring = "got message: \(message.body)"
        var alert = UIAlertController(title: mystring,
            message: "",
            preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK",
            style: .Default) { action in
                alert.dismissViewControllerAnimated(true) {}
        }
        alert.addAction(OKAction)
        self.presentViewController(alert, animated: true) {}
        **/
        
        // self.webView!.hidden = true
        // self.view = self.origView!

        // var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(message.body as NSData, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        var sentData = message.body as NSDictionary
        println(sentData)
        // self.navigationController.navigationItem.title = sentData["username"] as NSString
        // insertNewObject(sentData["username"] as NSString)
        // insertNewObject("success")
        
        var secret = sentData["secret"] as NSString
        var account = sentData["account"] as NSString
        var myid = sentData["id"] as NSString
        
        println("secret:\(secret) account:\(account)")
        
        /**
        let manager = AFHTTPRequestOperationManager()
        var parameters = ["id":myid]
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.POST( "https://wallet.stellar.org/wallets/show",
            parameters: parameters,
            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                println("JSON: " + responseObject.description)
            },
            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                println("Error: " + error.localizedDescription)
            })
        **/
        
        Alamofire.request(.POST, "https://live.stellar.org:9002", parameters: ["method":"account_lines", "params":[["account":"\(account)"]]], encoding: .JSON(options: nil))
            .response { (request, response, data, error) in
                self.webView!.hidden = true
                // self.navigationItem. = UIBarButtonItem(title: "Trustlines", style: .Plain, target: self, action: nil)
                let JSON = JSONValue(data as NSData)
                println(JSON["result"]["lines"][0])
                // let tlvals = JSON!.valueForKeyPath("result")!.valueForKeyPath("lines")! as Array<Dictionary<String, AnyObject>>
                let tlvals = JSON["result"]["lines"].array
                var new_trustlines = [Trustline]()
                if tlvals!.count > 0 {
                    tlvals!.map { dict in println(dict["currency"].string) }
                    new_trustlines = tlvals!.map { dict in Trustline(json:dict) }
                }
                for tl in new_trustlines {
                    println(tl.limit)
                    self.insertNewObject(tl)
                }
        }

        
        
        
     }
    
    override func loadView() {
        super.loadView()
        
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // sample url running a stripped-down reference web client that will post data back to WKWebView
        let url = NSURL(string: "http://stellar-client-webkit.s3-website-us-west-2.amazonaws.com/#/login")
        let req = NSURLRequest(URL: url)
        
        //changes from last post
        var theConfiguration = WKWebViewConfiguration()
        theConfiguration.userContentController.addScriptMessageHandler(self,
            name: "interOp")
        self.webView = WKWebView(frame:self.view.frame,
            configuration: theConfiguration)
        
        //self.webView!.loadRequest(req)
        self.origView = self.view
        // self.view = self.webView!
        self.view.addSubview(self.webView!)
        self.webView!.loadRequest(req)
        
        self.wallpaper = UIImageView(frame:self.navigationController.view.bounds)
        self.wallpaper!.image = UIImage(named:"wallpaper-default")
        self.wallpaper!.contentMode = .Left
        self.navigationController.view.insertSubview(wallpaper!,atIndex:0)
        
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Login", style: .Plain, target: self, action: nil)
  
        
        /**
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = controllers[controllers.endIndex-1].topViewController as? DetailViewController
        }
        
        let manager = AFHTTPRequestOperationManager()
        var parameters = ["id":"0a8efc506ab7823ec294e825e74d5efff3c9adcec654321fab4267b805c26879"]
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.POST( "https://wallet.stellar.org/wallets/show",
            parameters: parameters,
            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                println("JSON: " + responseObject.description)
            },
            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                println("Error: " + error.localizedDescription)
            })
        **/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(sender: AnyObject) {
        trustlines.append(sender as Trustline)
        let indexPath = NSIndexPath(forRow: trustlines.count-1, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }

    // #pragma mark - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            let indexPath = self.tableView.indexPathForSelectedRow()
            let tl = trustlines[indexPath.row] as Trustline
            ((segue.destinationViewController as UINavigationController).topViewController as DetailViewController).detailItem = tl
        }
    }

    // #pragma mark - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trustlines.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as TrustlineCell

        let tl = trustlines[indexPath.row] as Trustline
        println("Row \(indexPath.row) \(tl.limit)")
        if (tl != nil && tl.account != nil) {
            let acc = tl.account!.substringToIndex(advance(tl.account!.startIndex, 16))
            cell.accountLabel!.text = "\(acc)..."
            cell.balanceLabel!.text = "\(tl.balance!)"
            cell.limitLabel!.text = "/ \(tl.limit!)"
            cell.currencyLabel!.text = "\(tl.currency!)"
        }
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // objects.removeObjectAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            let tl = trustlines[indexPath.row] as Trustline
            self.detailViewController!.detailItem = tl
        }
    }


}

