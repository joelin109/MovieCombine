//
//  SortedButton.swift
//  MovieCombine
//
//  Created by Joe Lin on 28.09.22.
//

import SwiftUI
 
struct MenuList: View {
    @State private var showingAlert = false
    @State private var menuPosition = 10.0
    @State private var menuIndexPre = 2
    @State private var menuIndex = 2
    @ObservedObject var viewModel: MovieViewModel
    private let foreColor = Color.exBlauHell
    private let foreColor2 = Color.exGelb
    private let bkColor = Color.exBlau
    private let width = 44.0
    
    init(viewModel: MovieViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                HStack {
                    Button(
                        action: {
                            
                            if(menuIndex != 0)
                            {
//                                showingAlert = true
//                                menuPosition = 170.0
                                menuIndexPre = menuIndex
                                menuIndex = 0
                                
                                self.viewModel.fetchMovieList(index: menuIndex)
                            }
                            
                        }, label: {
                            Image(systemName: "homekit")
                                .font(.system(size: 22).bold())
                                .aspectRatio(contentMode: .fit)
                                .frame(width: width, height: width)
                                .foregroundColor(menuIndex == 0 ? foreColor2 : foreColor )
                            
                        }
                    )
//                    .background(bkColor)
                    .cornerRadius(22)
                    .padding(EdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 0))
                    .shadow(color: Color.black.opacity(0.3),radius: 3,x: 3,y: 3)
                    
                    
                    Button(
                        action: {
                            if(menuIndex != 1)
                            {
                                showingAlert = true
                                menuPosition = 170.0
                                menuIndexPre = menuIndex
                                menuIndex = 1
                            }
                            
                        }, label: {
                            Image(systemName: "bell")
                                .font(.system(size: 22).bold())
                                .aspectRatio(contentMode: .fit)
                                .frame(width: width, height: width)
                                .foregroundColor(menuIndex == 1 ? foreColor2 : foreColor)
                            
                        }
                    )
//                    .background(bkColor)
                    .cornerRadius(22)
                    .padding(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0))
                    .shadow(color: Color.black.opacity(0.3),radius: 3,x: 3,y: 3)
                    
                    Button(
                        action: {
                            if(menuIndex != 2)
                            {
                                showingAlert = true
                                menuPosition = 170.0
                                menuIndexPre = menuIndex
                                menuIndex = 2
                            }
                            
                        }, label: {
                            Image(systemName: "heart")
                                .font(.system(size: 22).bold())
                                .aspectRatio(contentMode: .fit)
                                .frame(width: width, height: width)
                                .foregroundColor(menuIndex == 2 ? foreColor2 : foreColor)
                            
                        }
                    )
//                    .background(bkColor)
                    .cornerRadius(22)
                    .padding(EdgeInsets(top:2, leading: 0, bottom: 2, trailing: 25))
                    .shadow(color: Color.black.opacity(0.3),radius: 3,x: 3,y: 3)
                    
                }
                .background(bkColor)
                .cornerRadius(30)
//                .padding(EdgeInsets(top: 45, leading: 0, bottom: 0, trailing: -20))
                .padding(EdgeInsets(top: 45, leading: 0, bottom: menuPosition, trailing: -20))
                
                .confirmationDialog("title", isPresented: $showingAlert){
                   
                    Button("Confirm"){
                        self.viewModel.fetchMovieList(index: menuIndex)
                        menuPosition = 10.0
                    }
                    Button("Cancel", role: .cancel){
                        menuIndex = menuIndexPre
                        menuPosition = 10.0
                        
                    }
                    
                }message: {
                    let text = menuIndex != 2 ? "Are you searching the latest movies:\(Int(menuIndex))?" :"Are you searching top rated movies?"
                    Text(text)
                }
            }
            
//            Spacer()
        }
    }
}

