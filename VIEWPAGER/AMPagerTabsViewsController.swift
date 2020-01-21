//
//  AMPagerTabsViewsControllers.swift
//  MusicAppWorld
//
//  Created by Shikha on 03/10/19.
//  Copyright © 2019 webcreaters. All rights reserved.
//

import UIKit

class AMPagerTabsViewController: UIViewController {
    
    private var tabScrollView: UIScrollView!
    private var containerScrollView: UIScrollView!
    
    private var tabButtons: [AMTabButton] = []
    private var line = AMLineView()
    private var lastSelectedViewIndex = 0
    
    /// The object that acts as the delegate of the `AMPagerTabsViewController`.
    var delegate: AMPagerTabsViewControllerDelegate?
    /// The property that hold the style and settings for the `AMPagerTabsViewController`.
    let settings = AMSettings()
    
    /// The `ViewContollers` you want to show in the tabs.
    var viewControllers: [UIViewController] = [] {
        willSet {
            checkIfCanChangeValue(withErrorMessage: "You can't set the viewControllers twice")
        }
        didSet {
            addTabButtons()
            moveToViewContollerAt(index: firstSelectedTabIndex)
        }
    }
    
    /// The first selected item when the tabs loaded.
    var firstSelectedTabIndex = 0 {
        willSet {
            checkIfCanChangeValue(withErrorMessage: "You must set the first selected tab index before set the viewcontrollers")
        }
    }
    
    /// The custom font for the tab title.
    var tabFont: UIFont = UIFont.systemFont(ofSize: 15) {
        willSet {
            checkIfCanChangeValue(withErrorMessage: "You must set the font before set the viewcontrollers")
        }
    }
    
    /// A Boolean value that indicates if the tabs should fit in the screen
    /// or should go out of the screen. `true` is the default.
    var isTabButtonShouldFit = false {
        willSet {
            checkIfCanChangeValue(withErrorMessage: "You must set the isTabButtonShouldFit before set the viewcontrollers")
        }
    }
    
    /// A Boolean value that determines whether scrolling is enabled.
    var isPagerScrollEnabled: Bool = true{
        didSet{
            containerScrollView.isScrollEnabled = isPagerScrollEnabled
        }
    }
    
    /// The color of the line in the tab.
    var lineColor: UIColor? {
        get {
            return line.backgroundColor
        }
        set {
            line.backgroundColor = newValue
        }
    }
    
    
    // MARK: ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initScrollView()
        
