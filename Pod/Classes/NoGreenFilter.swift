//
// NoGreenFilter.swift
//  imglyKit
//
//  Created by Carsten Przyluczky on 28/01/15.
//  Copyright (c) 2015 9elements GmbH. All rights reserved.
//

import Foundation

@objc(IMGLYNoGreenFilter) public class NoGreenFilter: ResponseFilter {
    init() {
        super.init(responseName: "NoGreen")
        self.displayName = "No Green"
    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override var filterType:FilterType {
        get {
            return FilterType.NoGreen
        }
    }
}