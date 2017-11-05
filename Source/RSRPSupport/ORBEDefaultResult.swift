//
//  ORBEDefaultResult.swift
//  OhmageOMHSDK
//
//  Created by James Kizer on 10/18/17.
//

import UIKit
import ResearchSuiteResultsProcessor
import OMHClient

open class ORBEDefaultResult: RSRPIntermediateResult, RSRPFrontEndTransformer {
    
    private static let supportedTypes = [
        "defaultResult"
    ]
    
    public static func supportsType(type: String) -> Bool {
        return self.supportedTypes.contains(type)
    }
    
    public class func transform(taskIdentifier: String, taskRunUUID: UUID, parameters: [String : AnyObject]) -> RSRPIntermediateResult? {
        
        //extract schema info
        guard let schemaDict = parameters["schema"] as? [String: String],
            let schemaNamespace = schemaDict["namespace"],
            let schemaName = schemaDict["name"],
            let schemaVersion = schemaDict["version"] else {
            return nil
        }
        
        let schema = OMHSchema(name: schemaName, version: schemaVersion, namespace: schemaNamespace)
    
        guard let resultDict = RSRPDefaultResultHelpers.extractResults(parameters: parameters, forSerialization: true) else {
            return nil
        }
        
        let defaultResult = ORBEDefaultResult(
            uuid: UUID(),
            taskIdentifier: taskIdentifier,
            taskRunUUID: taskRunUUID,
            schema: schema,
            resultDict: resultDict)

        defaultResult.startDate = RSRPDefaultResultHelpers.startDate(parameters: parameters)
        defaultResult.endDate = RSRPDefaultResultHelpers.endDate(parameters: parameters)
        
        return defaultResult
        
    }
    
    public let schema: OMHSchema
    public let resultDict: [String: AnyObject]
    
    public init(
        uuid: UUID,
        taskIdentifier: String,
        taskRunUUID: UUID,
        schema: OMHSchema,
        resultDict: [String: AnyObject]
        ) {
        
        self.schema = schema
        self.resultDict = resultDict
        
        super.init(
            type: "OMHDefaultResult",
            uuid: uuid,
            taskIdentifier: taskIdentifier,
            taskRunUUID: taskRunUUID
        )
        
    }

}

extension ORBEDefaultResult: OMHDataPointBuilder {
    
    open var creationDateTime: Date {
        return self.startDate ?? Date()
    }
    
    open var dataPointID: String {
        return self.uuid.uuidString
    }
    
    open var acquisitionModality: OMHAcquisitionProvenanceModality? {
        return .SelfReported
    }
    
    open var acquisitionSourceCreationDateTime: Date? {
        return self.startDate
    }
    
    open var acquisitionSourceName: String? {
        return Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String
    }
    
    open var body: [String: Any] {
        return self.resultDict
    }

}









