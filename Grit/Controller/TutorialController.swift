//
//  TutorialController.swift
//  Grit
//
//  Created by Jake Alvord on 4/4/18.
//  Copyright © 2018 Jared Williams. All rights reserved.
//

import UIKit

protocol TutorialControllerDelegate {
    func dismissTutorial()
}

class TutorialController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var tutorialDelegate : TutorialControllerDelegate! = nil
    
    var views : [UIViewController]? = nil
    var index = 0
    
    let basics : [String] = ["basicsFirstPage", "basicsSecondPage", "basicsThirdPage"]
    let basicsDescribes : [String] = ["On the profile page you have the ability to edit your profile and sign out, and there is a list of many available resources", "The map allows you to select a filter and find helpful locations such as transportation and employers"]
    let colors : [UIColor] = [UIColor.red, UIColor.blue]
    let images : [UIImage] = [UIImage(named: "screenshot1_8+")!, UIImage(named: "screenshot2_8+")!]
    
    var pageControl = UIPageControl()
    
    var width = CGFloat(0)
    var height = CGFloat(0)
    
    override func viewDidLoad() {
        
        width = self.view.bounds.width
        height = self.view.bounds.height
        
        dataSource = self
        
        views = tutorialViews()
        
        self.view.bringSubview(toFront: self.pageControl)
        
        if let first_view = views?.first {
            setViewControllers([first_view], direction: .forward, animated: true, completion: nil)
        }
        
    }
    
    override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tutorialViews() -> [TutorialView] {
        
        var tutorials = [TutorialView]()
        
        var i = 0
        for _ in basics {
            
            let view = TutorialView()
            if i + 1 == basics.count {
                view.notLastBool = false
                view.superTutorial = self
            } else {
                view.notLastBool = true
                view.backgroundColor = colors[i]
                view.describe = basicsDescribes[i]
                view.backgroundImage = images[i]
                view.superTutorial = self
            }
            
            tutorials.append(view)
            i = i + 1
        }
        
        return tutorials
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = views?.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return views!.last
        }
        
        guard (views?.count)! > previousIndex else {
            return nil
        }
        
        return views?[previousIndex]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = views?.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = views?.count
        
        guard orderedViewControllersCount != nextIndex else {
            return views!.first
        }
        
        guard orderedViewControllersCount! > nextIndex else {
            return nil
        }
        
        return views?[nextIndex]
        
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.lightGray
        appearance.currentPageIndicatorTintColor = UIColor.black
        appearance.backgroundColor = UIColor.white
        
        return views!.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    @objc func backToBeginning() {
        if let first_view = views?.first {
            setViewControllers([first_view], direction: .forward, animated: true, completion: nil)
        }
    }
    
    @objc func triggerDismiss() {
        dismissCurrentTutorial()
    }
    
    func dismissCurrentTutorial() {
        self.tutorialDelegate.dismissTutorial()
    }
}
