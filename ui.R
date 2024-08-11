library(shiny)
library(shinyWidgets)

ui = fluidPage(
  tags$audio(id = "bg-music", src = "background_music.mp3", type = "audio/mp3", autoplay = TRUE, loop = TRUE),
  
  tags$script(HTML('
    document.addEventListener("DOMContentLoaded", function() {
      var audio = document.getElementById("bg-music");
      setTimeout(function() {
        audio.pause();
      }, 30000); // 30000 milliseconds = 30 seconds
    });
  ')),
  
  
  div(
    title = 'World Cup 2026 - Germany', # what appears on browser tab
    setBackgroundImage(src = 'home.jpeg'), # background image
    align = 'center',
    style = 'color:white; font-size:36px; font-weight:bold; margin-top:20px; text-shadow: 2px 2px 4px gold; position:relative;',
    "FIFA World Cup 2026 - Exclusively For Deutscher Fans",
    div(
      style = 'width:100%; height:5px; background-color:gold; position:absolute; bottom:-25px; left:0;', 
    )
  ),
  uiOutput('email'),
  tags$head(
    tags$style(HTML("
    .date-container {
      margin-bottom: 20px; 
      margin-top: 60px;
    }
  "))),
    tags$head(
      tags$style(HTML("
    .time-container {
      margin-bottom: 60px; 
      margin-top: 20px; 
    }
  "))),
  tags$style(HTML("
    @keyframes pulse {
      0% {
        transform: scale(1);
      }
      50% {
        transform: scale(1.1);
      }
      100% {
        transform: scale(1);
      }
    }
    .pulse-animation {
      animation: pulse 1.5s infinite;
    }
  ")),
  div(
    align = 'center',
    fluidRow(
      column(
        width = 11,
        uiOutput('uiMain')
      ),
      column(
        width = 1,
        style = 'padding-top:5vh;',
        # gnt button----
        div(
          style = 'padding:20px 0 10px 0;',
          tags$button(
            id = 'gnt',
            class = 'btn action-button',
            style = 'background-color:rgba(0,0,0,0); padding:0; margin:0; border-radius:50%;',
            img(
              src = 'gnt_logo.png',
              width = '100%',
              style = paste0(
                'border:solid white 5px; ',
                'border-radius:50%;'
              )
            )
          ),
          h5(style = 'color:white; font-size:18px;', 'Team Deutscher')
        ),
        # venue buttons----
        lapply(
          1:3,
          function(i) {
            div(
              style = 'padding:20px 0 0 0;',
              align = 'center',
              tags$button(
                id = paste0('city', i),
                class = 'btn action-button',
                style = 'background-color:rgba(0,0,0,0); padding:0; margin:0; border-radius:10px; font-size:15px;',
                img(
                  src = paste0('city_', c('hou', 'gua', 'mia')[i], '.jpeg'),
                  width = '100%',
                  style = paste0(
                    'border:solid ', 
                    c('black', 'red', 'gold')[i], ' 5px; ',
                    'border-radius:10px;'
                  )
                )
              ),
              h5(style = 'color:white; font-size:18px;', c('Houston, TX', 'Zapopan, Mexico', 'Miami, FL')[i])
            )
          }
        ),
        # wc link----
        div(
          style = 'padding:20px 0 0 0;',
          tags$a(
            href = 'https://www.fifa.com/en/tournaments/mens/worldcup/canadamexicousa2026',
            target = '_blank',
            img(
              src = 'wclogo.webp',
              width = '50%'
            )
          ),
          h5(style = 'color:white;font-size:18px;', 'FIFA News')
        )
      )
    )
  ),
  div(
    style = 'position:fixed; bottom:20px;',
    actionBttn(
      inputId = 'homeBtn',
      label = 'Home',
      style = 'minimal', 
      color = 'default',
      size = 'sm',
      icon = icon('home')
    ),
    actionBttn(
      inputId = 'aboutBtn',
      label = 'About Us',
      style = 'minimal', 
      color = 'default',
      size = 'sm'
    ),
    actionBttn(
      inputId = 'communityBtn',
      label = 'Community',
      style = 'minimal', 
      color = 'default',
      size = 'sm'
    ),
    actionBttn(
      inputId = 'packageBtn',
      label = 'Purchase All-Inclusive Package',
      style = 'minimal', 
      color = 'warning',
      size = 'sm',
      icon = icon('star')
    )
  )
)
