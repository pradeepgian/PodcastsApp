//
//  PodcastsSearchController.swift
//  PodcastsCourseLBTA
//
//  Created by Pradeep Gianchandani on 07/10/20
//

import UIKit
import Alamofire

class PodcastsSearchController: UITableViewController, UISearchBarDelegate {
    
    let cellId = "cellId"
    // lets implement a UISearchController
    let searchController = UISearchController(searchResultsController: nil)
    
//    var podcasts = [
//        Podcast(trackName: "Lets Build Podcast App", artistName: "ABC"),
//        Podcast(trackName: "Some Podcast", artistName: "Some Author"),
//    ]
    var podcasts = [Podcast]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchController()
    }
    
    fileprivate func setupTableView() {
        tableView.tableFooterView = UIView()
        let nib = UINib.init(nibName: "PodcastCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Please enter a Search Term"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        self.podcasts.count > 0 ? 0 : 100
    }
    
    var podcastSearchView = Bundle.main.loadNibNamed("PodcastsSearchingView", owner: self, options: nil)?.first as? UIView
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return podcastSearchView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return podcasts.isEmpty && searchController.searchBar.text?.isEmpty == false ? 200 : 0
    }
    
    fileprivate func setupSearchController() {
        self.definesPresentationContext = true //This property needs to be set to true other presented view controller wont display the podcast title
        //This property is used to decide which view controller will determine the size of the presented view controller's view
        //If this property is set to false, then presentation context is provided by UITableViewController instead of PodcastsViewController
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false // if this is set to true, it dims the background when search bar pops up
        searchController.searchBar.delegate = self
    }
    
    //MARK:- UITableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PodcastCell
        cell.podcast = podcasts[indexPath.row]
//        cell.textLabel?.numberOfLines = -1
//        cell.textLabel?.text = "\(podcasts[indexPath.row].trackName ?? "")\n\(podcasts[indexPath.row].artistName ?? "")"
//        cell.imageView?.image = #imageLiteral(resourceName: "appicon")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episodesVC = EpisodesController()
        episodesVC.podcast = self.podcasts[indexPath.row]
        self.navigationController?.pushViewController(episodesVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    //MARK:- UISearchbar Delegate Methods
    var timer:Timer?
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        print(searchText)
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            APIService.shared.fetchPodcasts(searchText: searchText) { (podcastsData) in
                self.podcasts = podcastsData
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
        
    }
    
}
