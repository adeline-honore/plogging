//
//  PresentationViewController.swift
//  Plogging
//
//  Created by HONORE Adeline on 01/10/2022.
//

import UIKit

protocol PresentationViewControllerDelegate: AnyObject {
    func didPressDismissButton()
}

class PresentationViewController: UIPageViewController {

    // MARK: - Properties
    
    var pages = [UIViewController]()
    
    let pageControl = UIPageControl()
    let initialPage = 0
    
    weak var presentationViewControllerDelegate: PresentationViewControllerDelegate?

    var pageControlBottomAnchor: NSLayoutConstraint?
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        style()
        layout()
    }
    
    
    // MARK: - Dismiss View Controller
    
    func passPresentation() {
        self.dismiss(animated: true, completion: nil)
        presentationViewControllerDelegate?.didPressDismissButton()
    }
}

extension PresentationViewController {
    
    func setup() {
        dataSource = self
        delegate = self
        
//        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)

        let page1 = OnboardingViewController(textLabelText: Texts.onBoardingTitle.value)
        let page2 = OnboardingViewController(textLabelText: Texts.onBoardingTabOne.value)
        let page3 = OnboardingViewController(textLabelText: Texts.onBoardingTabTwo.value)
        let page4 = EndPresentationViewController()
        
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        pages.append(page4)
        
        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
    }
    
    func style() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .systemGray2
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = initialPage
    }
    
    func layout() {
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.widthAnchor.constraint(equalTo: view.widthAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 20),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        pageControlBottomAnchor = view.bottomAnchor.constraint(equalToSystemSpacingBelow: pageControl.bottomAnchor, multiplier: 2)

        pageControlBottomAnchor?.isActive = true
    }
}

// MARK: - DataSource

extension PresentationViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        
        if currentIndex == 0 {
            return pages.last
        } else {
            return pages[currentIndex - 1]
        }
    }
        
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }

        if currentIndex < pages.count - 1 {
            return pages[currentIndex + 1]
        } else {
            return pages.first
        }
    }
}

// MARK: - Delegates

extension PresentationViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let viewControllers = pageViewController.viewControllers else { return }
        guard let currentIndex = pages.firstIndex(of: viewControllers[0]) else { return }
        
        pageControl.currentPage = currentIndex
        showControls()
    }

    private func showControls() {
        pageControlBottomAnchor?.constant = 16
    }
}

// MARK: - Actions

extension PresentationViewController {

    @objc func pageControlTapped(_ sender: UIPageControl) {
        setViewControllers([pages[sender.currentPage]], direction: .forward, animated: true, completion: nil)
    }
}
