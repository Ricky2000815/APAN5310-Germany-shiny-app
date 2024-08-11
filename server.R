server = function(input, output, session) {
  
  # >>>>>>>>>>>>>>>>>>>>>----
  # reactives----
  wc = reactiveValues(
    gm = 0, # selected game (1 to 3)
    co = 0, # selected city option (1 to 3)
    gt = 0, # show/hide German team (0 or 1)
    tm = 0, # selected teammate (1 to 8)
    pl = 0, # selected player (1 to 24)
    cm = 0,  # community section indicator (0 or 1)
    hts = 0, # activate hotels(0 or 1)
    ht = 0, # selected hotel (1 to 20)
    near = 0, # activate nearest restaurant (0 or 1)
    nr = 0, # selected nearest restaurant (1 or 2)
    se = 0,  # activate special events (0 or 1)
    sen = 0, # selected special event number (1 or 2)
  )
  
  # >>>>>>>>>>>>>>>>>>>>>----
  # events home buttons----
  observeEvent(input$homeBtn, {wc$gm=0;wc$co=0;wc$gt=0;wc$tm=0;wc$pl=0;wc$cm=0;
  wc$hts=0;wc$ht=0;wc$near=0;wc$nr=0;wc$se=0;wc$sen=0})
  observeEvent(input$gnt, {wc$gm=0;wc$co=0;wc$gt=1;wc$tm=0;wc$pl=0;wc$cm=0;
  wc$hts=0;wc$ht=0;wc$near=0;wc$nr=0;wc$se=0;wc$sen=0})
  observeEvent(input$city1, {wc$gm=1;wc$co=0;wc$gt=0;wc$tm=0;wc$pl=0;wc$cm=0;
  wc$hts=0;wc$ht=0;wc$near=0;wc$nr=0;wc$se=0;wc$sen=0})
  observeEvent(input$city2, {wc$gm=2;wc$co=0;wc$gt=0;wc$tm=0;wc$pl=0;wc$cm=0;
  wc$hts=0;wc$ht=0;wc$near=0;wc$nr=0;wc$se=0;wc$sen=0})
  observeEvent(input$city3, {wc$gm=3;wc$co=0;wc$gt=0;wc$tm=0;wc$pl=0;wc$cm=0;
  wc$hts=0;wc$ht=0;wc$near=0;wc$nr=0;wc$se=0;wc$sen=0})
  observeEvent(input$aboutBtn, {wc$gm=0;wc$co=0;wc$gt=0;wc$tm=-1;wc$pl=0;wc$cm=0;
  wc$hts=0;wc$ht=0;wc$near=0;wc$nr=0;wc$se=0;wc$sen=0})
  observeEvent(input$communityBtn, {wc$gm=0;wc$co=0;wc$gt=0;wc$tm=0;wc$pl=0;wc$cm=1;
  wc$hts=0;wc$ht=0;wc$near=0;wc$nr=0;wc$se=0;wc$sen=0})
  
  # ui main----
  output$uiMain = renderUI(
    {
      uiOutput(
        case_when(
          wc$gt == 1 ~ 'uiPlyrs',
          (wc$gm %in% 1:3) & (wc$se == 0) & (wc$hts != 1) ~ 'uiGame',
          wc$tm != 0 ~ 'uiAbout',
          (wc$hts == 1) & (wc$near != 1) ~ 'uiHotels',
          wc$near == 1 ~ 'uiNear',
          wc$cm == 1 ~ 'uiCommunity',
          wc$se == 1 ~ 'uiSpecialEvent'
        )
      )
    }
  )
  
  # email
  output$email = renderUI(
    if (wc$gm == 0 & wc$gt == 0 & wc$cm == 0 & wc$tm != -1 & wc$hts != 1)
    {
      div(
        style = 'position:absolute; top:68%; left:60%;',
        align = 'center',
        tags$div(
          style = 'color:gold; font-weight:bold; margin-bottom:20px;font-size:23px;text-shadow: 2px 2px 4px #000000;',
          HTML("JOIN NOW !<br/>Team Deutscher's Fan Club:")
        ),
        textInput("email", label = NULL, value = "", placeholder = 'Email For Subscription'),
        actionButton("subscribe", "Subscribe")
      )
    }
  )
  
  # _ui game----
  output$uiGame = renderUI(
    {
      div(
        style = 'padding:50px 10px 0 10px;',
        div(
          style = 'background-color:rgba(255,255,255,0.8); padding:10px;',
          fluidRow(
            column(
              width = 8,
              div(
                style = paste0(
                  'border:solid ', 
                  c('black', 'red', 'gold')[wc$gm], ' 5px;'
                ),
                leafletOutput(
                  outputId = 'cityMap',
                  height = '75vh'
                )
              )
            ),
            column(
              width = 4,
              uiOutput('uiMapInfo')
            )
          )
        )
      )
    }
  )
  
  # _ui players----
  output$uiPlyrs = renderUI(
    {
      z = dbGetQuery(con, 'SELECT * FROM players;')
      div(
        style = 'padding:50px 10px 0 10px;',
        div(
          style = paste0(
            'background-color:rgba(255,255,255,0.8); padding:10px;'
          ),
          fluidRow(
            column(
              width = 8,
              style = 'height:80vh; overflow-y:scroll; overflow-x:hidden;',
              lapply(
                1:6,
                function(i) {
                  fluidRow(
                    style = 'padding:10px 0 10px 0;',
                    lapply(
                      1:4,
                      function(j) {
                        column(
                          width = 3,
                          tags$button(
                            id = paste0('plyr', (i-1)*4+j),
                            class = 'btn action-button',
                            style = 'background-color:rgba(0,0,0,0); padding:0; margin:0; border-radius:10px;',
                            img(
                              src = paste0('plyrs/', (i-1)*4+j, '.jpeg'),
                              width = '100%',
                              style = 'border-radius:10px;'
                            )
                          )
                        )
                      }
                    )
                  )
                }
              )
            ),
            column(
              width = 4,
              uiOutput('uiPlyrInfo')
            )
          )
        )
      )
    }
  )
  
  # _events plyr buttons----
  observeEvent(input$plyr1, {wc$pl = 1})
  observeEvent(input$plyr2, {wc$pl = 2})
  observeEvent(input$plyr3, {wc$pl = 3})
  observeEvent(input$plyr4, {wc$pl = 4})
  observeEvent(input$plyr5, {wc$pl = 5})
  observeEvent(input$plyr6, {wc$pl = 6})
  observeEvent(input$plyr7, {wc$pl = 7})
  observeEvent(input$plyr8, {wc$pl = 8})
  observeEvent(input$plyr9, {wc$pl = 9})
  observeEvent(input$plyr10, {wc$pl = 10})
  observeEvent(input$plyr11, {wc$pl = 11})
  observeEvent(input$plyr12, {wc$pl = 12})
  observeEvent(input$plyr13, {wc$pl = 13})
  observeEvent(input$plyr14, {wc$pl = 14})
  observeEvent(input$plyr15, {wc$pl = 15})
  observeEvent(input$plyr16, {wc$pl = 16})
  observeEvent(input$plyr17, {wc$pl = 17})
  observeEvent(input$plyr18, {wc$pl = 18})
  observeEvent(input$plyr19, {wc$pl = 19})
  observeEvent(input$plyr20, {wc$pl = 20})
  observeEvent(input$plyr21, {wc$pl = 21})
  observeEvent(input$plyr22, {wc$pl = 22})
  observeEvent(input$plyr23, {wc$pl = 23})
  observeEvent(input$plyr24, {wc$pl = 24})
  
  # _ui plyr info----
  output$uiPlyrInfo = renderUI(
    if (wc$pl > 0) {
      z = dbGetQuery(
        con,
        paste0(
          'SELECT * FROM players ',
          'WHERE player_id = ', wc$pl, ';'
        )
      )
      div(
        style = 'padding:20px; background-color:rgba(255,255,255,0.9); border-radius:10px; border:solid #ddd 1px; text-align:center;',
        h3(z$name, style = 'font-size:24px; font-weight:bold; color:#333;'),
        h4(z$position, style = 'font-size:20px; color:#666; margin-top:5px;'),
        h5(paste0('Height: ', z$height, ' cm'), style = 'font-size:16px; color:#333; margin-top:5px;'),
        h5(paste0('Age: ', z$age, ' yrs'), style = 'font-size:16px; color:#333; margin-top:5px;'),
        div(
          style = 'display:flex; justify-content:center; margin:20px 0;',
          div(
            style = 'margin:0 20px; text-align:center;',
            h1(z$international_matches, style = 'font-size:36px; font-weight:bold; color:#333;'),
            h6('International Matches', style = 'font-size:14px; color:#999; margin-top:5px;')
          ),
          div(
            style = 'margin:0 20px; text-align:center;',
            h1(paste0('€', z$market_value, 'M'), style = 'font-size:36px; font-weight:bold; color:#333;'),
            h6('Market Value', style = 'font-size:14px; color:#999; margin-top:5px;')
          )
        ),
        div(
          style = 'text-align:center; margin:20px 0;',
          tags$iframe(
            src = z$highlight_link,  
            width = '100%',
            height = '315',
            frameborder = '0',
            allow = 'accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture',
            allowfullscreen = TRUE,
            style = 'border-radius:10px; border:solid white 1px;'
          )
        ),
        tags$a(
          href = z$instagram_link,
          target = '_blank',
          img(
            src = 'insta_logo.png',
            width = '50px'
          )
        ),
        tags$a(
          href = z$cloth_link,
          target = '_blank',
          img(
            src = 'shop.jpg', 
            width = '50px',
            style = 'border-radius:50%; border: 3px solid black;'
          )
        )
      )
    }
  )
  
  # _city maps----
  output$cityMap = renderLeaflet(
    if (wc$gm != 0) {
      z = dbGetQuery(
        conn = con, 
        statement = paste0(
          'SELECT * FROM location ',
          'WHERE locn_id = ', wc$gm, ';'
        )
      )
      leaflet(
        data = z
      ) |> 
        addProviderTiles(
          providers$CartoDB.Voyager
        ) |> 
        addAwesomeMarkers(
          lat = ~lat,
          lng = ~lng,
          popup = c('NRG Stadium', 'Estadio Akron Stadium', 'Hard Rock Stadium')[wc$gm],
          icon = awesomeIcons(
            markerColor = 'blue',
            icon = 'star'
          )
        ) |> 
        setView(
          lat = z$lat,
          lng = z$lng,
          zoom = 10
        )
    }
  )
  
  # _map info----
  output$uiMapInfo = renderUI(
    {
      div(
        h2(paste0('Game ', wc$gm)),
        h3(
          c(
            'Germany VS Colombia',
            'Germany VS Cameroon',
            'Costa Rica VS Germany'
          )[wc$gm],
        ),
        div(
          style = 'display: flex; justify-content: center; align-items: center;',
          tags$img(
            src = c(
              'flags/de.png',
              'flags/de.png',
              'flags/cr.png'
            )[wc$gm],
            height = '100px', # Adjust the height as needed
            style = 'margin-right: 10px;'
          ),
          h3("VS", style = "margin: 0 10px;"),
          tags$img(
            src = c(
              'flags/ec.png',
              'flags/cm.png',
              'flags/de.png'
            )[wc$gm],
            height = '100px', # Adjust the height as needed
            style = 'margin-left: 10px;'
          )
        ),
        h3(c('NRG Stadium', 'Estadio Akron Stadium', 'Hard Rock Stadium')[wc$gm]),
        div(
          class = 'date-container',
          h4(c('2026-06-14', '2026-06-23', '2026-06-27')[wc$gm])
        ),
        div(
          class = 'time-container',
          h4(c('3:30pm CDT', '5:00pm CST', '7:00pm EST')[wc$gm])
        ),
        actionBttn(
          inputId = 'buyTix',
          label = 'Buy Tickets',
          style = 'gradient',
          color = 'warning',
          size = 'md',
          block = FALSE,
          icon = icon('ticket'),
          class = 'pulse-animation'
        ),
        h1(),
        actionBttn(
          inputId = 'hotels',
          label = 'Find Hotels',
          style = 'gradient',
          color = 'success',
          size = 'md',
          block = FALSE,
          icon = icon('bed')
        ),
        h1(),
        actionBttn(
          inputId = 'restaurantReservation',
          label = 'Reserve Restaurants',
          style = 'gradient',
          color = 'danger',
          size = 'md',
          block = FALSE,
          icon = icon('cutlery')
        ),        
        h1(),
        actionBttn(
          inputId = 'eventButton',
          label = 'Special Event',
          style = 'gradient',
          color = 'primary',
          size = 'md',
          block = FALSE,
          icon = icon('star')
        )
      )
    }
  )
  
  # _event buy tix----
  observeEvent(
    input$buyTix, 
    {
      showModal(
        modalDialog(
          h3(paste0('Buy Game Tickets for Game ', wc$gm)),
          radioGroupButtons(
            inputId = 'qtyTix',
            label = 'Qty',
            choices = 1:4,
            selected = 1
          ),
          pickerInput(
            inputId = 'typeTix',
            label = 'Category',
            choices = c('Field Level' = 1, 'Upper Level' = 2, 'Luxury Box' = 3),
            selected = 1
          ),
          footer = tagList(
            actionButton('submitTix', 'Submit'),
            modalButton('Cancel')
          )
        )
      )
    }
  )
  
  # _event submit tix----
  observeEvent(
    input$submitTix,
    {
      removeModal()
      sendSweetAlert(
        title = 'Thank you!',
        text = 'We will see you at the game.',
        type = 'success'
      )
    }
  )
  
  # Email subscription logic
  observeEvent(
    input$subscribe, 
    {
      email <- input$email
      sendSweetAlert(
        session = session,
        title = "Successful Joined!",
        text = paste("We will send you latest news about Team Deutscher with the email:", email),
        type = "success"
      )
    })
  
  
  # _event showRestaurants----
  observeEvent(input$showRestaurants, {
    wc$gt = 0
    wc$gm = 0
    wc$tm = 0
    wc$hts = 1
    
    output$uiRestaurants <- renderUI({
      # Fetch restaurant data
      restaurant_data <- dbGetQuery(con, 'SELECT * FROM restaurant;')
      
      pickerInput(
        inputId = 'restaurantName',
        label = 'Restaurant name',
        choices = restaurant_data$rest_name
      )
    })
  })
  
  # _event restaurant reservation----
  observeEvent(input$restaurantReservation, {
    restaurant_data <- dbGetQuery(con, paste0(
      "SELECT rest_id, rest_name, cuisines FROM restaurant WHERE locn_id IN (SELECT locn_id FROM location WHERE city_code = ",
      wc$gm,
      " ORDER BY rest_id)"
    ))
    
    cuisine_choices = dbGetQuery(
      con,
      paste0(
        'SELECT DISTINCT cuisines FROM restaurant ',
        'WHERE rest_id BETWEEN ', wc$gm * 10000, ' AND ', (wc$gm + 1) * 10000, ';'
      )
    )
    cuisine_choices = c('All', cuisine_choices)
    restaurant_choices <- restaurant_data$rest_name
    restaurant_photos <- paste0(c('rests/10001','rests/10002','rests/10003','rests/10004','rests/10005',
                                  'rests/10006','rests/10007','rests/10008','rests/10009','rests/10010',
                                  'rests/10011','rests/10012','rests/10013','rests/10014','rests/10015',
                                  'rests/10016','rests/10017','rests/10018','rests/10019','rests/10020',
                                  'rests/20001','rests/20002','rests/20003','rests/20004','rests/20005',
                                  'rests/20006','rests/20007','rests/20008','rests/20009','rests/20010',
                                  'rests/20011','rests/20012','rests/20013','rests/20014','rests/20015',
                                  'rests/20016','rests/20017','rests/20018','rests/20019','rests/20020',
                                  'rests/30001','rests/30002','rests/30003','rests/30004','rests/30005',
                                  'rests/30006','rests/30007','rests/30008','rests/30009','rests/30010',
                                  'rests/30011','rests/30012','rests/30013','rests/30014','rests/30015',
                                  'rests/30016','rests/30017','rests/30018','rests/30019','rests/30020'), ".jpeg")
    
    showModal(
      modalDialog(
        h3(paste0('Reserve the restaurant near Game ', wc$gm)),
        textInput(
          inputId = 'userName',
          label = 'Name',
          placeholder = 'Your Name'
        ),
        textInput(
          inputId = 'userEmail',
          label = 'E-mail',
          placeholder = 'Your Email'
        ),
        pickerInput(
          inputId = 'RestCuisine',
          label = 'Restaurant Cuisine',
          choices = cuisine_choices
        ),
        pickerInput(
          inputId = 'restaurantName',
          label = 'Restaurant name',
          choices = restaurant_choices
        ),
        uiOutput("restaurantPhoto"),
        radioGroupButtons(
          inputId = 'numCustomer',
          label = 'Party size',
          choices = 1:10,
          selected = 1
        ),
        radioGroupButtons(
          inputId = 'timeSlot',
          label = 'Time',
          choices = c(
            '9.30 AM' = '9.30 AM',
            '10.30 AM' = '10.30 AM',
            '11.30 AM' = '11.30 AM',
            '12.30 PM' = '12.30 PM',
            '1.30 PM' = '1.30 PM',
            '2.30 PM' = '2.30 PM',
            '3.30 PM' = '3.30 PM',
            '4.30 PM' = '4.30 PM',
            '5.30 PM' = '5.30 PM'
          ),
          selected = '9.30 AM'
        ),
        footer = tagList(
          actionButton('submitReservation', 'Submit'),
          modalButton('Cancel')
        )
      )
    )
    
    observeEvent(input$RestCuisine, {
      updatePickerInput(
        session,
        inputId = 'restaurantName',
        choices = if (input$RestCuisine == 'All') {
          restaurant_choices
        } else {
          restaurant_data$rest_name[restaurant_data$cuisines == input$RestCuisine]
        }
      )
    })
    
    output$restaurantPhoto <- renderUI({
      req(input$restaurantName)
      img(src = restaurant_photos[which(restaurant_choices == input$restaurantName)+(wc$gm-1)*20], width = '100%')
    })
  })
  
  
  
  # _event submit reservation----
  observeEvent(
    input$submitReservation,
    {
      removeModal()
      sendSweetAlert(
        title = paste0('Thank you ', input$userName, ' 😊'),
        text = paste0('Your table has been reserved.\nWe have already sent the confirmation email to ', input$userEmail),
        type = 'success'
      )
    }
  )
  
  
  # _event submit reservation----
  observeEvent(
    input$submitReservation,
    {
      removeModal()
      sendSweetAlert(
        title = paste0('Thank you ', input$userName, ' 😊'),
        text = paste0('Your table has been reserved.\nWe have already sent the confirmation email to ', input$userEmail),
        type = 'success'
      )
    }
  )
  
  # >>>>>>>>>>>>>>>>>>>>>----
  # _event hotels----
  observeEvent(input$hotels, {wc$hts = 1; wc$ht = 0})
  
  # _ui hotels----
  output$uiHotels = renderUI(
    { 
      k = dbGetQuery(con, 'SELECT * FROM hotel;')
      div(
        style = 'padding:50px 10px 0 10px;',
        div(
          style = paste0(
            'background-color:rgba(255,255,255,0.8); padding:10px;'
          ),
          fluidRow(
            column(
              width = 8,
              style = 'height:80vh; overflow-y:scroll; overflow-x:hidden;',
              lapply(
                1:5,
                function(i) {
                  fluidRow(
                    style = 'padding:10px 0 10px 0;',
                    lapply(
                      1:2,
                      function(j) {
                        column(
                          width = 6,
                          tags$button(
                            id = paste0('ht', (i-1)*2+j),
                            class = 'btn action-button',
                            style = 'background-color:rgba(0,0,0,0); padding:0; margin:0; border-radius:10px;',
                            img(
                              src = paste0('hotels/', (i-1)*2+j+1000*wc$gm, '.jpg'),
                              width = '100%',
                              style = 'border-radius:10px;'
                            )
                          ),
                          div(
                            style = 'text-align:center; margin-top:5px; font-size:15px',
                            strong(k$hotel_name[k$hotel_id == (i-1)*2+j+1000*wc$gm])  # Label beneath the image
                          )
                        )
                      }
                    )
                  )
                }
              )
            ),
            column(
              width = 4,
              uiOutput('uiHotelInfo')
            )
          )
        )
      )
    }
  )
  
  observeEvent(input$ht1, {wc$ht = 1})
  observeEvent(input$ht2, {wc$ht = 2})
  observeEvent(input$ht3, {wc$ht = 3})
  observeEvent(input$ht4, {wc$ht = 4})
  observeEvent(input$ht5, {wc$ht = 5})
  observeEvent(input$ht6, {wc$ht = 6})
  observeEvent(input$ht7, {wc$ht = 7})
  observeEvent(input$ht8, {wc$ht = 8})
  observeEvent(input$ht9, {wc$ht = 9})
  observeEvent(input$ht10, {wc$ht = 10})
  
  # _ui hotel info----
  output$uiHotelInfo = renderUI(
    if (wc$ht > 0) {
      k = dbGetQuery(
        con,
        paste0(
          'SELECT * FROM hotel ',
          'WHERE hotel_id = ', wc$ht + 1000 * wc$gm, ';'
        )
      )
      div(
        style = 'display:flex; flex-direction:column; justify-content:center; align-items:center;',  # 添加样式
        h2(k$hotel_name),
        h3('Google Map Rating: ', k$google_map_rating),
        h3('Star Rating: ', case_when(k$star_rating == 3 ~ '⭐⭐⭐',
                                      k$star_rating == 4 ~ '⭐⭐⭐⭐',
                                      k$star_rating == 5 ~ '⭐⭐⭐⭐⭐')),  
        h3('Call to Book: ', k$phone),
        h3(),
        actionBttn(
          inputId = 'BookHt',
          label = 'Book Hotel',
          style = 'gradient',
          color = 'success',
          size = 'md',
          block = FALSE,
          icon = icon('bed')),
        h3(),
        actionBttn(
          inputId = 'NearRest',
          label = 'Find Nearest Restaurants',
          style = 'gradient',
          color = 'danger',
          size = 'md',
          block = FALSE,
          icon = icon('cutlery')),
        h3(),
        actionBttn(
          inputId = 'BackToCity',
          label = 'Back',
          style = 'gradient',
          color = 'success',
          size = 'md',
          block = FALSE,
          icon = icon('arrow-left')),
        h1(),
        h3('All hotels provide free shuttle bus to the stadium before game starts. \nPlease register when check-in for the hotels.')
      )
    }
  )
  
  observeEvent(input$NearRest, {wc$near = 1})
  observeEvent(input$BackToCity, {wc$hts = 0; wc$near = 0; wc$se = 0})
  
  # _event book hotel----
  observeEvent(
    input$BookHt, 
    { 
      k = dbGetQuery(
        con,
        paste0(
          'SELECT * FROM hotel ',
          'WHERE hotel_id = ', wc$ht + 1000 * wc$gm, ';'
        )
      )
      showModal(
        modalDialog(
          h3(paste0('Book Rooms for ', k$hotel_name)),
          textInput(
            inputId = 'BookHotelName',
            label = 'Name',
            placeholder = 'Your Name'
          ),
          textInput(
            inputId = 'BookHotelEmail',
            label = 'Email',
            placeholder = 'Your Email'
          ),
          radioGroupButtons(
            inputId = 'qtyRoom',
            label = 'Number of Rooms',
            choices = 1:5,
            selected = 1
          ),
          pickerInput(
            inputId = 'typeRoom',
            label = 'Room Type',
            choices = c('Single Room' = 1, 'Standard Double Room' = 2, 'Standard Twin Room' = 3, 
                        'Deluxe Double Room' = 4, 'Queen' = 5, 'Junior Suite' = 6, 
                        'Executive Suite' = 7, 'Presidential Suite' = 8),
            selected = 1
          ),
          textInput(
            inputId = 'BookHotelStart',
            label = 'Start Date',
            placeholder = 'Format: DD/MM/YYYY'
          ),
          textInput(
            inputId = 'BookHotelEnd',
            label = 'End Date',
            placeholder = 'Format: DD/MM/YYYY'
          ),
          footer = tagList(
            actionButton('submitBook', 'Submit'),
            modalButton('Cancel')
          )
        )
      )
    }
  )
  
  # _event submit Book----
  observeEvent(
    input$submitBook,
    { 
      k = dbGetQuery(
        con,
        paste0(
          'SELECT * FROM hotel ',
          'WHERE hotel_id = ', wc$ht + 1000 * wc$gm, ';'
        )
      )
      removeModal()
      sendSweetAlert(
        title = paste0('Dear Mr./Ms. ', input$BookHotelName, ','),
        text = paste0('Booking confirmed. See you at ', k$hotel_name, '!'),
        btn_labels = 'OK',
        type = 'success'
      )
    }
  )
  
  # >>>>>>>>>>>>>>>>>>>>>----
  # ui nearest restaurants----
  output$uiNear = renderUI(
    {
      k = dbGetQuery(
        con, 
        paste0(
          'SELECT * FROM restaurant ',
          'WHERE hotel_id = ', wc$ht + 1000 * wc$gm, ';'
        )
      )
      div(
        style = 'padding:50px 10px 0 10px;',
        div(
          style = paste0(
            'background-color:rgba(255,255,255,0.8); padding:10px;'
          ),
          fluidRow(
            column(
              width = 8,
              style = 'height:80vh; overflow-y:scroll; overflow-x:hidden;',
              #lapply(
              #1:1,
              #function(i) {
              fluidRow(
                style = 'padding:10px 0 10px 0;',
                lapply(
                  1:2,
                  function(j) {
                    img_index <- (wc$ht - 1) * 2 + j
                    img_filename <- sprintf("%05d.jpeg", img_index + 10000)
                    column(
                      width = 6,
                      tags$button(
                        id = paste0('nr', j),
                        class = 'btn action-button',
                        style = 'background-color:rgba(0,0,0,0); padding:0; margin:0; border-radius:10px;',
                        img(
                          src = paste0('rests/', (wc$ht - 1) * 2 + j + 10000 * wc$gm, '.jpeg'),
                          width = '100%',
                          style = 'border-radius:10px;'
                        )
                      ),
                      div(
                        style = 'text-align:center; margin-top:5px; font-size:15px',
                        strong(k$rest_name[k$rest_id == j+10000*wc$gm+(wc$ht-1)*2])  # Label beneath the image
                      )
                    )
                  }
                )
              )
              #}
              #)
            ),
            column(
              width = 4,
              uiOutput('uiNearRestInfo')
            )
          )
        )
      )
    }
  )
  
  observeEvent(input$nr1, {wc$nr = 1})
  observeEvent(input$nr2, {wc$nr = 2})
  
  # _ui nearest rest info----
  output$uiNearRestInfo = renderUI(
    if (wc$nr > 0) {
      k = dbGetQuery(
        con, 
        paste0(
          'SELECT * FROM restaurant ',
          'WHERE rest_id = ', (wc$ht-1) * 2 + 10000 * wc$gm + wc$nr, ';'
        )
      )
      div(
        h2(k$rest_name),
        h3('Restaurant Type: ', k$cuisines),
        h3('Google Map Rating: ', k$google_map_rating),
        h3('Price Range: ', k$price_range),
        h3(),
        actionBttn(
          inputId = 'RestRes',
          label = 'Restaurant Reservation',
          style = 'gradient',
          color = 'danger',
          size = 'md',
          block = FALSE,
          icon = icon('cutlery')),
        h3(),
        actionBttn(
          inputId = 'BackToHotel',
          label = 'Back',
          style = 'gradient',
          color = 'success',
          size = 'md',
          block = FALSE,
          icon = icon('arrow-left'))
      )
    }
  )
  
  observeEvent(input$BackToHotel, {wc$hts = 1; wc$near = 0; wc$nr = 0})
  
  # _event book restaurant----
  observeEvent(
    input$RestRes, 
    { 
      k = dbGetQuery(
        con,
        paste0(
          'SELECT * FROM restaurant ',
          'WHERE rest_id = ', (wc$ht - 1) * 2 + wc$nr + 10000 * wc$gm, ';'
        )
      )
      showModal(
        modalDialog(
          h3(paste0('Reserve in ', k$rest_name)),
          textInput(
            inputId = 'RestResName',
            label = 'Name',
            placeholder = 'Your Name'
          ),
          textInput(
            inputId = 'RestResEmail',
            label = 'Email',
            placeholder = 'Your Email'
          ),
          radioGroupButtons(
            inputId = 'qtyCust',
            label = 'Party Size',
            choices = 1:10,
            selected = 1
          ),
          radioGroupButtons(
            inputId = 'RestResTime',
            label = 'Time',
            choices = c(
              '9:30 AM' = '9:30 AM',
              '10:00 AM' = '10:00 AM',
              '10:30 AM' = '10:30 AM',
              '11:00 AM' = '11:00 AM',
              '11:30 AM' = '11:30 AM',
              '12:00 PM' = '12:00 PM',
              '12:30 PM' = '12:30 PM',
              '1:00 PM' = '1:00 PM',
              '1:30 PM' = '1:30 PM',
              '2:00 PM' = '2:00 PM',
              '2:30 PM' = '2:30 PM',
              '4:30 PM' = '4:30 PM',
              '5:00 PM' = '5:00 PM',
              '5:30 PM' = '5:30 PM',
              '6:00 PM' = '6:00 PM',
              '6:30 PM' = '6:30 PM',
              '7:00 PM' = '7:00 PM',
              '7:30 PM' = '7:30 PM',
              '8:00 PM' = '8:00 PM',
              '8:30 PM' = '8:30 PM',
              '9:00 PM' = '9:00 PM',
              '9:30 PM' = '9:30 PM'
            ),
            selected = '9:30 AM'
          ),
          footer = tagList(
            actionButton('submitRestRes', 'Submit'),
            modalButton('Cancel')
          )
        )
      )
    }
  )
  
  # _event submit RestRes----
  observeEvent(
    input$submitRestRes,
    { 
      k = dbGetQuery(
        con,
        paste0(
          'SELECT * FROM restaurant ',
          'WHERE rest_id = ', (wc$ht - 1) * 2 + wc$nr + 10000 * wc$gm, ';'
        )
      )
      removeModal()
      sendSweetAlert(
        title = paste0('Dear Mr./Ms. ', input$RestResName, ','),
        text = paste0('Reservation confirmed. See you at ', k$rest_name, '!'),
        btn_labels = 'OK',
        type = 'success'
      )
    }
  )
  
  # _ui about----
  output$uiAbout = renderUI(
    {
      div(
        style = 'padding:10px 5% 0 5%;',
        div(
          align = 'center',
          h4(
            style = 'color:white;font-size:30px; font-weight:bold; margin-top:80px; text-shadow: 2px 2px 4px gold; position:center;padding-left:90px;margin-bottom:-20px',
            'Behind The Scenes'
          ),
          # _teammate images----
          div(
            style = 'padding:4% 5% 10% 12%;',
            lapply(
              0:1,
              function(i) {
                fluidRow(
                  lapply(
                    1:4,
                    function(j) {
                      k = 4*i+j
                      column(
                        width = 3,
                        align = 'center',
                        tags$button(
                          id = paste0('mate', k),
                          class = 'btn action-button',
                          style = 'background-color:rgba(0,0,0,0); padding:0; margin:0 0 10px 0;;',
                          img(
                            src = paste0('teammate', k, '.jpg'),
                            width = '100%',
                            style = 'border-radius:10px; margin-left:-10px;'
                          )
                        ),
                        h6(
                          style = 'color:white; font-size:20px; margin:0px 0 10px 0; font-weight:bold; font-size:larger; text-shadow: 4px 4px 6px black;', 
                          teammate$first[k]
                        ),
                        h6(
                          style = 'color:gold; font-size:20px;margin:5px; font-weight:bold; font-size:larger;margin-bottom: 40px;text-shadow: 4px 4px 6px black;',
                          teammate$last[k]
                        )
                      )
                    }
                  )
                )
              }
            ),
            uiOutput('uiMate')
          )
        )
      )
    }
  )
  
  # _ui mate----
  output$uiMate = renderUI(
    if (wc$tm > 0) {
      div(
        style = paste0(
          'padding:-1px 5px 5px 5px; ',
          'margin-top:5px; ',
          'background-color:rgba(255,255,255,0.8); ',
          'border-radius:10px;'
        ),
        h4(
          style = 'color:black; font-size: 25px; margin: 10px;padding:20px 5% 0 5%;',
          paste0(teammate$first[wc$tm],' ',teammate$last[wc$tm], '\'s Bio')
        ),
        p(
          style = 'color:black; text-align:center; font-size: 20px; margin: 10px;padding:20px 5% 20px 5%;',
          HTML(teammate$info[wc$tm])
        )
      )
    }
  )
  
  # _events mate----
  observeEvent(input$mate1, {wc$tm = 1})
  observeEvent(input$mate2, {wc$tm = 2})
  observeEvent(input$mate3, {wc$tm = 3})
  observeEvent(input$mate4, {wc$tm = 4})
  observeEvent(input$mate5, {wc$tm = 5})
  observeEvent(input$mate6, {wc$tm = 6})
  observeEvent(input$mate7, {wc$tm = 7})
  observeEvent(input$mate8, {wc$tm = 8})
  
  # _ui community----
  output$uiCommunity = renderUI(
    {
      div(
        style = 'padding:20px 5% 0 5%; text-align:center;',
        div(
          align = 'center',
          h4(
            style = 'color:white; font-size:30px; font-weight:bold; margin-top:80px; text-shadow: 2px 2px 4px gold; margin-bottom:30px',
            'Connect with Fans'
          ),
          div(
            style = 'margin-bottom: 30px; padding: 20px; background-color: rgba(255, 255, 255, 0.8); border-radius: 10px; font-size: 20px;',
            h4("Tour the City with Me", style = 'color:black;font-size:25px;'),
            p("Visiting a new city for the first time to watch the match? Register your information to find a buddy to explore the city with you!", style = 'color:black;'),
            actionButton(
              "tourGameCityBtn",
              "Tour the City with Me",
              style = "padding: 20px 40px; font-size: 20px; margin: 20px; border-radius: 12px; background-color:black; border-color:black; color:white;",
              icon = icon("map-marker-alt", class = "fa-lg")
            )
          ),
          div(
            style = 'margin-bottom: 30px; font-size:20px; padding: 20px; background-color: rgba(255, 255, 255, 0.8); border-radius: 10px;',
            h4("Watch a Game with Me", style = 'color:black; font-size:25px;'),
            p("Looking for someone to watch the game with? Share your interests and we'll help you find a companion to enjoy the match!", style = 'color:black;'),
            actionButton(
              "findWatchGameBtn",
              "Watch a Game with Me",
              style = "padding: 20px 40px; font-size: 20px; margin: 20px; border-radius: 12px; background-color:red; border-color:red; color:white;",
              icon = icon("futbol", class = "fa-lg")
            )
          ),
          div(
            style = 'margin-bottom: 30px; font-size:20px; padding: 20px; background-color: rgba(255, 255, 255, 0.8); border-radius: 10px;',
            h4("Join the Fan Community Forum", style = 'color:black; font-size: 25px;'),
            p("Want to share your thoughts on the match? Join our fan community forum and interact with other fans!", style = 'color:black;'),
            actionButton(
              "joinForumBtn",
              "Join the Forum",
              style = "padding: 20px 40px; font-size: 20px; margin: 20px; border-radius: 12px; background-color:yellow; border-color:yellow; color:black;",
              icon = icon("comments", class = "fa-lg")
            )
          )
        )
      )
    }
  )
  
  # Modal for tourGameCityBtn
  observeEvent(input$tourGameCityBtn, {
    showModal(
      modalDialog(
        title = "Tour the City with Me",
        textInput("name", "Name", placeholder = "Your Name"),
        textInput("phone", "Phone Number", placeholder = "Your Phone Number"),
        textInput("email", "Email", placeholder = "Your Email"),
        dateInput("tourDate", "Date of Tour"),
        textInput("tourLocation", "Preferred Tour Location(s)", placeholder = "Houston/Zapopan/Miami"),
        textAreaInput("additionalInfoTour", "Tell us more about what you're looking for:", "", rows = 3),
        footer = tagList(
          actionButton("submitTourGameCity", "Submit"),
          modalButton("Cancel")
        )
      )
    )
  })
  
  # Modal for findWatchGameBtn
  observeEvent(input$findWatchGameBtn, {
    showModal(
      modalDialog(
        title = "Watch a Game with Me",
        textInput("name", "Name", placeholder = "Your Name"),
        textInput("phone", "Phone Number", placeholder = "Your Phone Number"),
        textInput("email", "Email", placeholder = "Your Email"),
        selectInput("gameMatch", "Match", choices = c("Germany VS Colombia", "Germany VS Cameroon", "Costa Rica VS Germany")),
        textAreaInput("additionalInfoGame", "Tell us more about what you're looking for:", "", rows = 3),
        footer = tagList(
          actionButton("submitWatchGame", "Submit"),
          modalButton("Cancel")
        )
      )
    )
  })
  
  # Event for submitTourGameCity
  observeEvent(input$submitTourGameCity, {
    removeModal()
    sendSweetAlert(
      session = session,
      title = "Thank you!",
      text = "Thank you for your submission. We will contact you soon.",
      type = "success"
    )
  })
  
  # Event for submitWatchGame
  observeEvent(input$submitWatchGame, {
    removeModal()
    sendSweetAlert(
      session = session,
      title = "Thank you!",
      text = "Thank you for your submission. We will contact you soon.",
      type = "success"
    )
  })
  
  # Event for learnMoreActivities button
  observeEvent(input$learnMoreActivities, {
    showModal(
      modalDialog(
        title = "Community Activities",
        p("Join our community activities!"),
        actionButton("openFacebookGroup", "Visit Facebook Group", style = "margin-top:10px;"),
        footer = modalButton("Close")
      )
    )
  })
  
  # _event joinForumBtn----
  observeEvent(input$joinForumBtn, {
    browseURL("https://www.facebook.com/groups/699026340156788/?ref=share&mibextid=K35XfP&rdid=wYgvXKzsWL9A6gD8&share_url=https%3A%2F%2Fwww.facebook.com%2Fshare%2F9wrCWP4HDfTirGhk%2F%3Fmibextid%3DK35XfP")
  })
  
  # _event special event----
  observeEvent(input$eventButton, {wc$se = 1; wc$sen = 0})
  
  # _ui special event----
  output$uiSpecialEvent = renderUI(
    {
      event_prefix <- switch(wc$gm,
                             "1" = "hou",  # Houston events
                             "2" = "zap",  # Zapopan events
                             "3" = "mia"   # Miami events
      )
      
      div(
        style = 'padding:50px 10px 0 10px;',
        div(
          style = paste0(
            'background-color:rgba(255,255,255,0.8); padding:10px;'
          ),
          fluidRow(
            column(
              width = 6,
              style = 'height:80vh; overflow-y:scroll; overflow-x:hidden;',
              lapply(
                1:1,  # 每行显示一个事件
                function(i) {
                  fluidRow(
                    style = 'padding:10px 0 10px 0;',
                    lapply(
                      1:2,  # 每城市有两个事件
                      function(j) {
                        column(
                          width = 6,
                          tags$button(
                            id = paste0('se', (wc$gm-1)*2+j), 
                            class = 'btn action-button',
                            style = 'background-color:rgba(0,0,0,0); padding:0; margin:10px; border-radius:10px;',
                            img(
                              src = paste0('events/', (wc$gm - 1) * 2 + j, '.jpg'),
                              width = '100%',
                              style = 'border-radius:10px;margin-top: 30px;'
                            )
                          ),
                          div(
                            style = 'text-align:center; margin-top:5px;font-size:20px; margin-top:',
                            strong(
                              c(
                                "City-Exclusive Event", 
                                "One-Day Trip"
                              )[j]
                            ) 
                          )
                        )
                      }
                    )
                  )
                }
              )
            ),
            column(
              width = 6,
              uiOutput('uiSEInfo')
            )
          )
        )
      )
    }
  )
  
  
  observeEvent(input$se1, {wc$sen = 1})
  observeEvent(input$se2, {wc$sen = 2})
  observeEvent(input$se3, {wc$sen = 3})
  observeEvent(input$se4, {wc$sen = 4})
  observeEvent(input$se5, {wc$sen = 5})
  observeEvent(input$se6, {wc$sen = 6})
  
  # _ui special event info----
  output$uiSEInfo = renderUI(
    if (wc$sen > 0) {
      k = dbGetQuery(
        con,
        paste0(
          'SELECT * FROM special_events ',
          'WHERE event_id = ', wc$sen, ';'
        )
      )
      div(
        style = 'padding:20px; background-color:rgba(255,255,255,0.9); border-radius:10px; margin-top: 30px;',
        h2(k$name, style = 'margin-bottom:20px; text-align:center; font-size:28px; font-weight:bold;'),
        h3(k$location, style = 'margin-bottom:5px; text-align:center; font-size:22px; color:#555;'),  
        h6('(Meeting Point)', style = 'font-size:14px; color:#999; margin-top:0;'), 
        h3(k$date, style = 'margin-bottom:25px; margin-top:15px; text-align:center; font-size:20px; color:#777;'),
        p(k$description, style = 'margin-bottom:30px; text-align:justify; font-size:18px; color:#333; line-height:1.5;'),
        div(
          style = 'display:flex; justify-content:space-around; align-items:center; margin-top:20px;',
          actionBttn(
            inputId = 'registerBtn',
            label = 'Register',
            style = 'gradient',
            color = 'warning',
            size = 'md',
            block = FALSE,
            icon = icon('edit'),
            class = 'btn-lg'
          ),
          actionBttn(
            inputId = 'BackToCity',
            label = 'Back',
            style = 'gradient',
            color = 'success',
            size = 'md',
            block = FALSE,
            icon = icon('arrow-left'),
            class = 'btn-lg'
          )
        )
      )
    }
  )
  
  
  # Register Button Modal
  observeEvent(input$registerBtn, {
    showModal(modalDialog(
      title = "Register for Event",
      textInput("regName", "Name", placeholder = "Your Name"),
      textInput("regPhone", "Phone Number", placeholder = "Your Phone Number"),
      textInput("regEmail", "Email", placeholder = "Your Email"),
      radioGroupButtons(
        inputId = 'qtyPurchase',
        label = 'Party Size (Adults & Kids)',
        choices = 1:10,
        selected = 1
      ),
      footer = tagList(
        actionButton("submitRegister", "Submit"),
        modalButton("Cancel")
      )
    ))
  })
  
  # Submit Registration Event
  observeEvent(input$submitRegister, {
    removeModal()
    sendSweetAlert(
      session = session,
      title = "Thank you!",
      text = "Thank you for your registration. Please check your email for more event information.",
      type = "success"
    )
  })
  
  # _event purchase----
  observeEvent(
    input$packageBtn, 
    { 
      showModal(
        modalDialog(
          h3(paste0('All-Inclusive Package - Limited')),
          textInput(
            inputId = 'PurchaseName',
            label = 'Name',
            placeholder = 'Your Name'
          ),
          textInput(
            inputId = 'PurchaseEmail',
            label = 'Email',
            placeholder = 'Your Email'
          ),
          radioGroupButtons(
            inputId = 'qtyPurchase',
            label = 'Party Size (Adults & Kids)',
            choices = 1:10,
            selected = 1
          ),
          radioGroupButtons(
            inputId = 'PurchaseLocn',
            label = 'Games Attend',
            choices = c(
              'Houston' = 'Houston',
              'Zapopan' = 'Zapopan',
              'Miami' = 'Miami',
              'Houston & Zapopan' = 'Houston & Zapopan',
              'Houston & Miami' = 'Houston & Miami',
              'Zapopan & Miami' = 'Zapopan & Miami',
              'Houston & Zapopan & Miami' = 'Houston & Zapopan & Miami'
            ),
            selected = 'Houston'
          ),
          pickerInput(
            inputId = 'typeTix',
            label = 'Category',
            choices = c('Field Level' = 1, 'Upper Level' = 2, 'Luxury Box' = 3, 'Surprise Me' = 4),
            selected = 1
          ),
          textInput(
            inputId = 'FlightStart',
            label = 'Trip Start Date (Game1)',
            placeholder = 'DD/MM/YYYY'
          ),
          textInput(
            inputId = 'FlightEnd',
            label = 'Trip End Date (Game1)',
            placeholder = 'DD/MM/YYYY'
          ),
          textInput(
            inputId = 'FlightStart',
            label = 'Trip Start Date (Game2)',
            placeholder = 'DD/MM/YYYY'
          ),
          textInput(
            inputId = 'FlightEnd',
            label = 'Trip End Date (Game2)',
            placeholder = 'DD/MM/YYYY'
          ),
          textInput(
            inputId = 'FlightStart',
            label = 'Trip Start Date (Game3)',
            placeholder = ' DD/MM/YYYY'
          ),
          textInput(
            inputId = 'FlightEnd',
            label = 'Trip End Date (Game3)',
            placeholder = 'DD/MM/YYYY'
          ),
          p(
            style = 'margin-top: 40px; color: dark-gray; text-align: center; font-size:16px;',
            'All-Inclusive Packages are on a first-come-first-serve basis. Purchase now to get the GREATEST Deutscher Fans experience with the CHEAPEST Price. This package includes flight tickets to cities of the game and the match tickets you are planning to join, as well as three free meals of your choices on us. All rights are reserved.'
          ),
          footer = tagList(
            modalButton('Cancel'),
            actionButton('submitPurchase', 'Submit')
          )
        )
      )
    }
  )
  
  # _event submit RestRes----
  observeEvent(
    input$submitPurchase,
    { 
      removeModal()
      sendSweetAlert(
        title = paste0('Dear Mr./Ms. ', input$PurchaseName, ','),
        text = paste0('Thank you. We will send you an email confirmation shortly.'),
        btn_labels = 'OK',
        type = 'success'
      )
    }
  )
  
}
