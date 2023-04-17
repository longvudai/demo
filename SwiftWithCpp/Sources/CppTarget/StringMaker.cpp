//
//  StringMaker.cpp
//  
//
//  Created by Long Vu on 26/12/2022.
//

#include "StringMaker.hpp"

#include <iostream>

using namespace std;

StringMaker::StringMaker() {
    cout << "Init String Maker" << endl;
};

string StringMaker::generateHelloWorld() {
    return "hello world!";
}
