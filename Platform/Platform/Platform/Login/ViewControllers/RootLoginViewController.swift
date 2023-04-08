//
//  RootLoginViewController.swift
//  Choosi
//
//  Created by Developer on 07.07.2022.
//

import UIKit

class RootLoginViewController: BaseViewController {

    @IBOutlet weak var continueWithEmailButton: AppButton!
    @IBOutlet weak var continueWithFacebookButton: AppButton!
    @IBOutlet weak var continueAsGuestButton: AppButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareUI()
    }
    
    private func prepareUI() {
        continueWithEmailButton.prepareLightPrimaryButton()
        continueWithFacebookButton.prepareLightPrimaryButton()
        continueAsGuestButton.prepareSecondaryButton()
    }
	
}
