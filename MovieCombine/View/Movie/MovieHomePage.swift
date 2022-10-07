import SwiftUI


struct MovieHomePage: View {
    @State private var showingAlert = false
    @State private var menuIndex = 0
    @ObservedObject var viewModel = MovieViewModel()
    
    let layout = [ GridItem(.adaptive(minimum: 105), spacing: 10) ]
    var elementCount = 0
    var currentRow = 0
    
    var body: some View {
        
        
        ZStack {
            
            VStack(alignment: .leading, spacing: 0) {
                NavigationView {
                    
                    ScrollView {
                        
                        Divider()
                        MovieSeachTextField(text: $viewModel.typedText)
                            .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 20))
                        
                        Divider()
//                        HStack {
//                            SegmentedControlView(value: $viewModel.selectedCategoryIndex)
//                            Spacer()
//                        }
//                        .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 20))
                        
                        LazyVGrid(columns: layout, spacing: 10) {
                            ForEach(viewModel.movieCellViewModels) { cellViewModel in
                                NavigationLink(destination: MovieDetails(movie: cellViewModel.movie)) {
                                    MovieCellView(viewModel: cellViewModel)
                                }.buttonStyle(PlainButtonStyle())
                            }
                            Rectangle()
                                .foregroundColor(.clear)
                                .onAppear {
                                    if !self.viewModel.movieCellViewModels.isEmpty, !self.viewModel.isSearching {
                                        self.viewModel.fetchNextPage()
                                    }
                                }
                        }
                        .padding(EdgeInsets(top:15, leading: 15, bottom: 20, trailing: 15))
                        
                        
                    }
                    .navigationBarTitle(Text("Movies"), displayMode: .large)
                    
                } //End of NavigationView
            }

            
            MenuList(viewModel: viewModel)
            
    
            
            
        }
        
        
        
    }
}


struct PopularMovies_Previews: PreviewProvider {
    static var previews: some View {
        MovieHomePage()
    }
}
