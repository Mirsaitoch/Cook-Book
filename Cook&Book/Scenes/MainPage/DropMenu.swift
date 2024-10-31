//
//  DropMenu.swift
//  Cook&Book
//
//  Created by Мирсаит Сабирзянов on 20.10.2024.
//

import SwiftUI

struct DropMenu: View {
    @State var showButtons = false
    var plusAction: () -> Void
    var profileAction: () -> Void

    var body: some View {
        if #available(iOS 17.0, *), false {
            VStack {
                Capsule()
                    .fill(.newPink)
                    .frame(width: 50, height: showButtons ? 150 : 50)
                    .animation(.easeInOut(duration: 0.3), value: showButtons)
                    .overlay {
                        VStack {
                            Capsule()
                                .fill(.newPink)
                                .frame(width: 50, height: 50)
                                .shadow(color: .black, radius: showButtons ? 3 : 0, y: showButtons ? 3 : 0)
                                .overlay {
                                    Image(systemName: showButtons ? "chevron.up" : "chevron.down")
                                        .font(.system(size: 20))
                                }
                                .offset(y: 25)
                            
                            Image(systemName: "person")
                                .font(.system(size: 20))
                                .offset(y: showButtons ? 40 : 0)
                                .opacity(showButtons ? 1 : 0)
                                .foregroundStyle(.black)
                                .onTapGesture {
                                    profileAction()
                                    showButtons = false
                                }
                                .disabled(!showButtons)
                            
                            Image(systemName: "plus")
                                .font(.system(size: 20))
                                .offset(y: showButtons ? 60 : 0)
                                .opacity(showButtons ? 1 : 0)
                                .foregroundStyle(.black)
                                .onTapGesture {
                                    plusAction()
                                    showButtons = false
                                }
                                .disabled(!showButtons)
                            Spacer()
                        }
                        .padding(.vertical, -25)
                        .padding(.vertical, -25)
                    }
                    .onTapGesture {
                        withAnimation {
                            showButtons.toggle()
                        }
                    }
                    .contentTransition(.symbolEffect(.replace))
                Spacer()
            }
        } else {
            VStack {
                Capsule()
                    .fill(.newPink)
                    .frame(width: 50, height: showButtons ? 150 : 50)
                    .animation(.easeInOut(duration: 0.3), value: showButtons)
                    .overlay {
                        VStack {
                            Capsule()
                                .fill(.newPink)
                                .frame(width: 50, height: 50)
                                .shadow(color: .black, radius: showButtons ? 3 : 0, y: showButtons ? 3 : 0)
                                .overlay {
                                    Image(systemName: showButtons ? "chevron.up" : "chevron.down")
                                        .font(.system(size: 20))
                                }
                                .offset(y: 25)
                            
                            Image(systemName: "person")
                                .font(.system(size: 20))
                                .offset(y: showButtons ? 40 : 0)
                                .opacity(showButtons ? 1 : 0)
                                .foregroundStyle(.black)
                                .onTapGesture {
                                    profileAction()
                                    showButtons = false
                                }
                                .disabled(!showButtons)
                            
                            Image(systemName: "plus")
                                .font(.system(size: 20))
                                .offset(y: showButtons ? 60 : 0)
                                .opacity(showButtons ? 1 : 0)
                                .foregroundStyle(.black)
                                .onTapGesture {
                                    plusAction()
                                    showButtons = false
                                }
                                .disabled(!showButtons)

                            Spacer()
                        }
                        .padding(.vertical, -25)
                    }
                    .onTapGesture {
                        withAnimation {
                            showButtons.toggle()
                        }
                    }
                Spacer()
            }
        }
    }
}

