//
//  ConsentSample.swift
//  OMHClient
//
//  Created by James Kizer on 1/13/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import OMHClient

final class ConsentSample: OMHMediaDataPointBase {

    
    public init(consentURL: URL) {
        
        super.init()
        
        let attachment = OMHMediaAttachment(fileName: "consent", fileURL: consentURL, mimeType: "application/pdf")
        self.addAttachment(attachment: attachment)
        
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    static var supportsSecureCoding: Bool {
        return true
    }
    
    override var schema: OMHSchema {
        return OMHSchema(
            name: "example-consent",
            version: "1.1",
            namespace: "cornell")
    }
    
    override var body: [String: Any] {
        return ["consent": "consent"]
    }
}
