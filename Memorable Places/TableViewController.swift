//
//  TableViewController.swift
//  Memorable Places
//
//  Created by Chrishon Wyllie on 3/1/16.
//  Copyright © 2016 Chrishon Wyllie. All rights reserved.
//

import UIKit


//Remember, when you create a variable outside the class, it can be used by all
//other classes in this project as well as any method
//This dictionary uses two strings at once
var places = [Dictionary<String,String>()]

//No active place by default
var activePlace = -1

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        /*
        
        //This is for if the places dictionary is empty. It creates an example place
        //In this case, the Taj Mahal
        if places.count == 1 {
            
            //The dictionary does not come empty by default.
            //Therefore, you must remove the first index item first
            places.removeAtIndex(0)
            
            places.append(["name":"Taj Mahal","lat":"27.175277","lon":"78.042128"])
            
        }
        
        */
        
        
        //This permanently stores the items in the toDoList array on the app.
        //Remember, you must use as! to type
        //Also, the for loop checks to see if there exists such an array called
        //toDoList, if so, it saves the data. Otherwise, it does nothing.
        //The secondViewController updates the toDoList array with each entry
        //and this viewcontroller stores it.
        if NSUserDefaults.standardUserDefaults().objectForKey("places") != nil {
            
            places = NSUserDefaults.standardUserDefaults().objectForKey("places") as! [Dictionary<String,String>]
            
        } else {
            
            //The dictionary does not come empty by default.
            //Therefore, you must remove the first index item first
            places.removeAtIndex(0)
            
            places.append(["name":"Taj Mahal","lat":"27.175277","lon":"78.042128"])
            
        }

        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    
    
    
    
    
    
    
    
    
    //==========================================================================================================================================//
    
    
    
    
    //Changed the "return 0" to 1 and places.count
    
    
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        //Creates a number of rows equal to the number of places that are in the places dictionary
        return places.count
    }

    //
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        cell.textLabel?.text = places[indexPath.row]["name"]

        return cell
    }
    

    
    
    //This method allows the user to press on the cell in the tableView and bring them to the location specified
    //This is desired function of this app
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        //
        activePlace = indexPath.row
        
        //This method must return indexPath
        return indexPath
    }
    
    
    
    
    
    
    /******IMPORTANT******/
    //This method does something whenever a segue is about to happen
    //This method returns the view to the user's location whenever the "+" is pressed
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //"newPlace" was the identifier that we set the "+" segue action to
        //Once a segue with this identifier is pressed, it sets the activePlace back to -1
        //Effectively bringing the screen back to the user's location
        if segue.identifier == "newPlace" {
            
            activePlace = -1
            
        }
        
        
    }
    
    
    
    
    
    /*
    This method will be called whenever the user tries to edit something in the table.
    In this case, the ".Delete function used in the next line creates the iconic swipe-to-the-left
    deletion action
    */
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        //Checks if the editing function that user is committing is a "delete" function
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            //Removes the item from the universal array first. Removes the specific item using the "indexPath.row"
            //Refer to this array as the live version
            places.removeAtIndex(indexPath.row)
            
            //Updates the saved array by setting it to the new array that now has the specific item removed.
            //Refer to this as the saved version. They are technically different.
            //Think like a Word document. The user can update a file, but they must also save it.
            NSUserDefaults.standardUserDefaults().setObject(places, forKey: "places")
            
            //This method updates the actual table once the item is removed
            tableView.reloadData()
        }
        
    }
    
    
    
    
    
    
    /******IMPORTANT*******/
     //You must add this method in order for the touchPoint's address to appear in the
     //tableView. it reloads the data after the location has been pressed and adds it to
     //the table
    override func viewWillAppear(animated: Bool) {
        
        tableView.reloadData()
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //===================================================================================================//

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
