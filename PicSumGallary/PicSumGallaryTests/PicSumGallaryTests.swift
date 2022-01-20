//
//  PicSumGallaryTests.swift
//  PicSumGallaryTests
//
//  Created by sara salem on 20/01/2022.
//

import XCTest

import RxCocoa
import RxSwift
import RxTest


@testable import PicSumGallary

class PicSumGallaryTests: XCTestCase {

    var sut: PhotosViewModel!
    let networkMonitor = NetworkMonitor.shared
    
    override func setUpWithError() throws {
      try super.setUpWithError()
      sut = PhotosViewModel()
    }

    override func tearDownWithError() throws {
      sut = nil
      try super.tearDownWithError()
    }

    func testApiCallCompletesFirstCall() throws {
      try XCTSkipUnless(
        networkMonitor.isReachable,
        "Network connectivity needed for this test."
      )

        var page = 1
        sut.nextURLString = "nextURLString"
        var photos = sut.getListPhotos(page: page).subscribe(onNext:{ items in
            XCTAssert(items.count > 0)
            XCTAssertEqual(items.count,10)
        })
    }
    func testApiCallCompletesInPagination() throws {
      try XCTSkipUnless(
        networkMonitor.isReachable,
        "Network connectivity needed for this test."
      )

        var page = 2
        sut.nextURLString = "nextURLString"
        var photos = sut.getListPhotos(page: page).subscribe(onNext:{ items in
            XCTAssert(items.count > 0)
            XCTAssertEqual(items.count,10)
        })
    }
    func testApiCallCompletesInRefreshing() throws {
      try XCTSkipUnless(
        networkMonitor.isReachable,
        "Network connectivity needed for this test."
      )

        var page = 1
        sut.nextURLString = "refreshing"
        var photos = sut.getListPhotos(page: page).subscribe(onNext:{ items in
            XCTAssert(items.count > 0)
            XCTAssertEqual(items.count,10)
        })
    }

}
