//
//  FirstViewController.swift
//  runnur
//
//  Created by Archana Vetkar on 28/07/16.
//  Copyright © 2016 Sonali. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UIPageViewControllerDataSource
{
    
  
    @IBOutlet weak var pageControl: UIPageControl!
    var pageImages: NSArray!
    var pageViewController: UIPageViewController!
  //var pageIndex: Int!
//    var imageFile: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageImages = NSArray(objects:"02_Tutorial01","03_Tutorial02","04_Tutorial03","05_Tutorial04","")
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        self.pageViewController.dataSource = self
        
        let startVc = viewControllerAtIndex(0) as! TourContentViewController;

       let ViewControllers = NSArray(object: startVc)
        self.pageViewController.setViewControllers(ViewControllers as? [UIViewController], direction: .Forward, animated: true, completion: nil)
        
        self.pageViewController.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width , height: self.view.frame.size.height+40)
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        
        view.bringSubviewToFront(pageControl);
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewControllerAtIndex(index: Int) -> UIViewController
    {
        //pageIndex = index;
        if index == 4
        {
            if((self.pageImages.count == 0)||(index >= self.pageImages.count))
            {
                return LoginScreenViewController()
            }
          let vc:LoginScreenViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginScreenViewController") as! LoginScreenViewController
          //  vc.imageFile = self.pageImages[index] as! String
          
            vc.pageIndex = index
            return vc
        }else{
        if((self.pageImages.count == 0)||(index >= self.pageImages.count))
        {
            return TourContentViewController()
        }
        let vc:TourContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ContentViewController") as! TourContentViewController
        
        
        vc.imageFile = self.pageImages[index] as! String
        
        vc.pageIndex = index
        return vc
        }
    }
    

    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        if viewController.isKindOfClass(LoginScreenViewController){
            let vc = viewController as! LoginScreenViewController
               if vc.pageIndex != nil{
            var index = vc.pageIndex as Int
                pageControl.currentPage = 4;

            if(index == NSNotFound)
            {
                return nil
            }
            index += 1
            if(index == self.pageImages.count)
            {
                return nil
            }

            return viewControllerAtIndex(index)
            }
             // pageControl.currentPage = 5;
          return nil
        }else{
            let vc = viewController as! TourContentViewController
             var index = vc.pageIndex as Int
            pageControl.currentPage = index;

        if(index == 0 || index == NSNotFound)
        {
            
            return nil
        }
        if (index < self.pageImages.count)
        {
            
        }
        index -= 1
        return viewControllerAtIndex(index)
        }
    }
    
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        if viewController.isKindOfClass(LoginScreenViewController){
            let vc = viewController as! LoginScreenViewController
            
            if vc.pageIndex != nil{
                
                var index = vc.pageIndex as Int
                pageControl.currentPage = 4;
                
                if(index == NSNotFound)
                {
                    return nil
                }
                index += 1
                if(index == self.pageImages.count)
                {
                    return nil
                }
                
                return viewControllerAtIndex(index )
            }
            return nil
        }else{
            let vc = viewController as! TourContentViewController
            var index = vc.pageIndex as Int
            pageControl.currentPage = index;
            
            if(index == NSNotFound)
            {
                return nil
            }
            index += 1
            if(index == self.pageImages.count)
            {
                return nil
            }
            
            return viewControllerAtIndex(index)
        }
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return /*self.pageImages.count*/5
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return (0)
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
