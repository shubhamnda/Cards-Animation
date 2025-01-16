//
//  ContentView.swift
//  Screeno Wall
//
//  Created by Shubham Nanda on 16/01/25.
//

import SwiftUI

struct HomeView: View {
    @State private var expandCards = false
    @State private var showDetailView = false
    @State private var showDetailContent = false
    @Namespace private var animation
    @State private var selectedCard: Card?
    @State private var size: CGSize = .zero
    @State private var isMovingAround = true
    var body: some View { GeometryReader { proxy in
        let size = proxy.size
        VStack(spacing:0) {
            HStack {
                Image(systemName: "line.3.horizontal")
                    .imageScale(.large)
                    .foregroundStyle(.black)
                
                Spacer()
                Image(systemName: "person.fill")
                    .imageScale(.large)
                    .foregroundStyle(.white
                    ).background(Color.black).clipShape(Circle())
                
            }.padding([.horizontal,.top],15)
            Cardsview().padding(.horizontal)
            ScrollView(.vertical,showsIndicators: false) {
                VStack(spacing: 15) {
                    
                    BottomScrollContent()
                }.padding([.horizontal,.bottom],15)
            }.frame(maxWidth: .infinity).background {
                CustomCorner(corners: [.topLeft,.topRight], radius: 30).fill(.black).ignoresSafeArea().shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: -5)
                
            }.padding(.top,40)
        }  .onAppear {
            self.size = size
        }}.background {
            Rectangle().fill(.black.opacity(0.05)).ignoresSafeArea()
        }.overlay(content: {
            Rectangle().fill(.ultraThinMaterial).ignoresSafeArea().overlay(alignment: .top, content: {
                HStack {
                    Image(systemName: "chevron.left").font(.title3).fontWeight(.bold).foregroundStyle(.black).contentShape(Rectangle()).onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            expandCards = false
                        }
                    }
                    Spacer()
                    Text("All Cards").font(.title2.bold())
                }.padding(15)
            }).opacity(expandCards ? 1:0)
        }).overlay(content: {
            if let selectedCard, showDetailView {
                DetailView(selectedCard).transition(.asymmetric(insertion: .identity, removal: .offset(y:5)))
            }
        }) .overlayPreferenceValue(CardRectKey.self) { preferences in
            if let cardPreference = preferences["CardRect"] {
                GeometryReader { proxy in
                    let cardRect = proxy[cardPreference]
                    CardContent().frame(width: cardRect.width, height: expandCards ? nil : cardRect.height).offset(x:cardRect.minX,y:cardRect.minY)             }.allowsHitTesting(!showDetailView)
            }
        }
    }
    func indexOf(_ card :Card) -> Int {
        return cards.firstIndex {
            card.id == $0.id
            
        } ?? 0
    }
    @ViewBuilder
    func DetailView(_ card: Card) -> some View {
        VStack(spacing:0) {
            HStack {
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showDetailContent = false
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline:.now() + 0.1) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showDetailView = false
                            
                        }
                    }
                } label: {
                    Image(systemName: "chevron.left").font(.title3.bold())
                }
                Spacer()
                Text("Transactions").font(.title2.bold())
            }.foregroundColor(.black).padding(15).opacity(showDetailContent ? 1 : 0)
            CardView(card).rotation3DEffect(.init(degrees:  (showDetailContent ? 0 : -15)), axis: (x : 1,y : 0,z : 0),anchor: .top).matchedGeometryEffect(id: card.id, in: animation).frame(height: 200).padding([.horizontal,.top],15).zIndex(1000)
            ScrollView(.vertical,showsIndicators: false) {
                VStack {
                    HStack(spacing:12) {
                        Spacer()
                        Text("Content Here").font(.largeTitle.bold()).foregroundStyle(.white)
                       
                        Spacer()
                    }
                }.padding(.top,25).padding([.horizontal,.bottom],15)
            }.background {
                CustomCorner(corners: [.topLeft,.topRight], radius: 30).fill(.black).padding(.top,-120).ignoresSafeArea()
            }.offset(y : !showDetailContent ? (size.height ) : 0).opacity(showDetailContent ? 1:0)
        }.frame(maxHeight: .infinity,alignment: .top).background {
            Rectangle().fill(.green).ignoresSafeArea().opacity(showDetailContent ? 1 : 0)
        }    }
    @ViewBuilder
    func CardContent() -> some View {
        ScrollView(.vertical,showsIndicators: false){
            VStack(spacing: 0) {
                ForEach(cards.reversed()) { card in
                    let index = CGFloat(indexOf(card))
                    let reversedIndex = CGFloat(cards.count - 1) - index
                    let displayingStackIndex = min(index,2)
                    let displayScale = (displayingStackIndex/CGFloat(cards.count)) * 0.15
                    ZStack {
                        if selectedCard?.id == card.id && showDetailView {
                            
                        }
                        else {
                            CardView(card).rotation3DEffect(.init(degrees: expandCards ? (showDetailView ? 0 : -15) : 0), axis: (x : 1,y : 0,z : 0),anchor: .top).matchedGeometryEffect(id: card.id, in: animation).offset(y: showDetailView ? (size.height) : 0).onTapGesture {
                                if expandCards {
                                    selectedCard = card
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        showDetailView = true
                                    }
                                    DispatchQueue.main.asyncAfter(deadline:.now() + 0.15) {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            showDetailContent = true
                                        }
                                    }
                                }
                                else {
                                    withAnimation(.easeInOut(duration: 0.35)) {
                                        expandCards = true
                                    }
                                }
                              
                            }
                        }
                    }
                 .frame(height:200).scaleEffect(1-(expandCards ? 0:displayScale)).offset(y: expandCards ? 0: (displayingStackIndex * -15)).offset(y: (reversedIndex * -200)).padding(.top,expandCards ? (reversedIndex == 0 ? 0 : 80) : 0)
                    
                }
            }.padding(.top,45).padding(.bottom,CGFloat(cards.count - 1) * -200)
            
        }.scrollDisabled(!expandCards)
    }
    @ViewBuilder
    func CardView(_ card:Card) -> some View {
        GeometryReader {
            let size = $0.size
            VStack(spacing: 0) {
                Rectangle().fill(card.cardColor.gradient).overlay(alignment: .top) {
                    HStack {
                      
                        Text(card.cardName).font(.body.bold()).foregroundStyle(.white)
                        Spacer()
                    }.padding([.top,.horizontal],20)
               
                  
                   
                }
                
            }.clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        }
    }
    @ViewBuilder
    func Cardsview() -> some View {
        Rectangle().foregroundColor(.clear).frame(height: 245).anchorPreference(key: CardRectKey.self, value: .bounds) { anchor in
            return ["CardRect": anchor]
        }
    }
    @ViewBuilder
    func BottomScrollContent() -> some View {
        VStack {
            Spacer()

                          
            RoundedRectangle(cornerRadius: 20).foregroundStyle(.indigo.gradient).frame(width: 200, height: 80).overlay {
                Text("View Here").font(.system(size: 25)).foregroundStyle(.white)
            }.overlay {
                RoundedRectangle(cornerRadius: 27)
                               .strokeBorder(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round, dash: [80, 420], dashPhase: isMovingAround ? 220 : -220))
                                             
                                              .foregroundStyle(
                                                  //RadialGradient(gradient: Gradient(colors: [.white, .indigo, .indigo]), center: .bottom, startRadius: 60, endRadius: 100)
                                                .white
                                              )
            }
          
        }.padding(.top,160).onAppear {
            withAnimation(.linear.speed(0.1).repeatForever(autoreverses: false)) {
                isMovingAround.toggle()
            }}
    }
}

#Preview {
    HomeView()
}
