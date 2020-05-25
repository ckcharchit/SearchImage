//
//  SearchImageViewController.swift
//  SearchImage
//
//  Created by CHARCHIT KUMAR on 24/05/20.
//  Copyright © 2020 CHARCHIT KUMAR. All rights reserved.
//

import UIKit

class SearchImageViewController: UIViewController {

    var presenter : SearchImagePresentation!
    private var searchBarController: UISearchController!
    private let numberOfRows: CGFloat = 3.0
    private var selectedFrame : CGRect?
    private var navigationInteractor : NavigationInteractor?
    private var selectedImage:UIImage?
    
    @IBOutlet weak var collectionViewImages: UICollectionView!
    @IBOutlet weak var suggestionTableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupSearchController()
        setupSuggestionTableView()
    }
    
    private func setupSearchController() { // Setup search bar and search controller
        searchBarController = UISearchController(searchResultsController: nil)
        searchBarController.delegate = self
        searchBarController.searchBar.delegate = self
        searchBarController.searchBar.enablesReturnKeyAutomatically = true
        searchBarController.hidesNavigationBarDuringPresentation = false
        searchBarController.dimsBackgroundDuringPresentation = false
        navigationItem.searchController = searchBarController
        navigationItem.hidesSearchBarWhenScrolling = false
        presenter.fetchDataPersisted()
    }
    
    private func setupNavigation() { // update navigation bar
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.delegate = self
    }

    private func setupSuggestionTableView() {
        suggestionTableView.isScrollEnabled = true
        suggestionTableView.isHidden = true
    }
}

//MARK:- UISearchControllerDelegate, UISearchBarDelegate
extension SearchImageViewController: UISearchControllerDelegate, UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        suggestionTableView.isHidden = true
        presenter.userSearchedText(text: searchBar.text)
        searchBarController.searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if presenter.numberOfSearches() > 0 {
            suggestionTableView.isHidden = false
            suggestionTableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        suggestionTableView.isHidden = true
    }
}

extension SearchImageViewController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? ImageCollectionViewCell,let model = presenter.modelImage(indexPath: indexPath) else {
            return
        }
        cell.configure(model: model)
        if indexPath.row == (presenter.numberOfImages() - 1) {
            presenter.bottomOfTableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfImages()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width)/numberOfRows, height: (collectionView.bounds.width)/numberOfRows)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let theAttributes:UICollectionViewLayoutAttributes! = collectionView.layoutAttributesForItem(at: indexPath)
        selectedFrame = collectionView.convert(theAttributes.frame, to: collectionView.superview)
        self.searchBarController.isActive = false
        perform(#selector(pushDetailView), with: indexPath, afterDelay: 0.01)
    }
    
    @objc func pushDetailView(indexPath: IndexPath){
        guard let cell = collectionViewImages.cellForItem(at: indexPath) as? ImageCollectionViewCell else {
            return
        }
        self.selectedImage = cell.flickrImageview.image
        presenter.pushDetailImage(indexPath: indexPath, image: selectedImage)
      
    }
}

extension SearchImageViewController: SearchImageView {
    func reloadTable() {
        collectionViewImages.reloadData()
    }
    
    func showError() {
        //handling error
    }
}

extension SearchImageViewController: UINavigationControllerDelegate{
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let ci = navigationInteractor else { return nil }
        return ci.transitionInProgress ? navigationInteractor : nil
    }
    
    internal func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let frame = self.selectedFrame else { return nil }
        guard let selectedImage = selectedImage else { return nil}
        
        switch operation {
        case .push:
            self.navigationInteractor = NavigationInteractor(attachTo: toVC)
            return NavigationAnimator(duration: TimeInterval(UINavigationController.hideShowBarDuration), isPresenting: true, originFrame: frame, image: selectedImage)
        default:
            return NavigationAnimator(duration: TimeInterval(UINavigationController.hideShowBarDuration), isPresenting: false, originFrame: frame, image: selectedImage)
        }
    }
}

extension SearchImageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfSearches()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestionTableViewCell", for: indexPath) as? SuggestionTableViewCell else { return UITableViewCell() }
        cell.suggestionLabel.text = presenter.searchText(indexPath: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        suggestionTableView.isHidden = true
        searchBarController.searchBar.text = presenter.searchText(indexPath: indexPath)
        presenter.userSearchedText(text: presenter.searchText(indexPath: indexPath))
        searchBarController.searchBar.resignFirstResponder()
    }
}

