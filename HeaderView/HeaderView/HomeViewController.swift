//
//  HomeViewController.swift
//  HeaderView
//
//  Created by Becom, Chris on 6/25/18.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: Constants
    
    private let headerviewNibName = "HeaderView"
    
    // MARK: Outlets and Properties
    
    @IBOutlet weak var headerViewContainerView: UIView!
    @IBOutlet weak var headerViewContainerViewLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    fileprivate var headerView: HeaderView?
    fileprivate var navigationBarHeight: CGFloat = 64
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scrollView.delegate = self
        setupNavigationBar()
        setupHeaderview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.navigationBar.isTranslucent = true


    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        navigationController?.navigationBar.isTranslucent = false
    }
    
    // MARK: Setup
    
    private func setupNavigationBar() {
        
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.tintColor = UIColor.darkGray
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = false
        if let font = UIFont(name: "Copperplate", size: 17.0) {
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray,
            NSAttributedString.Key.font: font]
        } else {
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        }
        navigationBarHeight = navigationBar.frame.height
        title = ""
    }
    
    private func setupHeaderview() {
        
        if let subview = Bundle.main.loadNibNamed(headerviewNibName, owner: self, options: nil)?.first as? HeaderView {
            subview.frame = headerViewContainerView.frame
            headerViewContainerView.addSubview(subview)
            let left = NSLayoutConstraint(item: subview, attribute: .left, relatedBy: .equal, toItem: headerViewContainerView, attribute: .left, multiplier: 1, constant: 0)
            let top = NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: headerViewContainerView, attribute: .top, multiplier: 1, constant: 0)
            let right = NSLayoutConstraint(item: subview, attribute: .right, relatedBy: .equal, toItem: headerViewContainerView, attribute: .right, multiplier: 1, constant: 0)
            let bottom = NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: headerViewContainerView, attribute: .bottom, multiplier: 1, constant: 0)
            headerViewContainerView.addConstraints([left, right, top, bottom])
            headerView = subview
        }
        headerView?.setupSegmentedControlTitles(["One", "Two", "Three"])
        headerView?.setupHeightConstraintConstants(minimum: navigationBarHeight, maximum: headerViewContainerViewLayoutConstraint.constant)
        headerView?.delegate = self
        view.layoutIfNeeded()
    }

}

extension HomeViewController: HeaderViewDelegate {
    
    func selectedSegmentIndex(_ index: Int) {
        print(#function)
    }
    
    func updateHeightConstant(_ constant: CGFloat) {
        print(#function)
    }
    
    func forceHeightConstant(_ constant: CGFloat) {
        print(#function)
    }
    
}

extension HomeViewController: UIScrollViewDelegate {
 
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        headerView?.handleScrollViewDidScroll(scrollView)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        headerView?.handleScrollViewWillBeginDragging(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        headerView?.handleScrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        headerView?.handleScrollViewDidEndDecelerating(scrollView)
    }
    
}