        updateScrollViewsFrames()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        children.forEach { $0.beginAppearanceTransition(true, animated: animated) }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateScrollViewsFrames()
        children.forEach { $0.endAppearanceTransition() }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        children.forEach { $0.beginAppearanceTransition(false, animated: animated) }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        children.forEach { $0.endAppearanceTransition() }
    }
    
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        coordinator.animate(alongsideTransition: { [weak self] _ in
            guard let controller = self else{ return }
            controller.updateSizes()
        })
        
    }
    
    
    private func initScrollView() {
        
        tabScrollView = UIScrollView(frame: CGRect.zero)
        tabScrollView.backgroundColor = settings.tabBackgroundColor
        tabScrollView.bounces = false
        tabScrollView.showsVerticalScrollIndicator = false
        tabScrollView.showsHorizontalScrollIndicator = false
        tabScrollView.layer.shadowColor = UIColor.lightGray.cgColor
        tabScrollView.layer.shadowOffset = CGSize(width: 0, height: 0.0)
        tabScrollView.layer.shadowRadius = 2.0
        tabScrollView.layer.shadowOpacity = 5.0
        tabScrollView.layer.masksToBounds = false
        
        containerScrollView = UIScrollView(frame: view.frame)
        containerScrollView.backgroundColor = settings.pagerBackgroundColor
        containerScrollView.delegate = self
        containerScrollView.bounces = false
        containerScrollView.scrollsToTop = false
        containerScrollView.showsVerticalScrollIndicator = false
        containerScrollView.showsHorizontalScrollIndicator = false
        containerScrollView.isPagingEnabled = true
        containerScrollView.isScrollEnabled = isPagerScrollEnabled
        
        self.view.addSubview(containerScrollView)
        self.view.addSubview(tabScrollView)
    }
    
    private func addTabButtons() {
        
        let viewWidth = self.view.frame.size.width
        let viewControllerCount = CGFloat(viewControllers.count)
        // Devide the width of the view between the tabs
        var width = viewWidth / viewControllerCount
        let widthOfAllTabs = (viewControllerCount * settings.initialTabWidth)
        if !isTabButtonShouldFit && viewWidth < widthOfAllTabs {
            width = settings.initialTabWidth
        }
        
        for i in 0..<viewControllers.count {
            let tabButton = AMTabButton(frame: CGRect(x: width*CGFloat(i), y: 100, width: width, height: settings.tabHeight))
            let title = viewControllers[i].title
            if title == nil {
                assertionFailure("You need to set a title for the view contoller \(String(describing: viewControllers[i])) , index: \(i)")
            }
            tabButton.setTitle(title , for: .normal)
            tabButton.backgroundColor = settings.tabButtonColor
            tabButton.setTitleColor(settings.tabButtonTitleColor, for: .normal)
            tabButton.titleLabel?.font = tabFont
           
          
            
            tabButton.index = i
            tabButton.addTarget(self, action: #selector(tabClicked(sender:)), for: .touchUpInside)
            tabScrollView.addSubview(tabButton)
            tabButtons.append(tabButton)
        }
        
        line.frame = tabButtons.first!.frame
        line.backgroundColor = lineColor ?? UIColor.red   // CHANGE LINE COLOR TAB BUTTON
        tabScrollView.addSubview(line)
    }
    
    // MARK: Controlling tabs
    
    @objc private func tabClicked(sender: AMTabButton){
        
        moveToViewContollerAt(index: sender.index!)
    }
    
    /// Move the view controller to the passed index
    ///
    /// - parameter index: The index of the view controller to show
    func moveToViewContollerAt(index: Int) {
        
        lastSelectedViewIndex = index
        
        let barButton = tabButtons[index]
        animateLineTo(frame: barButton.frame)
        
        let contoller = viewControllers[index]
        if contoller.view?.superview == nil {
            addChild(contoller)
            containerScrollView.addSubview(contoller.view)
            contoller.didMove(toParent: self)
            updateSizes()
        }
        
        changeShowingControllerTo(index: index)
        
        delegate?.tabDidChangeTo(index)
    }
    
    private func changeShowingControllerTo(index: Int) {
        containerScrollView.setContentOffset(CGPoint(x: self.view.frame.size.width*(CGFloat(index)), y: 0), animated: true)
    }
    
    
    
    // MARK: Animation
    
    private func animateLineTo(frame: CGRect) {
        
        UIView.animate(withDuration: 0.1) {
            self.line.frame = frame
            self.line.draw(frame)
        }
    }
    
    // MARK: Setup Sizes
    
    private func updateScrollViewsFrames() {
        
        tabScrollView.frame = CGRect(x: 0, y: 30, width: self.view.frame.size.width, height: settings.tabHeight)
        containerScrollView.frame = CGRect(x: 0, y: settings.tabHeight, width: self.view.frame.size.width, height: self.view.frame.size.height - settings.tabHeight)
    }
    
    private func updateSizes() {
        
        updateScrollViewsFrames()
        
        let width = self.view.frame.size.width
        let viewWidth = self.view.frame.size.width
        let viewControllerCount = CGFloat(viewControllers.count)
        var tabWidth = viewWidth / viewControllerCount
        if !isTabButtonShouldFit && viewWidth < (viewControllerCount * settings.initialTabWidth) {
            tabWidth = settings.initialTabWidth
        }
        
        for i in 0..<viewControllers.count {
            let view = viewControllers[i].view
            let tabButton = tabButtons[i]
            view?.frame = CGRect(x: width*CGFloat(i), y: 0, width: width, height: containerScrollView.frame.size.height)
            tabButton.frame = CGRect(x: tabWidth*CGFloat(i), y: 0, width: tabWidth, height: settings.tabHeight)
        }
        
        containerScrollView.contentSize = CGSize(width: width*viewControllerCount, height: containerScrollView.frame.size.height)
        tabScrollView.contentSize = CGSize(width: tabWidth*viewControllerCount, height: settings.tabHeight)
        
        changeShowingControllerTo(index: lastSelectedViewIndex)
        
        animateLineTo(frame: tabButtons[lastSelectedViewIndex].frame)
    }
    
    private func checkIfCanChangeValue(withErrorMessage message:String) {
        
        if viewControllers.count != 0 {
            assertionFailure(message)
        }
    }
}


// MARK: UIScrollViewDelegate
extension AMPagerTabsViewController:UIScrollViewDelegate {
    
    var currentPage: Int {
        
        return Int((containerScrollView.contentOffset.x + (0.5*containerScrollView.frame.size.width))/containerScrollView.frame.width)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if decelerate == false {
            moveToViewContollerAt(index: currentPage)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        moveToViewContollerAt(index: currentPage)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
    }
}

class AMSettings{
    
     var tabBackgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
     var tabButtonColor = #colorLiteral(red: 0.1568627451, green: 0.6588235294, blue: 0.8901960784, alpha: 1)
     var tabButtonTitleColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
     var pagerBackgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
     var tabButtonselectedTextColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
   
     
    
    
    var initialTabWidth:CGFloat = 20
    var tabHeight:CGFloat = 97
}

// MARK: AMTabViewControllerDelegate

/// The delegate of the `AMPagerTabsViewController` contoller must
/// adopt the `AMPagerTabsViewControllerDelegate` protocol to get notfiy when tab change
protocol AMPagerTabsViewControllerDelegate {
    /// Tells the delegate that the tab changed to `index`
    ///
    /// - parameter index: The index of the current view controller
    func tabDidChangeTo(_ index:Int);
}


