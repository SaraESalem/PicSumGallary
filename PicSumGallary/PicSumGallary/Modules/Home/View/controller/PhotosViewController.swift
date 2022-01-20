//
//  HomeViewController.swift
//  PicSumGallary
//
//  Created by sara salem on 19/01/2022.
//

import RxSwift
import RxCocoa

class PhotosViewController: UIViewController {
    lazy var citems = PhotoDataCaching.getPhotosData()
    var count = 20
    let disposeBag = DisposeBag()
    var modelDataSource: PhotosModel?
    
    lazy var viewModel: PhotosViewModel = {
        return PhotosViewModel()
    }()
    
    var refreshControl = UIRefreshControl()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vcTitle()
        setUpTableCells()
        pullToRefresh()
        subscribeToCoursesSelection()
        
        setupPagination()
        
        
    }
    func vcTitle(){
        self.title = "Phots"
    }
    func setUpTableCells(){
        tableView.register(UINib(nibName: "PhotosTableViewCell", bundle: .main), forCellReuseIdentifier: "PhotosTableViewCell")
        tableView.register(UINib(nibName: "AdTableViewCell", bundle: .main), forCellReuseIdentifier: "AdTableViewCell")  // 95
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    func pullToRefresh() {
        refreshControl.attributedTitle = NSAttributedString(string: "")
        tableView.addSubview(refreshControl)
    }
    func subscribeToCoursesSelection() {
        Observable
            .zip(tableView.rx.itemSelected, tableView.rx.modelSelected(PhotosModel.self))
            .bind { [weak self] selectedIndex, item in
                
                guard let self = self else { return }
                
                self.viewModel.goToPhotoDetails(photo: item, from: self)
                
            }
            .disposed(by: disposeBag)
        
    }
    
}
extension  PhotosViewController:  UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        if ((indexPath.row + 1) % 6 == 0) {
            return 95
        }
        return 208
    }
}

extension PhotosViewController{
    
    func setupPagination(){
        
        tableView.rx.rx_reachedBottom
            .map{ _ in
                self.viewModel.nextURLString = "nextURLString"
            }
            .bind(to: viewModel.loadNextPageTrigger)
            .disposed(by: disposeBag)
        
        self.refreshControl.rx.controlEvent(.valueChanged)
            .map{ _ in
                self.viewModel.nextURLString = "refreshing"
                self.viewModel.pageIndex = 1
            }
            .bind(to: viewModel.refreshTrigger)
            .disposed(by: disposeBag)
        
        
//        self.viewModel.PhotosModelObservable
//            .bind(to: self.tableView
//                    .rx
//                    .items(cellIdentifier: "PhotosTableViewCell",
//                           cellType: PhotosTableViewCell.self)) { row, item, cell in
//
//                cell.authorName.text = item.author
//                cell.imageName.setImageWithUrlString(urlStr: item.download_url  ?? "", placholder: UIImage(named: "loading"))
//
//            }.disposed(by: disposeBag)
        
        
        self.viewModel.PhotosModelObservable.bind(to: tableView.rx.items){ [self] (tv, row, item) -> UITableViewCell in

            
            if ((row + 1) % 6 == 0) {
            // configure ad cell
                print("add index    " , row)
                let cell = tv.dequeueReusableCell(withIdentifier: "AdTableViewCell", for: IndexPath.init(row: row, section: 0))
                cell.selectionStyle = .none
           
                return cell
            } else {
            
                let cell = tv.dequeueReusableCell(withIdentifier: "PhotosTableViewCell", for: IndexPath.init(row: row, section: 0)) as! PhotosTableViewCell
                cell.selectionStyle = .none
                cell.authorName.text = item.author
                
                if row < self.citems.count {
                    if let url = self.citems[row].download_url{
                        if let img = PhotoDataCaching.getImageData(url: url){
                            cell.imageName.image = img
                        }else{
                            cell.imageName.setImageWithUrlStringToCashe(urlStr: item.download_url  ?? "", placholder: UIImage(named: "loading")){ imageName in

                                if self.citems.count < 20{
                                    if let img = imageName{
                                        PhotoDataCaching.setImageData(imageToCache: img, url:  item.download_url  ?? "")
                                    }
                                }
                            }
                        } // end else
                    }
                }
                else{
                    cell.imageName.setImageWithUrlStringToCashe(urlStr: item.download_url  ?? "", placholder: UIImage(named: "loading")){ imageName in

                        if self.citems.count < 20{
                            if let img = imageName{
                                PhotoDataCaching.setImageData(imageToCache: img, url:  item.download_url  ?? "")
                            }
                        }
                    }

                }
                
                
                return cell
            }
            

           }.disposed(by: disposeBag)
        
        
        
        self.viewModel.loading.asObservable().subscribe(onNext:{ isLoading in
            
            self.refreshControl.endRefreshing()
        })
        
    }
    
    
}
