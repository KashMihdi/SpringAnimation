//
//  OptionsViewController.swift
//  SpringApp
//
//  Created by Alexey Efimov on 17.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import SpringAnimation

protocol OptionsDisplayLogic: AnyObject {
    func displayOptions(viewModel: OptionsViewModel)
}

class OptionsViewController: UIViewController {
    
    @IBOutlet var modalView: SpringView!
    
    @IBOutlet var dampingLabel: UILabel!
    @IBOutlet var velocityLabel: UILabel!
    @IBOutlet var scaleLabel: UILabel!
    @IBOutlet var xLabel: UILabel!
    @IBOutlet var yLabel: UILabel!
    @IBOutlet var rotateLabel: UILabel!
    
    @IBOutlet var dampingSlider: UISlider!
    @IBOutlet var velocitySlider: UISlider!
    @IBOutlet var scaleSlider: UISlider!
    @IBOutlet var xSlider: UISlider!
    @IBOutlet var ySlider: UISlider!
    @IBOutlet var rotateSlider: UISlider!
        
    var router: (NSObjectProtocol & OptionsRoutingLogic & OptionsDataPassing)?
    var delegate: SpringDisplayLogic!
    
    private var interactor: OptionsBusinessLogic?
    private var request = OptionsRequest()
    
    // MARK: Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        view.addGestureRecognizer(tapGesture)
        interactor?.setOptions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        modalView.animate()
    }

    @IBAction func optionSlider(_ sender: UISlider) {
        switch sender {
        case dampingSlider:
            request.damping = dampingSlider.value
            interactor?.dampingSliderDidChanged(request: request)
        case velocitySlider:
            request.velocity = velocitySlider.value
            interactor?.velocitySliderDidChanged(request: request)
        case scaleSlider:
            request.scale = scaleSlider.value
            interactor?.scaleSliderDidChanged(request: request)
        case xSlider:
            request.x = xSlider.value
            interactor?.xSliderDidChanged(request: request)
        case ySlider:
            request.y = ySlider.value
            interactor?.ySliderDidChanged(request: request)
        default:
            request.rotate = rotateSlider.value
            interactor?.rotateSliderDidChanged(request: request)
        }
        
    }
    
    @IBAction func resetButtonPressed() {
        interactor?.resetButtonPressed()
    }
    
    @objc private func tapAction() {
        modalView.animation = "slideUp"
        modalView.animateToNext {
            self.dismiss(animated: false)
        }
    }
    
    // MARK: Setup
    private func setup() {
        let viewController = self
        let interactor = OptionsInteractor()
        let presenter = OptionsPresenter()
        let router = OptionsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}

// MARK: - OptionsDisplayLogic
extension OptionsViewController: OptionsDisplayLogic {
    func displayOptions(viewModel: OptionsViewModel) {
        dampingSlider.setValue(Float(viewModel.damping), animated: true)
        velocitySlider.setValue(Float(viewModel.velocity), animated: true)
        scaleSlider.setValue(Float(viewModel.scale), animated: true)
        xSlider.setValue(Float(viewModel.x), animated: true)
        ySlider.setValue(Float(viewModel.y), animated: true)
        rotateSlider.setValue(Float(viewModel.rotate), animated: true)
        
        dampingLabel.text = viewModel.dampingText
        velocityLabel.text = viewModel.velocityText
        scaleLabel.text = viewModel.scaleText
        xLabel.text = viewModel.xText
        yLabel.text = viewModel.yText
        rotateLabel.text = viewModel.rotateText
        
        let animation = Animation(
            autostart: viewModel.autostart,
            autohide: viewModel.autohide,
            title: viewModel.title,
            curve: viewModel.curve,
            force: viewModel.force,
            delay: viewModel.delay,
            duration: viewModel.duration,
            damping: viewModel.damping,
            velocity: viewModel.velocity,
            repeatCount: viewModel.repeatCount,
            x: viewModel.x,
            y: viewModel.y,
            scaleX: viewModel.scaleX,
            scaleY: viewModel.scaleY,
            scale: viewModel.scale,
            rotate: viewModel.rotate
        )
        
        let springViewModel = SpringViewModel(animation: animation)
        delegate.displayAnimation(viewModel: springViewModel)
    }
}