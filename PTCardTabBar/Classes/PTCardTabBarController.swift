//
//  TabBarControllerViewController.swift
//  SketchNUR
//
//  Created by Hussein Al-Ryalat on 11/12/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit

open class PTCardTabBarController: UITabBarController {
    
    @IBInspectable public var tintColor: UIColor? {
        didSet {
            customTabBar.tintColor = tintColor
            customTabBar.reloadApperance()
        }
    }
    
    @IBInspectable public var tabBarBackgroundColor: UIColor? {
        didSet {
            customTabBar.backgroundColor = tabBarBackgroundColor
            customTabBar.reloadApperance()
        }
    }
    
    public let customTabBar: PTCardTabBar = {
        return PTCardTabBar()
    }()
    
    fileprivate(set) lazy var smallBottomView: UIView = {
        let anotherSmallView = UIView()
        anotherSmallView.backgroundColor = .white
        anotherSmallView.translatesAutoresizingMaskIntoConstraints = false

        return anotherSmallView
    }()
    
    lazy var baseView: UIView = {
        let anotherSmallView = UIView()
        anotherSmallView.backgroundColor = .clear
        anotherSmallView.translatesAutoresizingMaskIntoConstraints = false

        anotherSmallView.layer.shadowColor = UIColor.black.cgColor
        anotherSmallView.layer.shadowOffset = CGSize(width: 3, height: 3)
        anotherSmallView.layer.shadowRadius = 6
        anotherSmallView.layer.shadowOpacity = 0.15
        return anotherSmallView
    }()
    
    override open var selectedIndex: Int {
        didSet {
            customTabBar.select(at: selectedIndex, notifyDelegate: false)
        }
    }

    override open var selectedViewController: UIViewController? {
        didSet {
            customTabBar.select(at: selectedIndex, notifyDelegate: false)
        }
    }
    
    fileprivate var bottomSpacing: CGFloat = 20
    fileprivate var tabBarHeight: CGFloat = 70
    fileprivate var horizontleSpacing: CGFloat = 0/20
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: tabBarHeight + bottomSpacing, right: 0)
        self.tabBar.isHidden = true
        addBaseView()
        addAnotherSmallView()
        setupTabBar()
        
        customTabBar.items = tabBar.items!
        customTabBar.select(at: selectedIndex)
    }
    
    public func setTabBarHidden(_ isHidden: Bool, animated: Bool){
        let block = {
            self.customTabBar.alpha = isHidden ? 0 : 1
            self.additionalSafeAreaInsets = isHidden ? .zero : UIEdgeInsets(top: 0, left: 0, bottom: self.tabBarHeight + self.bottomSpacing, right: 0)
        }
        
        if animated {
            UIView.animate(withDuration: 0.25, animations: block)
        } else {
            block()
        }
    }
    
    fileprivate func addBaseView() {
        view.addSubview(baseView)
        
        baseView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        baseView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        baseView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        //baseView.topAnchor.constraint(equalTo: customTabBar.topAnchor, constant: 0).isActive = true
    }
    
    fileprivate func addAnotherSmallView(){
        baseView.addSubview(smallBottomView)
        smallBottomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        let cr: NSLayoutConstraint
        if #available(iOS 11.0, *) {
            cr = smallBottomView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: tabBarHeight)
        } else {
            cr = smallBottomView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: tabBarHeight)
        }
        
        cr.priority = .defaultHigh
        cr.isActive = true
        
        smallBottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        smallBottomView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    fileprivate func setupTabBar(){
        customTabBar.delegate = self
        baseView.addSubview(customTabBar)
        
        customTabBar.bottomAnchor.constraint(equalTo: smallBottomView.topAnchor, constant: 0).isActive = true
        var bottomPadding:CGFloat = 0
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            bottomPadding = window?.safeAreaInsets.bottom ?? 0
        }
        
        //customTabBar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        customTabBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        customTabBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: horizontleSpacing).isActive = true
        
        customTabBar.heightAnchor.constraint(equalToConstant: tabBarHeight).isActive = true
        
        baseView.topAnchor.constraint(equalTo: customTabBar.topAnchor, constant: 0).isActive = true
        
        self.view.bringSubviewToFront(customTabBar)
        self.view.bringSubviewToFront(smallBottomView)
        
        customTabBar.tintColor = tintColor
    }
    
    
}

extension PTCardTabBarController: CardTabBarDelegate {
    func cardTabBar(_ sender: PTCardTabBar, didSelectItemAt index: Int) {
        self.selectedIndex = index
    }
}

extension UIViewController {
    
    func edgeOfBottom() -> CGFloat {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let bottomPadding = window?.safeAreaInsets.bottom
            return bottomPadding ?? 0
        } else {
            return 0
        }
    }
}
