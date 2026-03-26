//
//  ConfigView.swift
//  TinniPal
//
//  Created by Ferry Dwianta P on 14/02/24.
//

import SwiftUI

struct ConfigView: View {
    @StateObject private var viewModel = ConfigViewModel()
    @State private var stereoValue: Float = 0
    @State private var showMenu = false
    @State private var showInfoSheet = false
    @State private var showClearAlert = false
    
    var body: some View {
        GeometryReader { proxy in
            List {
                SectionView(content: {
                    HStack {
                        ZStack {
                            Text("L")
                                .font(.title3)
                                .bold()
                        }
                        .font(.title2)
                        .foregroundStyle(Color.white)
                        .frame(width: 40, height: 40)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                        
                        Slider(value: $stereoValue, in: -1...1, step: 0.2)
                            .padding(.horizontal, 10)
                            .onChange(of: stereoValue) { newValue in
                                viewModel.updateSoundsStereo(value: stereoValue)
                            }
                        
                        ZStack {
                            Text("R")
                                .font(.title3)
                                .bold()
                        }
                        .font(.title2)
                        .foregroundStyle(Color.white)
                        .frame(width: 40, height: 40)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                    }
                    .padding(.vertical, 4)
                    .onChange(of: stereoValue) { newValue in
                        viewModel.updateSoundsStereo(value: newValue)
                    }
                    
                }, title: "Left-Right")
                
                if viewModel.soundsData.contains(where: { category in
                    category.sounds.contains { $0.isPlaying }
                }) {
                    SectionView(content: {
                        ForEach(viewModel.soundsData.indices, id: \.self) { categoryIndex in
                            ForEach(viewModel.soundsData[categoryIndex].sounds.indices, id: \.self) { soundIndex in
                                if viewModel.soundsData[categoryIndex].sounds[soundIndex].isPlaying {
                                    let soundBinding = Binding<Double>(
                                        get: { viewModel.soundsData[categoryIndex].sounds[soundIndex].volume
                                        },
                                        set: { newValue in
                                            viewModel.updateSoundVolume(categoryIndex: categoryIndex, soundIndex: soundIndex, title: viewModel.soundsData[categoryIndex].sounds[soundIndex].title, value: newValue)
                                        }
                                    )
                                    
                                    SliderConfigView(content: {
                                        Group {
                                            let image = viewModel.soundsData[categoryIndex].sounds[soundIndex].activeIcon
                                            if let _ = UIImage(systemName: image) {
                                                Image(systemName: image)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 20, height: 20)
                                            } else {
                                                Image(image)
                                                    .renderingMode(.template)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 20, height: 20)
                                            }
                                        }
                                    }, sliderValue: soundBinding)
                                    .padding(.top, 4)
                                }
                            }
                        }
                    }, title: "Volumes")
                    .padding(.bottom, 4)
                }
            }
            .listStyle(.insetGrouped)
        }
        .sheet(isPresented: $showInfoSheet, content: {
            InfoView()
        })
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button {
                        showInfoSheet.toggle()
                    } label: {
                        VStack {
                            Text("Info")
                            Image(systemName: "book")
                        }
                    }
                    
                    Button(role: .destructive) {
                        showClearAlert.toggle()
                    } label: {
                        VStack {
                            Text("Clear Sounds")
                            Image(systemName: "trash")
                        }
                    }
                    .disabled(!viewModel.isAnySoundPlaying)
                } label: {
                    Image(systemName: "ellipsis")
                }
                
            }
        }
        .onAppear {
            stereoValue = viewModel.stereoValue
        }
        .alert(isPresented: $showClearAlert) {
            Alert(title: Text("Clear Sounds"), message: Text("Do you want to clear all sounds?"), primaryButton: .destructive(Text("Clear"), action: {
                viewModel.clearAllSounds()
            }), secondaryButton: .cancel(Text("Cancel")))
        }
    }
}

#Preview {
    ConfigView()
}

struct SliderConfigView<ViewContent: View>: View {
    @ViewBuilder let content: ViewContent
    
    @Binding var sliderValue: Double
    
    var body: some View {
        HStack {
            ZStack {
                content
            }
            .font(.title2)
            .foregroundStyle(Color.white)
            .frame(width: 40, height: 40)
            .background(Color.accentColor)
            .cornerRadius(10)
            
            Slider(value: $sliderValue)
                .padding(.horizontal, 10)
            
            ZStack {
                Text(String(format: "%.0f", sliderValue * 100))
                    .font(.body)
            }
            .frame(width: 60, height: 35)
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(12)
        }
    }
}

struct SectionView<ViewContent: View>: View {
    @ViewBuilder let content: ViewContent
    var title: String
    
    var body: some View {
        Section {
            content
            
        } header: {
            Text(title)
                .bold()
                .padding(.bottom, 10)
                .padding(.leading, -16)
        }
        .listSectionSeparator(.hidden)
        .listRowSeparator(.hidden)
    }
}
