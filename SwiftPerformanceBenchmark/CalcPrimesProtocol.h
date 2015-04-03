//
//  CalcPrimesProtocol.h
//  SwiftPerformanceBenchmark
//
//  Created by Duncan Champney on 4/1/15.
//  Copyright (c) 2015 Duncan Champney. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ComputeRecord;

typedef void (^updateDisplayBlock)(void);
typedef void (^calcPrimesCompletionBlock)(void);

@protocol CalcPrimesProtocol <NSObject>



- (void) calcPrimesWithComputeRecord: (ComputeRecord *) aComputeRecord
              withUpdateDisplayBlock: (updateDisplayBlock) theUpdateDisplayBlock
                  andCompletionBlock: (calcPrimesCompletionBlock) theCalcPrimesCompletionBlock;
+ (id <CalcPrimesProtocol> ) sharedInstance;


@end
