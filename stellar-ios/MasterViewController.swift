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
    var objects = NSMutableArray()
    
    var webView: WKWebView?
    
    func userContentController(userContentController: WKUserContentController!, didReceiveScriptMessage message:WKScriptMessage!){
        // println("got message: \(message.body)")
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
        
        
        let url = NSURL(string: "http://stellar-client-webkit.s3-website-us-west-2.amazonaws.com/#/login")
        let req = NSURLRequest(URL: url)
        
        //changes from last post
        var theConfiguration = WKWebViewConfiguration()
        theConfiguration.userContentController.addScriptMessageHandler(self,
            name: "interOp")
        self.webView = WKWebView(frame:self.view.frame,
            configuration: theConfiguration)
        self.view = self.webView
        self.webView!.loadRequest(req)
  
        
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
        if objects == nil {
            objects = NSMutableArray()
        }
        objects.insertObject(NSDate.date(), atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }

    // #pragma mark - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            let indexPath = self.tableView.indexPathForSelectedRow()
            let object = objects[indexPath.row] as NSDate
            ((segue.destinationViewController as UINavigationController).topViewController as DetailViewController).detailItem = object
        }
    }

    // #pragma mark - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        let object = objects[indexPath.row] as NSDate
        cell.textLabel.text = object.description
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeObjectAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            let object = objects[indexPath.row] as NSDate
            self.detailViewController!.detailItem = object
        }
    }


}

