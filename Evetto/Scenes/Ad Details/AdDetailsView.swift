import SwiftUI
import NukeUI

struct AdDetailsView: View {
    
    @ObservedObject var viewModel: AdDetailsViewModel
    
    var body: some View {
        ScrollView {
            content
                .redacted(reason: viewModel.didLoadData ? [] : .placeholder)
        }
    }
    
    private var content: some View {
        Group {
            images
            
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(viewModel.title)
                        .font(.title2)
                    
                    if let location = viewModel.location {
                        Text(location)
                            .foregroundColor(Color.secondary)
                    }
                }
                
                Spacer()
                
                Text(viewModel.price)
                    .foregroundColor(Color.white)
                    .padding(6)
                    .background(Color.blue)
                    .clipShape(Capsule())
            }
            .padding()
        }
    }
    
    private var images: some View {
        TabView {
            if viewModel.didLoadData {
                ForEach(viewModel.imageURLs, id: \.self) { url in
                    LazyImage(
                        url: url,
                        content: { state in
                            if let error = state.error {
                                Color.red
                                    .overlay(
                                        Text(error.localizedDescription)
                                    )
                            } else if let image = state.image {
                                image
                            } else {
                                ProgressView()
                                    .progressViewStyle(.circular)
                            }
                        }
                    )
                }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color.secondary)
                    .font(Font.title.weight(.light))
                    .padding(20)
                    .unredacted()
            }
        }
        .tabViewStyle(.page)
        .frame(height: 200)
        .frame(maxWidth: .infinity)
    }
    
}

struct AdDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        AdDetailsView(
            viewModel: .placeholder
        )
    }
}
