//
//  ORBEManager.swift
//
//  Created by James Kizer on 1/29/17.
//  Copyright © 2017 Foundry @ Cornell Tech. All rights reserved.
//

import UIKit
import OMHClient
import OhmageOMHSDK
import ResearchSuiteResultsProcessor

open class ORBEManager: RSRPBackEnd {
    
    let transformers: [ORBEIntermediateDatapointTransformer.Type]
    
    public init() {
        self.transformers = [ORBEDefaultTransformer.self]
    }
    
    public init(transformers: [ORBEIntermediateDatapointTransformer.Type]) {
        
        self.transformers = transformers
        
    }
    
    open func add(intermediateResult: RSRPIntermediateResult) {
        
        for transformer in self.transformers {
            if let datapoint: OMHDataPoint = transformer.transform(intermediateResult: intermediateResult) {
                //submit data point
                OhmageOMHManager.shared.addDatapoint(datapoint: datapoint) { (error) in
                    debugPrint(error)
                }
            }
        }
        
    }
    
}
