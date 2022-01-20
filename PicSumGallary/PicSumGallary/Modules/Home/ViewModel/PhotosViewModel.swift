//
//  HomeViewModel.swift
//  PicSumGallary
//
//  Created by sara salem on 19/01/2022.
//

import RxSwift
import RxCocoa

class PhotosViewModel{
    
    private let interactor: PhotosInteractor? // api di
    private let router: PhotosRouter?
    
    let disposeBag = DisposeBag()
    var alertMessageBehavior = BehaviorRelay<String>(value: "")
    
    // Model Response //
    var PhotosModelBehaviorRelay = BehaviorRelay<[PhotosModel]>(value: [])
    var PhotosModelObservable: Observable<[PhotosModel]> {
        return PhotosModelBehaviorRelay.asObservable()
    }
    
    // pagination //
    var nextURLString: String = "nextURLString"
    let refreshTrigger = PublishSubject<Void>()
    let loadNextPageTrigger = PublishSubject<Void>()
    let error = PublishSubject<Swift.Error>()
    let loading = BehaviorRelay<Bool>(value: false)
    var pageIndex:Int = 1
    
    
    
    init( interactor: PhotosInteractor = PhotosInteractor() , router: PhotosRouter = PhotosRouter() ) { //DI
        self.interactor = interactor
        self.router = router
        
        init_observers()
    }
    
    
    func getListPhotos(page:Int = 1)  -> Observable<[PhotosModel]> {
        return Observable.create { observer in
            //            print("----------nextURLString ---------- ",self.nextURLString)
            if self.nextURLString != "" {
                
                self.interactor?.listPhotos(page:self.pageIndex) { [weak self] data,error in
                    guard let self = self else  { return }
                    if let error = error {
                        print(error.localizedDescription)
                        self.alertMessageBehavior.accept(error.localizedDescription)
                    }else{
                        
                        if let items = data , items.count > 0 {
                            
                            // ------- cashing ------------
                            var citems = PhotoDataCaching.getPhotosData()
                            print("--------count cash-------- ",citems.count,"  self.pageIndex  ",self.pageIndex)
                            
                            
                            if  citems.count < 20 {
                                var all = citems + items
                                PhotoDataCaching.setPhotosData(response: all)
                            }
//                            else{
//                                let data = PhotoDataCaching.getPhotosData()
//                                self.PhotosModelBehaviorRelay.accept(data)
//                            }
                            
                            
                            if self.nextURLString == "refreshing"{
                                self.PhotosModelBehaviorRelay.accept([])
                                self.loading.accept(true)
                                
                            }
                            
                            if (citems.count == 10 && self.pageIndex == 1) ||  (citems.count == 20 && self.pageIndex == 2){
                                self.pageIndex = self.pageIndex + 1
                                self.PhotosModelBehaviorRelay.accept(citems)
                                observer.onNext(citems)
                                observer.onCompleted()
                                return
                            }
                            
                            // ------- cashing ------------
                            
                            self.pageIndex = self.pageIndex + 1
                            
                            var old = self.PhotosModelBehaviorRelay.value
                            var all = old + items
                            self.PhotosModelBehaviorRelay.accept(all)
                            
                            observer.onNext(items)
                            observer.onCompleted()
                        }else{
                            self.nextURLString = ""
                        }
                        
                    }
                }
                
            }
            
            return Disposables.create()
        }
        
    }
    
}


extension PhotosViewModel{
    

    func init_observers(){
        
        var citems = PhotoDataCaching.getPhotosData()
        print("--------count cash--- init ----- ",citems.count,"  self.pageIndex  ",self.pageIndex)
        if (citems.count == 10 && self.pageIndex == 1) ||  (citems.count == 20 && self.pageIndex == 2){
            self.pageIndex = self.pageIndex + 1
            self.PhotosModelBehaviorRelay.accept(citems)
            
        }else if (citems.count == 20 && self.pageIndex == 1){
            self.pageIndex = 3
            self.PhotosModelBehaviorRelay.accept(citems)
        }
        else{
            getListPhotos()
            
        }
        let source = PaginationUISource(refresh: refreshTrigger.asObservable(), loadNextPage: loadNextPageTrigger.asObservable(), bag: disposeBag)

        let sink = PaginationSink(ui: source, loadData: getListPhotos(page:)) // next
        
    }
    
    func goToPhotoDetails(photo:PhotosModel?,from view: UIViewController?){
        
        router?.goToPhotoDetails(photo:photo, from: view)
    }
}
