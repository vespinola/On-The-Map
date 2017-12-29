//
//  ParseConstants.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 2/11/15.
//  Copyright (c) 2015 Jarrod Parkes. All rights reserved.
//

// MARK: - ParseClient (Constants)

extension ParseHandler {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: API Key
        static let ApiKey = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        
        // MARK: Rest API Key
        static let RestApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes"
//        static let AuthorizationURL = "https://www.themoviedb.org/authenticate/"
//        static let AccountURL = "https://www.themoviedb.org/account/"
    }
    
    // MARK: Methods
    struct Methods {
        
        // MARK: Student Locations
        static let StudenLocation = "/StudentLocation"
        
    }

    // MARK: URL Keys
    struct URLKeys {
        static let UserID = "id"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        static let ApiKey = "api_key"
        static let SessionID = "session_id"
        static let RequestToken = "request_token"
        static let Query = "query"
        
        static let limit = "limit"
        static let search = "where"
        
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        static let MediaType = "media_type"
        static let MediaID = "media_id"
        static let Favorite = "favorite"
        static let Watchlist = "watchlist"
    }

    // MARK: JSON Response Keys
    struct JSONResponseKeys {
      
        // MARK: General
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
        
        // MARK: Authorization
        static let RequestToken = "request_token"
        static let SessionID = "session_id"
        
        // MARK: Account
        static let UserID = "id"
        
        // MARK: Config
        static let ConfigBaseImageURL = "base_url"
        static let ConfigSecureBaseImageURL = "secure_base_url"
        static let ConfigImages = "images"
        static let ConfigPosterSizes = "poster_sizes"
        static let ConfigProfileSizes = "profile_sizes"
        
        // MARK: Movies
        static let MovieID = "id"
        static let MovieTitle = "title"        
        static let MoviePosterPath = "poster_path"
        static let MovieReleaseDate = "release_date"
        static let MovieReleaseYear = "release_year"
        static let MovieResults = "results"
        
    }
    
    // MARK: Poster Sizes
    struct PosterSizes {
        static let RowPoster = ParseClient.sharedInstance().config.posterSizes[2]
        static let DetailPoster = ParseClient.sharedInstance().config.posterSizes[4]
    }
}
