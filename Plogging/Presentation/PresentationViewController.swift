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

    private let skipButton = UIButton()

    var pages = [UIViewController]()

    let pageControl = UIPageControl()
    let initialPage = 0

    weak var presentationViewControllerDelegate: PresentationViewControllerDelegate?

    var pageControlBottomAnchor: NSLayoutConstraint?

    private var skipButtonTopAnchor: NSLayoutConstraint?

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        style()
        layout()
    }
}

extension PresentationViewController {

    func setup() {
        dataSource = self
        delegate = self

        let page1 = OnboardingViewController(imageName: "icon", textLabelText: Texts.onBoardingTitle.value, nextContinueButtonTitle: "Next", delegateVC: self)
        let page2 = OnboardingViewController(imageName: "presentation2", textLabelText: Texts.onBoardingTabOne.value, nextContinueButtonTitle: "Next", delegateVC: self)
        let page3 = OnboardingViewController(imageName: "presentation3", textLabelText: Texts.onBoardingTabTwo.value, nextContinueButtonTitle: "Next", delegateVC: self)
        let page4 = OnboardingViewController(imageName: "presentation4", textLabelText: Texts.onBoardingTabThree.value, nextContinueButtonTitle: "Continue", delegateVC: self)

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

        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.setTitleColor(Color().appColor, for: .normal)
        skipButton.setTitle("Skip Intro", for: .normal)
        skipButton.addTarget(self, action: #selector(skipTapped(_:)), for: .primaryActionTriggered)
    }

    func layout() {
        view.addSubview(pageControl)

        view.addSubview(skipButton)

        NSLayoutConstraint.activate([

            skipButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),

            pageControl.widthAnchor.constraint(equalTo: view.widthAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 20),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        pageControlBottomAnchor = view.bottomAnchor.constraint(equalToSystemSpacingBelow: pageControl.bottomAnchor, multiplier: 2)

        pageControlBottomAnchor?.isActive = true

        skipButtonTopAnchor = skipButton.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2)

        skipButtonTopAnchor?.isActive = true
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

    @objc func skipTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        presentationViewControllerDelegate?.didPressDismissButton()
    }
}

extension UIPageViewController {
    func goToNextPage(animated: Bool, completion: ((Bool) -> Void)? = nil) {
        guard let currentPage = viewControllers?[0] else { return }
        guard let nextPage = dataSource?.pageViewController(self, viewControllerAfter: currentPage) else { return }
        setViewControllers([nextPage], direction: .forward, animated: animated, completion: completion)
    }
}

extension PresentationViewController: OnboardingViewControllerDelegate {
    func didTapNextContinueButton() {
        if pageControl.currentPage != pages.count - 1 {
            pageControl.currentPage += 1
            goToNextPage(animated: true)
        } else {
            skipTapped(UIButton())
        }
    }
}
