//
//  TabsViewController.swift
//  runnur
//
//  Created by Archana Vetkar on 16/08/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class TabsViewController: UIPageViewController, UIPageViewControllerDataSource,UIPageViewControllerDelegate {

     weak var ActivityDetailsDelegate: ActivityDetailsViewController?
     var mapData = MapData();
    var sumViewController = SummaryActivityViewController()
    var graphViewController = GraphsViewController();
    var splitsViewController = SplitsViewController();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self;
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .Forward,
                               animated: true,
                               completion: nil)
        }
        ActivityDetailsDelegate?.tutorialPageViewController(self,
                                                     didUpdatePageCount: orderedViewControllers.count)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        
        
        return [self.newColoredViewController("SummaryActivityViewController"),
                self.newColoredViewController("GraphsViewController"),
                self.newColoredViewController("SplitsViewController")
               ]
    }()
    func pageViewController(pageViewController: UIPageViewController,
                            viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(pageViewController: UIPageViewController,
                            viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    private func newColoredViewController(color: String) -> UIViewController {
        let viewController = UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewControllerWithIdentifier("\(color)");
        if color == "SummaryActivityViewController"
        {
            sumViewController =  viewController as! SummaryActivityViewController
            sumViewController.mapData = mapData;
           
        }else if color == "GraphsViewController"
        {
            self.graphViewController = viewController as! GraphsViewController
            self.graphViewController.mapData = self.mapData;
//            self.graphViewController.avgSpeedValue = self.mapData.avgSpeed!
//            self.graphViewController.totalDistanceValue = self.mapData.distance!;
//            self.graphViewController.maxElevationValue = self.mapData.maxElevation!;
//            self.graphViewController.heartRateValue = self.mapData.heartRate;
            
        }else{
            self.splitsViewController = viewController as!  SplitsViewController;
           self.splitsViewController.splitChartValues = self.mapData.splitGraphValues;
        }
        return viewController;
    }
    func pageViewController(pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                                               previousViewControllers: [UIViewController],
                                               transitionCompleted completed: Bool) {
        if let firstViewController = viewControllers?.first,
            let index = orderedViewControllers.indexOf(firstViewController) {
            ActivityDetailsDelegate?.tutorialPageViewController(self,
                                                         didUpdatePageIndex: index)
        }
    }
     /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
protocol TutorialPageViewControllerDelegate: class {
    
    /**
     Called when the number of pages is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter count: the total number of pages.
     */
    func tutorialPageViewController(tutorialPageViewController: TabsViewController,
                                    didUpdatePageCount count: Int)
    
    /**
     Called when the current index is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter index: the index of the currently visible page.
     */
    func tutorialPageViewController(tutorialPageViewController: TabsViewController,
                                    didUpdatePageIndex index: Int)
    
}
