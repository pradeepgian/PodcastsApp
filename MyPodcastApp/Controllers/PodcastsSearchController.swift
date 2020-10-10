//
//  PodcastsSearchController.swift
//  PodcastsCourseLBTA
//
//  Created by Pradeep Gianchandani on 07/10/20.
//  Copyright © 2020 Brian Voong. All rights reserved.
//

import UIKit
import Alamofire

class PodcastsSearchController: UITableViewController, UISearchBarDelegate {
    
    let cellId = "cellId"
    // lets implement a UISearchController
    let searchController = UISearchController(searchResultsController: nil)
    
//    var podcasts = [
//        Podcast(trackName: "Lets Build That App", artistName: "Brian Voong"),
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
    
    fileprivate func setupSearchController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false // if this is set to true, it dims the background when search bar pops up
        searchController.searchBar.delegate = self
    }
    
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
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        APIService.shared.fetchPodcasts(searchText: searchText) { (podcastsData) in
            self.podcasts = podcastsData
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
}
