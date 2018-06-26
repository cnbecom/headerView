//
//  HeaderView.swift
//  HeaderView
//
//  Created by Becom, Chris on 6/25/18.
//

import UIKit

protocol HeaderViewDelegate: AnyObject {
    func selectedSegmentIndex(_ index: Int)
    func updateHeightConstant(_ constant: CGFloat)
    func forceHeightConstant(_ constant: CGFloat)
}

class HeaderView: UIView {
    
    // MARK: Outlets and Properties
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    weak var delegate: HeaderViewDelegate?
    
    fileprivate var minHeightConstraintConstant: CGFloat = 64
    fileprivate var maxHeightConstraintConstant: CGFloat = 120
    fileprivate var currentHeightConstraintConstant: CGFloat = 120
    fileprivate var previousScrollOffset: CGFloat = 0
    fileprivate var isDragging = false
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    // MARK: Setup
    
    private func setup() {
        backgroundColor = UIColor.white
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    internal func setupSegmentedControlTitles(_ titles: [String]) {
        segmentedControl.removeAllSegments()
        for i in 0..<titles.count {
            segmentedControl.insertSegment(withTitle: titles[i], at: i, animated: false)
        }
        segmentedControl.selectedSegmentIndex = 0
    }
    
    internal func setupHeightConstraintConstants(minimum: CGFloat, maximum: CGFloat) {
        minHeightConstraintConstant = minimum
        maxHeightConstraintConstant = maximum
    }
    
    // MARK: Action Event Handlers
    
    @IBAction func segmentedControlValueChangedActionEvent(_ sender: UISegmentedControl) {
        delegate?.selectedSegmentIndex(sender.selectedSegmentIndex)
    }

}

// MARK: - ScrollView Handlers

extension HeaderView {
    
    // MARK: From parent's UIScrollViewDelegate
    
    internal func handleScrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // Calculate the scroll distance since the last scroll
        let scrollDiff = scrollView.contentOffset.y - previousScrollOffset
        previousScrollOffset = scrollView.contentOffset.y
        
        // If the user is not currently dragging (i.e. the scrollview is inertia scrolling after the user has let up) then return
        if !isDragging {
            return
        }
        
        var isScrollingUp: Bool = false
        
        if scrollDiff > 0 {
            isScrollingUp = true
            
            // If scrolling up, but below the bottom of the scrollview's bottom extent then ignore (this is a bounce up)
            if scrollView.contentOffset.y <= -scrollView.contentInset.top {
                return
            }
            
        } else {
            
            // If scrolling down but above the top of the scrollview's top extent then ignore (this is a bounce down)
            if scrollView.contentSize.height > scrollView.bounds.size.height {
                // If content is larger then scrollview then top extent is contentSize.height - scrollView.height
                if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.bounds.size.height - scrollView.contentInset.top {
                    return
                }
            } else {
                // If content is smaller then scrollview then top extent is contentInset.tep
                if scrollView.contentOffset.y >= -scrollView.contentInset.top {
                    return
                }
            }
        }
        
        if abs(scrollDiff) > 0 {
            
            // Calculate the new header height based on prior height and the scroll difference, but don't go beyond the min or max heights
            var newHeight = currentHeightConstraintConstant
            if isScrollingUp {
                newHeight = max(minHeightConstraintConstant, currentHeightConstraintConstant - abs(scrollDiff))
            } else {
                newHeight = min(maxHeightConstraintConstant, currentHeightConstraintConstant + abs(scrollDiff))
            }
            
            if newHeight != currentHeightConstraintConstant {
                
                // If the height has changed then update the header
                updateSubviewsAlphaTransparencies()
                currentHeightConstraintConstant = newHeight
                //                delegate?.updateHeightConstant(currentHeightConstraintConstant)
                scrollView.contentInset = UIEdgeInsets(top: newHeight, left: 0, bottom: 0, right: 0)
            }
        }
        
    }
    
    internal func handleScrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDragging = true
    }
    
    internal func handleScrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if !decelerate {
            isDragging = false
            scrollViewDidStopScrolling(scrollView)
        }
    }
    
    internal func handleScrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if isDragging {
            isDragging = false
            scrollViewDidStopScrolling(scrollView)
        }
    }
    
    // MARK: Helper
    
    private func scrollViewDidStopScrolling(_ scrollView: UIScrollView) {
        
        let range = maxHeightConstraintConstant - minHeightConstraintConstant
        let midPoint = minHeightConstraintConstant + (range / 2)
        if currentHeightConstraintConstant > midPoint {
            expandHeader(scrollView)
        } else {
            collapseHeader(scrollView)
        }
    }
    
    private func updateSubviewsAlphaTransparencies() {
        
        let range = maxHeightConstraintConstant - minHeightConstraintConstant
        let openAmount = currentHeightConstraintConstant - minHeightConstraintConstant
        let percentage = openAmount / range
        
        if percentage > 0.90 {
            titleLabel.alpha = 1.0
            subTitleLabel.alpha = 1.0
            segmentedControl.alpha = 1.0
        } else {
            titleLabel.alpha = percentage
            subTitleLabel.alpha = percentage
            segmentedControl.alpha = percentage * 0.15
        }
        
    }
    
    private func collapseHeader(_ scrollView: UIScrollView) {
        
        scrollView.contentInset = UIEdgeInsets(top: minHeightConstraintConstant, left: 0, bottom: 0, right: 0)
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.1,
                                                       delay: 0,
                                                       options: [],
                                                       animations: {
                                                        
                                                        self.titleLabel.alpha = 0.0
                                                        self.subTitleLabel.alpha = 0.0
                                                        self.segmentedControl.alpha = 0.0
        })
        //        delegate?.forceHeightConstant(minHeightConstraintConstant)
        
    }
    
    private func expandHeader(_ scrollView: UIScrollView) {
        
        scrollView.contentInset = UIEdgeInsets(top: maxHeightConstraintConstant, left: 0, bottom: 0, right: 0)
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.1,
                                                       delay: 0,
                                                       options: [],
                                                       animations: {
                                                        
                                                        self.titleLabel.alpha = 1.0
                                                        self.subTitleLabel.alpha = 1.0
                                                        self.segmentedControl.alpha = 1.0
        })
        //        delegate?.forceHeightConstant(maxHeightConstant)
        
    }
    
}
