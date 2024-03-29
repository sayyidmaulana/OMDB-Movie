//
//  OMDBRouter.swift
//  OMDBMovie
//
//  Created by sayyid.maulana.yakin on 29/03/24.
//

import Foundation
import UIKit

protocol RouteModuleProtocol {
    static func route() -> UIViewController
    init(viewController: OMDBViewController)
}

class OMDBRouter: RouteModuleProtocol {
    
    static func route() -> UIViewController {
        let viewController = OMDBViewController()
        let interactor = OMDBInteractor()
        let presenter = OMDBPresenter()
        let router = OMDBRouter(viewController: viewController)

        viewController.presenter = presenter

        presenter.view = viewController
        presenter.interactor = interactor
        presenter.router = router

        interactor.presenter = presenter

        return viewController
    }

    unowned let viewController: OMDBViewController

    required init(viewController: OMDBViewController) {
        self.viewController = viewController
    }

}
