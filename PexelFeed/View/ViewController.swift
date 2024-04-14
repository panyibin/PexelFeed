//
//  ViewController.swift
//  PexelFeed
//
//  Created by yibin on 2024/4/14.
//

import UIKit
import Alamofire
import SnapKit

class ViewController: UIViewController {
    
    let kPhotoCellReuseId = "kPhotoCellReuseId"    
    var isLoading = false
    
    lazy var viewModel:ViewModel = {
        let viewModel = ViewModel()
        return viewModel
    }()
    
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRectMake(0, 0, 100, 100))
        tableView.backgroundColor = .white
        tableView.register(PhotoCell.self, forCellReuseIdentifier: kPhotoCellReuseId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        return tableView
    }()
    
    lazy var refreshControl:UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Pexel Feed"
        self.view.backgroundColor = .white
        
        self.setupTableView()
        self.tableView.addSubview(refreshControl)
        
        self.loadData()
    }
    
    func setupTableView() {
        self.view.addSubview(self.tableView)
        
        self.tableView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    // load data
    func loadData() {
        self.refreshControl.beginRefreshing()
        
        self.viewModel.loadData {
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    func loadMore() {
        self.viewModel.loadMore {
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }
    }

    @objc func refreshData() {
        self.loadData()
    }

}

extension ViewController:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: kPhotoCellReuseId, for: indexPath) as! PhotoCell
                
        let photo = self.viewModel.photos[indexPath.item]
        
        cell.selectionStyle = .none
        cell.configure(with: photo)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select row:\(indexPath.item)")
        let detailVC = DetailViewController()
        let photo = self.viewModel.photos[indexPath.item]
        detailVC.photo = photo
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        if offsetY >= contentHeight - height {
            self.loadMore()
        }
    }
}
