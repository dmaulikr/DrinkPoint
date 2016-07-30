//
//  ThemeChooserViewController.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 7/28/16.
//  Copyright © 2016 BinaryBastards. All rights reserved.
//

import UIKit
import QuartzCore
import Crashlytics

class ThemeChooserViewController: UITableViewController {

    @IBOutlet weak var historyButton: UIBarButtonItem!
    @IBOutlet weak var tweetsButton: UIBarButtonItem!

    var logoView: UIImageView!
    var themes: [Theme] = []
    let themeTableCellReuseIdentifier = "ThemeCell"

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        themes = Theme.getThemes()
        logoView = UIImageView(frame: CGRectMake(0, 0, 40, 40))
        logoView.image = UIImage(named: "Logo")?.imageWithRenderingMode(.AlwaysTemplate)
        logoView.tintColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        logoView.frame.origin.x = (view.frame.size.width - logoView.frame.size.width) / 2
        logoView.frame.origin.y = -logoView.frame.size.height - 10
        navigationController?.view.addSubview(logoView)
        navigationController?.view.bringSubviewToFront(logoView)
        let logoTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ThemeChooserViewController.logoTapped))
        logoView.userInteractionEnabled = true
        logoView.addGestureRecognizer(logoTapRecognizer)
        tableView.alwaysBounceVertical = false
        let headerHeight: CGFloat = 15
        let contentHeight = view.frame.size.height - headerHeight
        let navHeight = navigationController?.navigationBar.frame.height
        let navYOrigin = navigationController?.navigationBar.frame.origin.y
        tableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, tableView.bounds.size.width, headerHeight))
        let themeTableCellHeight = (contentHeight - navHeight! - navYOrigin!) / CGFloat(themes.count)
        tableView.rowHeight = themeTableCellHeight
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.titleTextAttributes = titleDict as? [String: AnyObject]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.topItem?.title = ""
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .CurveEaseInOut,
            animations: {
                self.logoView.frame.origin.y = 8
            },
            completion: nil
        )
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.translucent = true
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if navigationController?.viewControllers.count > 1 {
            UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .CurveEaseInOut,
                animations: {
                    self.logoView.frame.origin.y = -self.logoView.frame.size.height - 10
                },
                completion: nil
            )
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender!.isKindOfClass(ThemeCell) {
            let indexPath = tableView.indexPathForSelectedRow
            if let row = indexPath?.row {
                let epigramComposerViewController = segue.destinationViewController as! EpigramComposerViewController
                epigramComposerViewController.theme = themes[row]
                Crashlytics.sharedInstance().setObjectValue(themes[row].name, forKey: "Theme")
                Answers.logCustomEventWithName("Selected Theme", customAttributes: ["Theme": themes[row].name])
            }
        }
    }

    func logoTapped() {
        performSegueWithIdentifier("ShowAbout", sender: self)
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(themeTableCellReuseIdentifier, forIndexPath: indexPath) as! ThemeCell
        let theme = themes[indexPath.row]
        cell.configureWithTheme(theme)
        return cell
    }
}