//
//  SliderEditorViewController.swift
//  imglyKit
//
//  Created by Sascha Schwabbauer on 10/04/15.
//  Copyright (c) 2015 9elements GmbH. All rights reserved.
//

import UIKit

@objc(IMGLYSliderEditorViewControllerOptions) public class SliderEditorViewControllerOptions: EditorViewControllerOptions {
    /// Use this closure to configure the filter intensity slider.
    /// Defaults to an empty implementation.
    public let sliderConfigurationClosure: SliderConfigurationClosure

    convenience init() {
        self.init(builder: SliderEditorViewControllerOptionsBuilder())
    }

    init(builder: SliderEditorViewControllerOptionsBuilder) {
        sliderConfigurationClosure = builder.sliderConfigurationClosure
        super.init(editorBuilder: builder)
    }
}

// swiftlint:disable type_name
@objc(IMGLYSliderEditorViewControllerOptionsBuilder) public class SliderEditorViewControllerOptionsBuilder: EditorViewControllerOptionsBuilder {
    // swiftlint:enable type_name

    /// Use this closure to configure the filter intensity slider.
    /// Defaults to an empty implementation.
    public lazy var sliderConfigurationClosure: SliderConfigurationClosure = { _ in }
}

@objc(IMGLYSliderEditorViewController) public class SliderEditorViewController: SubEditorViewController {

    // MARK: - Properties

    public private(set) lazy var slider: UISlider = {
       let slider = UISlider()
        slider.minimumValue = self.minimumValue
        slider.maximumValue = self.maximumValue
        slider.value = self.initialValue
        slider.continuous = true
        slider.addTarget(self, action: "sliderValueChanged:", forControlEvents: .ValueChanged)
        slider.addTarget(self, action: "sliderTouchedUpInside:", forControlEvents: .TouchUpInside)
        slider.translatesAutoresizingMaskIntoConstraints = false
        self.options.sliderConfigurationClosure(slider)
        return slider
    }()

    public var minimumValue: Float {
        // Subclasses should override this
        return -1
    }

    public var maximumValue: Float {
        // Subclasses should override this
        return 1
    }

    public var initialValue: Float {
        // Subclasses should override this
        return 0
    }

    public override var options: SliderEditorViewControllerOptions {
        // Subclasses should override this
        return SliderEditorViewControllerOptions()
    }

    private var changeTimer: NSTimer?
    private var updateInterval: NSTimeInterval = 0.01

    // MARK: - UIViewController

    override public func viewDidLoad() {
        super.viewDidLoad()

        shouldShowActivityIndicator = false
        configureViews()
    }

    // MARK: - Configuration

    private func configureViews() {
        bottomContainerView.addSubview(slider)

        let views = ["slider" : slider]
        let metrics = ["margin" : 20]

        bottomContainerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-(==margin)-[slider]-(==margin)-|", options: [], metrics: metrics, views: views))
        bottomContainerView.addConstraint(NSLayoutConstraint(item: slider, attribute: .CenterY, relatedBy: .Equal, toItem: bottomContainerView, attribute: .CenterY, multiplier: 1, constant: 0))
    }

    // MARK: - Actions

    @objc private func sliderValueChanged(sender: UISlider?) {
        if changeTimer == nil {
            changeTimer = NSTimer.scheduledTimerWithTimeInterval(updateInterval, target: self, selector: "update:", userInfo: nil, repeats: false)
        }
    }

    @objc private func sliderTouchedUpInside(sender: UISlider?) {
        changeTimer?.invalidate()

        valueChanged(slider.value)
        updatePreviewImageWithCompletion {
            self.changeTimer = nil
        }
    }

    @objc private func update(timer: NSTimer) {
        valueChanged(slider.value)
        updatePreviewImageWithCompletion {
            self.changeTimer = nil
        }
    }

    // MARK: - Subclasses

    public func valueChanged(value: Float) {
        // Subclasses should override this
    }

}