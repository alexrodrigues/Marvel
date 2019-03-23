//
//  ListViewController.swift
//  Marvel
//
//  Created by Alex Rodrigues on 23/03/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ListViewController: UIViewController {

    private var disponseBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        CharactersService().fetch()
            .subscribe(onNext: { (response) in
                print(response)
            }, onError: { (error) in
                print(error.localizedDescription)
            }).disposed(by: disponseBag)
    }
    
}
