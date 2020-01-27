function(input, output, session){
  output$NO1 <- renderInfoBox({
    max_value <- max(state_stat[,input$selected])
    max_state <- 
      state_stat$state.name[state_stat[,input$selected]==max_value]
    infoBox(max_state, max_value, icon = icon("hand-o-up"))
  })
  #filter_map
  filteredData <-  reactive({
    map.df %>% 
      filter(
        room_type %in% input$room_select &
        price >= input$price[1] &
        price <= input$price[2] &
        number_of_reviews >= input$num_review[1] &
        number_of_reviews <= input$num_review[2] &
        score >= input$score[1] &
        score <= input$score[2]) 
  })
  #map_display
  output$map <- renderLeaflet({
    leaflet() %>% 
      addProviderTiles("Esri.WorldStreetMap") %>%
      addLegend(position = "bottomleft", pal = room_color, values = room_type, opacity = 1, title = "Room Type") %>%
      setView(lng = -73.935242, lat = 40.730610, zoom = 10)
  })
  #observe
  observe({
    proxy <- leafletProxy("map", data = filteredData()) %>% 
      clearMarkers() %>%
      addCircleMarkers(lng = ~longitude, lat = ~latitude, radius = 2, color = ~room_color(room_type),
                       popup = paste0(
                         "<b> minimum_nights </b>", map.df$minimum_nights,
                         "<br/><b> Price: </b>", map.df$price,
                         "<br/><b> Room Type: </b>", map.df$room_type,
                         "<br/><b> Property Type: </b>", map.df$property_type )) 
      
  })

  #wordcloud
  output$plot <- renderPlot({
      wordcloud(word_cloud$word, 
                word_cloud$n, 
                scale=c(4,.35), max.words=input$max, 
                random.order=FALSE, rot.per=0.35, 
                colors=brewer.pal(8, "Dark2"))
      })
  
  #neighbourhood
  output$boro <- renderPlot({
    listings.df %>%
      filter(boro==input$boro) %>% 
      group_by(boro, neighbourhood) %>% 
      summarise(total.list=n(),
                avg_price=(sum(price)/total.list)) %>% 
        ggplot(aes(x=reorder(neighbourhood, -avg_price), y=avg_price)) +
      geom_bar(stat="identity") +
      labs(x = "Neighbourhood", y = "Price per Night") +
      theme_bw() +
      theme(legend.key=element_blank(), legend.position="bottom") +
      coord_flip()
    })
  
  #subway
  output$subway <- renderPlot({
    subway.df %>%
      filter(boro==input$boro_select) %>% 
      filter(price<1000) %>%
      ggplot(aes(x=distances, y=price)) +
      geom_point(na.rm=TRUE, color = "#4363d8", alpha=0.8) +
      geom_smooth(color = "#e6194B") +
      ggtitle("Does the Distance to Subway Entrance Affect Price?") +
      labs(x = "Distance", y = "Price of Unique Listings") +
      theme(plot.title = element_text(face = "bold")) +
      theme(plot.subtitle = element_text(face = "bold", color = "grey35")) +
      theme(plot.caption = element_text(color = "grey68"))
  })
  
  #season and reveiws
  output$season <- renderPlot({
    season.df %>%
    filter(format(as.Date(date),"%Y")==input$year) %>%
    group_by(date) %>% 
    summarise(num = n()) %>% 
    ggplot(aes(date, num)) +
    geom_point(na.rm=TRUE, color = "#4363d8", alpha=0.8) +
    geom_smooth(color = "#e6194B") +
    ggtitle("Number of Reviews across years") +
    labs(x = "Year", y = "Reviews of Unique listings ") +
    theme(plot.title = element_text(face = "bold")) 
    })
  #season and price
  output$price <- renderPlot({
    cal.df %>% 
      filter(format(as.Date(date),"%Y")==input$year) %>%
      ggplot(aes(x=date, y=avg_price)) +
      geom_point(na.rm=TRUE, color = "#4363d8", alpha=0.8) + 
      geom_smooth(color = "#e6194B") + 
      ggtitle("Average listing price across Months") +
      labs(x = "Month", y = "Average price across Listings") +
      theme(plot.title = element_text(face = "bold")) 
  })
  
  #data
  output$table <- DT::renderDataTable({
    datatable(listings.df, rownames=FALSE, width = 300, options = list(scrollX = TRUE))
  })
    

}