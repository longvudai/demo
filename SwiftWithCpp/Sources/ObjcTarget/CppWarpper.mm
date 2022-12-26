//
//  CppWarpper.m
//  Test
//
//  Created by Long Vu on 23/12/2022.
//

#import "CppWrapper.hpp"
#include "StringMaker.hpp"

#import <Foundation/Foundation.h>
#include <string>
#include <iostream>

using namespace std;

@implementation CppWrapper

-(NSString *)generateHelloWorld {
    StringMaker maker;
    const string str = maker.generateHelloWorld();
    
    const char * chars = str.c_str();
    return [[NSString alloc] initWithCString:chars encoding:NSUTF8StringEncoding];
}

@end
