//
//  TableTableViewController.swift
//  TableViewDemo
//
//  Created by Broccoli on 15/11/2.
//  Copyright © 2015年 Broccoli. All rights reserved.
//

import UIKit


class TableViewController: UITableViewController {
    
    var objects = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] as NSMutableArray
    
     var snapshot: UIView!
     var sourceIndexPath: NSIndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let longPress = UILongPressGestureRecognizer(target: self, action: Selector("longPressGestureRecognized:"))
        self.tableView.addGestureRecognizer(longPress)
    }
    
    func longPressGestureRecognized(sender: UILongPressGestureRecognizer) {
        let state = sender.state
        
        let location = sender.locationInView(self.tableView)
        let indexPath = self.tableView.indexPathForRowAtPoint(location)
   
        
        switch state {
        case UIGestureRecognizerState.Began :
            if indexPath != nil {
                sourceIndexPath = indexPath
                let cell = self.tableView.cellForRowAtIndexPath(indexPath!)!
                
                snapshot = customSnapshotFromView(cell)!
                var center = cell.center
                snapshot.center = center
                snapshot.alpha = 0.0
                
                self.tableView.addSubview(snapshot)
                
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    center.y = location.y
                    self.snapshot.center = center
                    self.snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05)
                    self.snapshot.alpha = 0.98
                    
                    cell.alpha = 0.0
                    }, completion: { (finished) -> Void in
                        cell.hidden = true
                })
            }
        case UIGestureRecognizerState.Changed :
            var center = snapshot.center
            center.y = location.y
            snapshot.center = center
            
            if (indexPath != nil && !indexPath!.isEqual(sourceIndexPath)) {
                self.objects.exchangeObjectAtIndex(indexPath!.row, withObjectAtIndex: sourceIndexPath.row)
                self.tableView.moveRowAtIndexPath(sourceIndexPath, toIndexPath: indexPath!)
                
                sourceIndexPath = indexPath
            }
        default :
           let cell = self.tableView.cellForRowAtIndexPath(sourceIndexPath)!
            cell.hidden = false
            cell.alpha = 0.0
            
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.snapshot.center = cell.center
                self.snapshot.transform = CGAffineTransformIdentity
               self.snapshot.alpha = 0.0
                
                cell.alpha = 1.0
                }, completion: { (finish) -> Void in
                    self.sourceIndexPath = nil
                    self.snapshot.removeFromSuperview()
                    self.snapshot = nil
            })
        }
    }
    
    func customSnapshotFromView(inputView: UIView) -> UIView! {
        // 获取 view 的上下文 转成 图片的
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0)
        inputView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let  image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // 生成图片
        let snapshot = UIImageView(image: image) as UIView
        snapshot.layer.masksToBounds = false
        snapshot.layer.cornerRadius = 0.0
        snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0)
        snapshot.layer.shadowRadius = 5.0
        snapshot.layer.shadowOpacity = 0.4
        
//        let view = snapshot as! UIView
        return snapshot
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return objects.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        
        cell.textLabel!.text = "我是第几行\(objects[indexPath.row])"
        
        return cell
    }
    
}


